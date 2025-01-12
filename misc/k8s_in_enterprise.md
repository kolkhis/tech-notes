# Immutability - Kubernetes in the enterprise 
Notes from a talk by MPesa.  



Immutability - treating machines as interchangable cattle instead of pets.  
Implementing immuntability concepts greatly improves security posture.  




## Immutability core concepts
A home server configured by hand would be considered a pet.  

* Rebuild servers in stead of patching in place
* Use configuration as code to avoid configuration drift
* Enables speedy deployments and rollbacks
* All installed software should be requried and auditable.  

Immutability prevents snowflake/pet servers.
- No servers that have been around for 12 years with a bunch of patches (not easily rebuilt)
- Immutability greatly reduces the potential for configuration drift
- Enables consistency across environments
- More trust and confidence during releases and rollbacks.  


## Linux distros that are good for immutability

These are more kubernetes-sphere distributions.  

### Talos Linux
Immutable and minimal distribution for Kubernetes odes.
- It's basically just five Go binaries and a linux kernel.
- No SSH, systemd, glibc, package manager, or even a shell.  
- Filesystem is read-only, except for a few ephemeral directories for runtime data

Configuration management is declarative and API-driven
- The `talosctl` tool can be used to administer clusters
    - Used for various node and cluster operations

It's secure by default
- Uses key-based auth and encrypted traffic everywhere
    - No passwords of any sort, no users
    - Uses it's own PKI infrastructure
- Talos generates short-lived certificates that are automatically rotated

The whole SSH attack vector is gone. There's no shell. If they gain access to a
container and then the host system, they won't be able to do much.  


### Flatcar and CoreOS

Derivatives of the discontinued Container Linux distro
- Configured at provisioniong time using Ignition configs
    - Easy to provide Ignition configs on most cloud platforms
    - For bare metal deployments, use smth like Matchbox
        - Every time they restart they'll reload their ignition configs
- Both use an immutable filesystem (read-only).  
- SSH access is still allowed.  
- Not API driven like Talos.  

Anything that can PXE boot can take Ignition configs.  
You should be doing everything here with Ignition.  


## Minimal Container Images
Not the same thing as immutability, cuz containers are already usually immutable.  
- Base container images that only includes the required application runtimes.  
- No package mangers, shells, or debugging tools are included.  
- Use multi-stage builds to build apps without including build dependencies
- Why does this matter?
    - Significantly reduces attack surface.
        - Lack of a shell prevents many exploits
    - Increases signal to noise ratio in vulnerability reports (TODO:)
        - Signal to noise: Relevant data vs non-relevant data.  
    - Faster builds and deployments


E.g., you might not need GCC/clang for the final runtime environments, only for dev environments.  

Using a minimal container image in conjunction with Talos reduces the change of
common exploits exponentially.  

### Options for Minimal Container Images
Google Distroless
- Based on Debian


Chainguard
- Based on Wolfi, a linux "undistro"
    - Not designed to be a full distro, just for getting critical runtime
      applications into the container
- Provides SBOM for installed packages (see [supply chain security](#supply-chain-security))
    - BOM is a commonly used system for Architectural, Mechanical, Electrical design, wherein each part of an assembly is tracked.

Alpine
- Not a distroless image, but still lightweight
- Uses musl instead of glibc and Busybox instead of GNU coreutils

### Supply chain security
SBOM (Software Bill of Materials)
- List of libs, packages, versions, and licenses for a container image
- Uses a machine-readable for mat for use with automated security tools
- A list of what's built, at what time, where it's running at

Software attestation
- Authenticated metadata about a software artifact, such as a container image
- Allows end users to verify the integrity of the artifact.  


If you naively use a ubuntu or debian base, you're wasting so many resources that
could be used for the application.  

## Immutable Environment Challenges
- No SSH access
- Nodes and pods to not have debugging tools installed
- Infrastrucutre is short-lived and replaced rapidly
- Filesystems are read-only and often ephemeral
- IaC misconfigurations can result in wide-spread outages

### Observe and Debug in Immutable Environments
* Use centralized logging and metrics platforms
* Monitor services and clusters rather than pods and nodes.
    * These are the only two sources we get logs from, and where most problems will
      come from.  
* Spin up ephermeral debug pods or sidecar containers
    - This is how you will handle problems that you can't determine from the logs
* Use a declarative approach to observability configurations

We don't wanna treat these pods as long-lived.  
We want our nodes and pods to be cattle, not pets.  

---

Don't rely on having access to the node or pod to know what is going on inside it.  


## GitOps and Declarative Infrastructure
GitOps: 
You use a central git instance.
When code is merged to a branch, it goes through automated tests and gets deployed.  
Maybe even tested before it gets merged.  
Things are automatically deployed when they're committed to the Git branch.  


Key principles:
Git is the single source of truth for infrastructure definitions.
Automated reconfiliation through tools like ArgoCD.  

---

Why does it matter?  
All changes to infrastructure are revertible and auditable.  
Prevents unauthorized or ad-hoc configuration changes.  

---

GitOps and CI/CD are not exactly the same.  

Running CI tests on code when released, that's GitOps principle.  
CI - Testing of the code when it's pushed
CD - Deployments

## GitOps Challenges
- Subtle configuration drift across environments can occur
    - the more things you have *outside* your pipelines, the more complicated GitOps will be, and the less you will trust the process.  
- Risk of manual changes not being committed bakc to Git
- Rollout across staging environemtns (dev -> staging -> prod)
- Scaling to hundreds+ of clusters
- Different teams might share clusters by need distinct deployment strategies.  
- Secrets cannot be stored in Git.  

## Gitflow/Workflows
* Devs create long-lived feature branches
* Separate primary branches for dev, hotfixes, and releases.  
* master/main/trunk (dev branch) isn't assumed to be stable or deployable.  
* Multi-environments deployments can use separate release branches.  
* Complex merging stragegy, especially for hotfixes.  

## Trunk-based Development
* Developers make smaller branches that are committed to main more frequently.  
* Trunk is assumed to be stable and deployable.  
* Faster feedback loop.  
* Separate env typically using overlays (env/dev, env/prod).  


## Reproducable Dev Environments
Devs have machines with different packages installed, and the CI pipeline may have
its own versions as well.  

Reproduceible dev environments:
- Are a solution to "but it works on my machine" syndrome
- Reduce onboarding delays for devs joining a project
- Help detect issues before code is committed

Immutability and consistency aren't just for prod - they start in the development
process. 

---

## Devbox
Uses Nix under the hood to create reporoducible environments.  
Allows you to declaratively define your env for consistent tooling between devs and CI platform.  
Easy to use GH actions pipelines.  
Prevents cross-project contamination and dependency issues.  
Easy to rollback to previous versions.  


## Resources
* https://www.talos.dev/v1.9/introduction/quickstart/
* https://github.com/GoogleContainerTools/distroless
* https://images.chainguard.dev
* https://images.chainguard.dev/directory/image/static


## Terms
kube-prometheus-stack

`just` - `justfile`

Why `just` instead of `ansible`?
HAProxy
Matchbox
Synology (NAS-related?)
AWX
cloud-init

(open)SUSE MicroOS

Devbox allows you to install, for example, a `python3.11` version for a specific
directory. It sets up a small, isolated environment.  
```bash
devbox add python3.11
devbox shell
```

