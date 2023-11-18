
# Notes for API Academy's "A Guide to REST and API Design"

## Style vs. Standard

Standards are rules that governing bodies make. Styles are not enforced.

REST is a "style", while HTTP is a "standard."

## Six Constraints of REST

Restraints serve to minimize latence and network comms, while
maximizing independence and scalability.

1. Client-Server
    * Requires service to offer one or more operations.
    * Requires service to wait for clients to request these operations.

2. Stateless
    * Requires comms between 'client' and 'server' to be **"stateless."**

3. Cache
    * Requires responses to bve clearly labeled as
      "cacheable" or "non-cacheable."

4. Uniform Interface
    * Requires all "service providers" and "consumers" within
      a REST-compliant architecture to share a single **common**
      interface for all operations.

5. Layered System
    * Requires the ability to add or remove intermediaries
      at runtime without disrupting the system.

6. Code-on-Demand (Optional)
    * Allow logic within **Clients** to be updated *independently* 
      from **server-side** logic using executable code shipped from
      "service providers" to "consumers."
    * Allow Client logic to be updated *independently* from Server-side logic
      using code shipped from the Server to the Client



## The Connector is NOT the Same as the Component

### Components

Components work to solve problems in unique ways.

MySQL works differently from SQL server, CouchDB, MongoDB, etc....

The way you...
* Queue up information.
* Decide when a transaction starts & ends.

... are local features of the component which can be manipulated by the developer.

They are the developer's components, his tools/lang/OS, and therefore **private**.

### Connectors

The connectors are **public**.

These are the standardized pipes that all developers work with.  

Everyone should agree to transmit information back and forth using 
**standardized** public connectors.

### Keep Them Separate

Keep components and connectors separate, making it easier to interchange them later on.

* The code for your web server is designed to speak to many devices on the public internet.
* The code for your components is designed to speak to the tools you have available to you.



## Ensuring the Connectors Work Together

The uniform interface contraint is **fundamental** to REST services.

It simplifies and decouples connectors, each part can evolve independently.



## URIs for Identification

Uniform Resource Identifier (URI)
* Compact string of chars for identifying an abstract of physical resource

This identifier can be realized as
* a Uniform Resource Locator (URL)
* or a Uniform Resource Name (URN)

URLs identify online locations of resources.
URNs should be persistent, location-independent identifiers.

The URN is someone's name, and the URL is their street address.  
The URN defines an item's indentity, and the URL is a method for finding it.  

The **Components** of a URI:
* Scheme Name
    * Identifies the Protocol (HTTP:, IRC:, HTTPS:, FTP:)
* Hierarchial Part
    * Holds info that's hierarchial in nature
        * Authority
            * The server's actual DNS resolution (domain name/IP)
        * Path
            * segments/separated/by/slashes (website path)
    * This is the URL the client would access.
* Query
    * Addition identification info that's NON-hierarchial, separated by "?"s.
        * These are the arguments
        * Part of the URL the client would access
* Fragment
    * Directions to a secondary resource within the primary one
      identified by the Authority and Path, separated with a hash ("#")
    * A section of the page denoted by "#" (appended to the URL by the client)

```
Structure of URIs

URL:   foo://example.com:8042/over/there?name=ferret#nose
      \__/   \______________/ \________/ \_________/ \__/
       |            |             |           |       |
    Scheme      Authority       Path        Query    Fragment
      ___  _________|____________|_  
      / \ /                        \
URN:  urn:example:animal:ferret:nose


```
So the URN has only the "scheme," "authority," and "path" (3 components).
Whereas the URL contains all 5 components of a URI.









