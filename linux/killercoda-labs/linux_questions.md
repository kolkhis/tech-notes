# Security Engineering Intern Questions

Messy notes. Move along.

What is the Security Triad?

   - What does the acronym CIA mean?
   * confidentiality, integrity, availability
   
What is SAST and DAST?

   - When would you use each of them?
   
   (If they don't know this)
   
   What do we mean by white or black box testing?
    * white: all knowledge
    * black: no real knowledge aside from company name
   What is the difference between functional and non-functional testing?
      
   (IF they know this, do they know what IAST is?)      
      
## Do you know what the OWASP top ten is?

   - Do you know what the OWASP top ten for APIs are?

## How do we protect data at rest? How does this differ from protecting data in motion?

    - Symmetric keys - envelope encryption (AES256 is cloud MINIMUM standard)

rest: Envelope Key Encryption. 
plain text/cipher text - goes thru cipher - symmetric encryption
envelope key encryption (AWS KMS): [KMS: Key management service](https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html)
Two Versions:
 * KMS key (decrypts the data)
Get rid of plaintext data key
Encrypted Data Key (needed to get the KMS key)


    - Asymmetric keys for handshake and then symmetric agreed upon keys for movement of data.

Different keys, but cryptographically similar
If encrypted on one side, ONLY the other side can decrypt it
Public/Private Keys. 
* SSH uses asymmetric keys for authentication, then uses symmetric keys for normal operation
  (movement of data)
* TLS uses Asymmetric keys for handshake, then symmetric agreed upon keys for movement of data

   
   (If they knock this out of the park)
   
    - Can you explain the TLS 1.3 handshake process? 
* TLS uses Asymmetric keys for handshake, then symmetric agreed upon keys for movement of data
   
   (Do they understand how it is streamlined from the 1.2? Do they understand that it is asymmetric and then negotiates symmetric and why that matters?)

## What is NIST? Do you know any of the NIST standards?
CIS Benchmarks
* Governance
* Risk 
* Compliance - adhering to your standards

* A: National Institute for Standards and Technologies.  
  [Can be found here](https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-145.pdf)

  NIST standards - most companies are not beholden to NIST in any way.  

   (If they say no)
   -  What security standards are you familiar with? (HIPAA, PCI-DSS, GDPR)

HIPAA: Health Insurance Potability and Privacy and Accountability act
    * comes from US gov't

GDPR: General Data Protection Regulation  
    * comes from EU
^ These standards MUST BE adhered to if in their jurisdiction.
  If they aren't adhered to, someone is going to jail.

PCI-DSS: 
^ No one is REQUIRED to adhere to this. But if you want to take credit card
  information, you need to adhere to PCI-DSS
  PCI-DSS requires a 3rd party audit

all RedHat machines have `sosreport` cmd. 
pcsp.exe: cmd.exe

   (If they say yes)
   -  Can you explain one of the standards to me?

## Can you describe the working concepts of a firewall?
[Networking Primer](https://www.youtube.com/watch?v=KgqvYeT_l7M)  
portswigger.net/web-security
One thing most firewalls do: Blocks connections from certain ports
Security guy at the gate: If you're not on the list, you don't get in
   - What is a Next Generation Firewall?
 Can know more things about the entire stack
 Application-aware
   - What is a WAF? What layer(s) of the OSI model does it operate at?
 Web Application Firewall
 AWS has WAF

   - What is meant by the term embryonic connection? (in TCP?)
   - What is meant by stateful or stateless?
   
## What do you know about the Mitre attack framework?
 * Mitre attack searching through tables of known bad actors

Another attack framework: CDH 
   - Why might you want to know about it?

## What is a CVSS Score?

   - How do we use them?
   - What does triage mean, in a security setting?
  
## What is the difference between an exploit and a vulnerability?

   - How do these differ from an exposure?

## What are the risk treatments you can use?

   - Risk avoidance, Risk mitigation, Risk Transfer (selling/buying), Risk acceptance.
   - What is the difference between qualitative and quantitative risk analysis?
     - When would you use each?

How would you go about hardening a server?

   - Update software
   - Remove unused software
   - Turn on firewalls
   - Change default passwords/usernames
   - Disable root login
   - Disable password login (keys or certs only?)
