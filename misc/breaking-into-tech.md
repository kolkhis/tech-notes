# Breaking Into Tech (notes)

## Self Assessment
- What's a self assessment matrix? What's SWOT analysis? SMART goals? Linux/Security/Networking job actifities? What is ikigai?

1. Self-assessment matrix

An example of this:

| Skill area           | Current level | Target level | Evidence                | What to improve                  |
| -------------------- | ------------: | -----------: | ----------------------- | -------------------------------- |
| Linux administration |           4/5 |          5/5 | Homelab, RHEL labs      | SELinux, troubleshooting         |
| Bash                 |           4/5 |          5/5 | Scripts, automation     | More POSIX shell                 |
| Networking           |           3/5 |          4/5 | VLANs, routing, HAProxy | DNS, routing protocols           |
| Ansible              |           4/5 |          5/5 | Server deployments      | Testing, advanced roles          |
| Kubernetes           |           3/5 |          4/5 | kubeadm cluster         | Storage, RBAC, troubleshooting   |
| Security             |           2/5 |          4/5 | Linux hardening labs    | IAM, auditing, incident response |
| Python               |           3/5 |          4/5 | Bots/tools              | Packaging, testing               |
| Git                  |           3/5 |          4/5 | Personal projects       | Advanced history/rebase          |

You might use levels such as:

- 1 — Awareness: I know what this is.
- 2 — Beginner: I can do basic tasks with instructions.
- 3 — Competent: I can do normal work independently.
- 4 — Advanced: I can troubleshoot difficult problems.
- 5 — Expert: I can design systems and teach others.

The important part is the evidence column.

---

3. SWOT analysis
    - SWOT stands for:
        - Strengths
        - Weaknesses
        - Opportunities
        - Threats

---

4. SMART goals

SMART is a framework for making goals concrete.

It usually means:

S — Specific
M — Measurable
A — Achievable
R — Relevant
T — Time-bound




---

5. Ikigai

Ikigai is a Japanese concept roughly related to:

- A reason for living / something that gives your life meaning or makes life worth living.

You may have seen this diagram:
```bash
              What you love
                   │
                   │
        ┌──────────┼──────────┐
        │                     │
What you're good at       What the world needs
        │                     │
        └──────────┼──────────┘
                   │
          What you can be
            paid for
```
The center gets labeled Ikigai.




---

Assessment topics:
- What provides you satisfaction
- Identify your top 3 professional skills
- which are most valuable to you (sense of community, achievement, intellectual
  challenge, etc)


Methodology:

- purpose
    - Self assessment to determine skills and skill gaps
- scope
    - Questions around current tech skills and interests, and currect business
      skills and interests
- out of scope
    - team needs an external assessment
- methodology
- control


Linux
Storage
Security

---

SWOT analysis

Internal: within your control
- strengths
- weaknesses

external: Outside your control
- opportunities: courses you can take, market needs, employment opportunities
- threats: market saturation. industry moves quickly (geo/political)

Generally speaking, as you can always affect them somewhat


### Final deliverable for this section

- Know what you want to do in IT
    - Linux Systems Engineer
    - DevOps
    - Automation Engineer 
- Know your strengths and weaknesses and how they will help or hinder your goal
- Know the opportunities and threats in the industry


## Learning Linux

- How do I learn the Linux command line?
- Monitor the performance of Linux/Unix systems?
- What is/How do I learn Bash/Python scripting?
- What are some troubleshooting methodologies?
- What are the automation tools popular for Linux currently?
- What are some common Linux admin tasks?
- SMART methodology for a 6-month timeline of learning Linux


## Hands On Labs
- killercoda.com
- sadservers.com
- learngitbranching.js.org/?locale=en_US
- w3schools.com
- codingbat.com


We gotta make our fingers less stupid.


## Certification Paths
Certs are a great way to wrap your head around the "what comes next" part of
learning something.  

In a completely unguided environment (e.g., homelab), you
may do all kinds of deployment and startup troubleshooting, but never get into
disk management or memory usage topics.  

In that way, there's a gap, and studying the body of knowledge(BOK) around a 
cert will help fill the gaps.  

Will it make you an expert? No, but i'll make you more well rounded for 
anything you may do in the industry.  

### Free Certs

General Engineering:

- Six Sigma process improvement white belt
    - <https://www.sixsigmacouncil.org/six-sigma-white-belt-certification>
- lean six sigma process improvement (white belt)
    - <https://www.sixsigmacouncil.org/lean-six-sigma-white-belt-certification>
- API lifecycle and security (three courses)
    - <https://apiacademy.co/>
- Gremlin Chaos Engineering
    - www.gremlin.com/community/tutorials/chaos-engineering-the-history-principles-and-practice

Networking:
- IPv6
    - <https://ipv6.he.net/certification>

Free training where cert is NOT free:

- All other belts of 6Sigma
- Terraform
    - https://developer.hashicorp.com/terraform/tutorials/certification-003/associate-study-003
- Vault
- Data Science
- General Web
- General LKinux
- Web Security


#### Final Deliverables for this section

Have a scheduled time to study 30 min every day

Know the exact BOK documents for the topics you wanna learn
- Pick at least one of the free certs to bolster resume

Know the exact resources you'll use to learn the topics

Have a 3-6 month plan based on SMART goals to prep to work in this space

Plan to conitnue to learn troubleshooting with your own lab env and reading
blogs on tech deployments

Find a group of like-minded people that are working on the same things 


## Working in Tech

Third AI activity (10 min)

What types of meetings and I going to do in tech? (What are standup meetings,
ECB/CAB meetings? What are tiger teams? What are managmeent and skip level
meetings?) 

Where does work come from for Linux admins in an operational environment?

What are environments (dev, test, qa, prod)? How do they differ?

What are policies, procedures and documentation in tech?

Types of documents: What is a POAM? What is an RTACI Chart?

Fit for warranty and Fit for use defninition. What is a proof of concept? What
is a minimum viable product? 

What is uptime? What are KPIs?

---


The PPDIOO process (comes from Cisco)
- Prepare
- plan
- design
- implement
- operate
- oprimize


---

Where pressure comes from when working in tech:

- Entropy (all systems break down over time)
    - Refresh cycles of hardware to stay current as well as warrantied.
    - All protocols, ciphers, and services are eventually beaten and fade to
      obscolecesnce.  

- External
    - Web and API calls always increasing
    - Email and data flow
    - Advanced persistent threats and script kiddies
- Internal
    - Capacity need for more cpu/gpu and disk
    - User tickets
    - Audits from internal security teams and needs for reporting to management

## How we build things / fit for use and fit for warranty

- Fit for use: Does the system do what it's supposed to do? Speaks to the
  cabailities of the system to meet requirements. 
    - Functional testing determines this

- Fit for warranty: Does the system do what it's supposed to do as often as it's
  supposed to do? Speaks to stability.  
    - Non-functional testing determines this.  



## Look Up
- Open Waldo - open source community
    - <https://openwaldo.org/>



