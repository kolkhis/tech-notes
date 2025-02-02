# Network Storage
Network storage is different from Direct-Attached Storage (DAS), which is local-only 
storage only accessible to one machine.  

## Table of Contents
* [Types of Network Storage](#types-of-network-storage) 
    * [Network-Attached Storage (NAS)](#network-attached-storage-nas) 
    * [Storage Area Network (SAN)](#storage-area-network-san) 
    * [Cloud Storage](#cloud-storage) 
    * [Distributed File Systems (DFS)](#distributed-file-systems-dfs) 
    * [Object Storage](#object-storage) 
    * [Hybrid Storage Solutions](#hybrid-storage-solutions) 
* [NFS DCNAS Volumes](#nfs-dcnas-volumes) 
    * [Features of an NFS DCNAS Volume](#features-of-an-nfs-dcnas-volume) 
    * [Common Use Cases](#common-use-cases) 
    * [DCNAS Platforms](#dcnas-platforms) 
    * [Mounting an NFS DCNAS Volume](#mounting-an-nfs-dcnas-volume) 

## Types of Network Storage

Storage over a network is done in several ways:  
* Network-Attached Storage (NAS): File-based, shared over the network.  
* Storage Area Network (SAN): Block-based, shared over the network.
* Cloud Storage: Flexible and remote.  
* Object Storage: Metadata-rich. Great for unstructured data.  
* Distributed File Systems (DFS): Scalable for large-scale file storage.  
* Hybrid Storage Solutions: Mix of on-prem and cloud storage.  

### Network-Attached Storage (NAS)

NAS is a dedicated device connected to a network that provides centralized,
file-based storage.  

NAS is easy to set up and manage, and provides shared access to files for multiple users.  

Access protocols:
* NFS (Network File System) for Linux
* SMB (Server Message Block) for Windows
* APF (Apple Filing Protocol) for macOS

Use cases:
* Media sharing over home networks.  
* Small businesses for centralized file storage.  

### Storage Area Network (SAN)
A SAN is a high-speed network that connects storage devices to servers. 
It appears as a local storage device to the operating system.  


Provides block-level storage for databases and VMs. Usually has high performance and
low latency.  

Access protocols:
* iSCSI (Internet Small Computer Systems Interface)
* Fibre Channel
* FCoE (Fibre Channel over Ethernet)

Use cases:
* Enterprises that require fast and reliable storage for mission-critical data.  
* Virtualized environments.  


### Cloud Storage
Data storage offered as a service over the internet by providers like AWS, Azure, or
Google Cloud.  

This is scalable, and usually a pay-as-you-go model.  
Accessible anywhere with an internet connection.  

Access Protocols:
* APIs (RESTful, GraphQL, SOAP, etc.)
* Web interfaces and desktop clients.  


Use cases:
* Backup and disaster recovery (DR)
* Collaboration and file sharing
* Storage for web applications

### Distributed File Systems (DFS)
A file system that spans multiple servers or locations to provide a unified
namespace.  

Provides fault tolerance and redundancy, and scalability for large datasets.  

Examples:
* Hadoop Distributed File System (HDFS)
* GlusterFS
* CephFS

Use cases:
* Big data analytics
* High-availability storage for web-scale applications

### Object Storage
Stores data as objects with metadata rather than as files or blocks.  

Ideal for unstructured data like multimedia or backups.  
Object storage is infinitely scalable.  

Examples:
* Amazon S3
* OpenStack Swift

Use cases:
* Archival storage.  
* Content delivery networks (CDNs)


### Hybrid Storage Solutions
Combines local storage (NAS/SAN) with cloud storage for flexibility and cost
efficiency.  

Can provide seamless data transfer between on-prem and cloud storage.  
Ideal for businesses transitioning to the cloud.  

Use cases:
* Backup strategies
* Cloud bursting for peak demand



---

## NFS DCNAS Volumes
An NFS DCNAS volume refers to a Network File System (NFS) volume hosted on a 
Distributed Cloud NAS (DCNAS) platform.  

It is a shared storage resource (volume) provided by a Distributed Cloud NAS system, 
accessible via the NFS protocol. 

1. NFS (Network File System):
   * A protocol that allows file sharing over a network.
   * Developed for Unix/Linux systems but also works with other operating systems.
   * Enables users or applications to access and manage files on remote servers as if they were local.
   * Commonly used in environments where multiple systems or applications need to share files.

2. DCNAS (Distributed Cloud NAS):
   * A Network-Attached Storage (NAS) solution hosted in a distributed and/or cloud-based infrastructure.
   * NAS: A specialized file storage device that connects to a network and provides centralized storage for multiple clients.
   * Distributed Cloud NAS: Enhances NAS by spreading storage across multiple servers, locations, or cloud regions to improve performance, redundancy, and scalability.
   * Examples: Services like NetApp Cloud Volumes or solutions from companies like QNAP, Synology, or hybrid cloud providers.

3. Volume:
   * A logical partition of storage space within a storage device or array.
   * In the context of NFS and DCNAS, a "volume" is a unit of storage configured to be shared using the NFS protocol.

---

This type of storage is good for:
* High availability. Distributed architecture minimizes downtime.
* Efficient file sharing. Enables seamless collaboration in multi-user environments.
* Cost-effeciency. Cloud-based storage usually offers pay-as-you-go pricing.
* Compatibility. Works with many operating systems and applications.


### Features of an NFS DCNAS Volume

* Has distributed storage. 
    * The volume is stored across multiple servers or cloud nodes, ensuring high availability and fault tolerance.
* Flexible and scalable.  
    * Volumes can grow as needed, allowing for flexible storage management.
* Accessible from any machine with NFS support.  
    * Any client machine with NFS support can access the volume over the network, as long as proper permissions are set.
* Supports a centralized management interface.  
    * Administrators can manage all volumes through a centralized interface provided by the DCNAS.

---

### Common Use Cases

* Enterprise Storage
    * Sharing large datasets among servers or workstations in an organization.
* Hybrid Cloud Workflows
    * Integrating on-premise systems with cloud storage for flexibility and scalability.
* Containerized Applications
    * Providing persistent storage for container orchestration platforms like Kubernetes.
* Big Data and Analytics
    * High-performance storage for processing large volumes of data.
* Backup and Archiving
    * Centralized repository for backups, with easy network access for restores.

---

### DCNAS Platforms
* DCNAS providers for commercial use:
    * NetApp Cloud Volumes
    * Qumulo
    * Panzura
    * Nasuni
    * Cohesity SmartFiles

* Self-hosted DCNAS options:
    * Open-source options:
        * Ceph
        * GlusterFS
        * OpenIO
        * SeaweedFS
    * Commercial self-hosted options:
        * TrueNAS SCALE
        * Storj
        * MinIO
        * NetApp StorageGRID


Just starting out, looking for a open-source/self-hosted solution, TrueNAS SCALE and
Ceph seem to be good options.  
* TrueNAS SCALE is easier to set up, and has a user-friendly web interface.  
* Ceph is best for large-scale, high-performance needs but has a steeper learning curve.  


### Mounting an NFS DCNAS Volume

1. You'd create the volume using the DCNAS platform's interface to configure an NFS volume.  

2. Mount the Volume: 
   * On the client system (e.g., Linux), mount the volume using the NFS protocol.
   * Example command:
     ```bash
     sudo mount -t nfs <DCNAS_server_IP_or_hostname>:/volume_name /local_mount_point
     ```

3. Access the Files: Once mounted, the remote files can be accessed and managed like local files.




