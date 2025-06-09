# Prompt Engineering

## Prompt Components

| Section         | Purpose                            | Example                            |
| --------------- | ---------------------------------- | ---------------------------------- |
| **Instruction** | The task to perform                | "Summarize the following text."    |
| **Context**     | Background info or facts           | "You're a security expert..."      |
| **Input**       | Data to be processed               | "Text: Alice has a cat named Bob." |
| **Constraints** | Rules, formatting, tone, etc.      | "Reply only in Bash."              |
| **Examples**    | Few-shot examples (Q/A pairs)      | "Q: ... A: ..."                    |
| **Anchors**     | Text markers for segmenting prompt | `### INSTRUCTION ###`              |


## Prompt Anchors

| Anchor Type    | Example                              | Use Case
| -------------- | ------------------------------------ | ---------
| Section Header | `### TASK ###`                       | Splitting prompt stages
| Block Marker   | `<START> ... <END>`                  | Defining a parsing region
| Role Marker    | `<\| user\|>`,`<\|assistant\|>`      | Multi-turn conversations
| Variable Slot  | `{input_text}`                       | For template-based engines
| Invisible      | `\u200B`, `\u2060`                   | Steganographic delimiters or anti-collapse padding
```plaintext
```


## Prompt Structure

```text
[System Prompt]
You are a helpful assistant that speaks only in JSON.

[User Prompt]
### TASK ###
Explain what a PID is in Linux.

### FORMAT ###
Answer in Markdown, with a code block if needed.
```

## Prompt Templates

Reusable prompt templates could look like this:

Instruction-only:
```text
Summarize this in one sentence:
{input}
```

Instruction + input block:
```text
### TASK ###
Rewrite this into simpler English.

### INPUT ###
{input}

### OUTPUT ###
```

System + user prompt:
```text
System: You are a cybersecurity analyst.
User: Classify this log entry as INFO, WARN, or ERROR.
```

