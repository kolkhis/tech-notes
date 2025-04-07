# Kernel Panic

A kernel panic is basically the Linux kernel saying, "I hit a critical error and can't safely continue."  
It's like the Linux equivalent of the Windows Blue Screen of Death (BSOD).

Some conditions trigger an immediate panic, while others allow the system to recover 
or keep going. 

## Kernel Panic Settings (`sysctl`)
These `sysctl` settings control how the system reacts when specific failures occur.

```bash
sysctl -a | grep -i 'panic'
```

| Setting | Value | What it means |
|--------|-------|----------------|
| `kernel.panic` | `0` | After a panic, the system will **not automatically reboot**. |
| `kernel.panic_on_oops` | `0` | The system **will not panic** if a kernel "oops" (non-fatal bug) occurs. |
| `kernel.hardlockup_panic` | `1` | If a **CPU lockup** is detected (e.g. no heartbeat), the system **panics**. |
| `kernel.hung_task_panic` | `0` | Long-running/stuck tasks **won’t cause a panic**. |
| `vm.panic_on_oom` | `0` | The system **will not panic** if it runs out of memory (OOM). |
| `kernel.panic_on_warn` | `0` | Kernel warnings (via `WARN()`) do **not trigger panic**. |
| `kernel.panic_on_rcu_stall` | `0` | RCU (Read-Copy-Update) stalls won't cause panic. |
| `kernel.panic_on_unrecovered_nmi` | `0` | Unrecoverable NMIs won't panic the system. |
| `kernel.unknown_nmi_panic` | `0` | Unknown NMIs also won’t cause a panic. |
| `kernel.panic_print` | `0` | Controls what info is printed on panic — 0 means minimal info. |


