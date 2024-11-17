# `jq` - JSON Processing Tool


`jq` is an essential tool to learn.  
It's a command line tool that allows you to query and transform JSON data.  

It's described as a `sed`/`awk`/`grep` for JSON.  





## `jq` Installation
* [Source](https://github.com/jqlang/jq?tab=readme-ov-file#installation)

* Most Linux distributions have `jq` available via their package managers.  
Debian-based:  
```bash
apt-get install jq
```
RedHat-based:  
```bash
dnf install jq
```

### Running `jq` as a Container
There's a container image available for `jq` stored on GitHub.  

Extracting the version from a `package.json` file with a mounted volume:
```bash
podman run --rm -i -v "${PWD}:${PWD}" -w "${PWD}" ghcr.io/jqlang/jq:latest '.version' package.json
```




## `jq` Learning Resources

* [Official Documentation](https://github.com/jqlang/jq)
* [jq Online Playground](https://jqplay.org/)
