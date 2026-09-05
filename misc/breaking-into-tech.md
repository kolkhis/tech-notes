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

### How we build things / fit for use and fit for warranty

- Fit for use: Does the system do what it's supposed to do? Speaks to the
  cabailities of the system to meet requirements. 
    - Functional testing determines this

- Fit for warranty: Does the system do what it's supposed to do as often as it's
  supposed to do? Speaks to stability.  
    - Non-functional testing determines this.  

### Where the Operations Work Comes From

- Monitoring systems
- User trouble tickets
- Manager drive-bys

### Types of Meetings

Your role as an individual contributor (IC) will be hindered by people
constantly inviting and dragging you into meetings.  
By knowing what to expect with meetings, you can better prepare for how to
handle them.  

- Team Standup: Discuss work and work queues for employees
    - what'd you do today?
    - what'd you do yesterday? 
    - what are your blockers?

- Engineering change board meetings
    - Discuss upcoming changes and give teams time to work through issues with
      upcoming changes.
    - Also called CAB (Change Advisory Board) meetings
    - Everyone should go to these meetings if possible to see what is going on
      in the org.  

- Operations Meetings (tend to be every morning, could be weekly)
    - Discuss the last 24 hours of operations. Discuss any upcoming work in the
      next 24 hours.  
    - What did we do to solve a problem? Could be a check-in.  
    - Talk about capacity of the system (pain points, etc.).  
    - Note change windows.  
    - Sometimes these will be discussions about incidents (like an after-action
      review).  

- Performance Reviews 
    - How the employee is doing against their peers and objectives.  
    - There will be an annual performance review as an individual.  
    - Lay out all the things you've accomplished, show that you're doing better
      against your objectives than your peers.  

- Tiger Teams
    - Discuss a specific, acute engineering problem that is blocking work
    - Tiger teams have very high visibility from higher ups. Many bonuses come from here.  
    - Root cause analysis 
    - "deploy standard Tiger Team rapid-fire root cause analysis"
    - Ishikawa/fishbone diagrams help here

### Types of Managers

Line manager (your reporting manager)

Project manager (They wanna know if deliverables have been met/timesles are on
track)

Agile/scrum managers
- These people will often care directly about what's going on in the next
  sprint. Sprints are week or shorter blocks of work activities that output an
  artifact or deliverable

Director
- Will want to knowbig picture information 
    - "How much has usage increased in the last 3 months on X system?"
    - "How long until that storage solution runs out of space at an increased
      15% month of month usage?"
    - Keep them happy with reports and dashboards. They likely prefer reports
      and not logon types of dashboards.  

## The way that you present yourself in data

### Engineers deal in precision and truth

- Trust but verify what you're told by others.  
    - You'll hear that the service is down, but 15 minutes into a call find out
      that there's a networking problem or a whole host down. Any number of
      questions would get you to this truth faster.  

- Say something on a call or write something in an email to state some truth,
  then back it up with your proof from the system output or logs. 
    - Don't ever have to backtrack on what you've stated. Your engineering
      currency is based on your knowledge and understanding of the systems you
      work in.  

---

Avoid talking about your "feelings."
Deal in accuracy. What you "feel" is a problem is irrelevant. It's what we call
an "anti-methodology" toward troubleshooting.  

- Data to based observations:

    - Learn how to interpret the data you're looking at.  
        - Understand the scope
        - Understand the scale
        - Understand mean/median/mode as well as distinct outliers

    - Avoid all anti-methodologies for troubleshooting:
        - The blind man: Changing things at random until problems disappear  
        - Spotlighting: Only use tools you're familiar with.  
        - Blaming someone else  

### General info on documentation

- Take notes from your terminal as you go
    - screen/tmux can log in real time
    - Pull cmds and relevant info into a text file
- Clean up and prep initial documentation
    - Learn markdown or other doc standard
- Run redline operations over your documentation
    - Redline operations are tester or other operator running through your
      documentation and literally redlining anything that doesn't work
      perfectly without your intervention
- Produce training and operational activities from your documentation
    - Must assume no knowledge of the system (even with root level operators)
        - Absolute pathing helps keep operators in correct directories

### Policy Hierarchy

- Guiding principles: Fundamental philosophy or beliefs of an org. Policy should
  represent implementing guiding principles

- Policies: Directives that codify organizational requirements

- Standards: Implementation specifications

- Baselines: Aggregate of minimum implementation sstandards and security controls
  for a specific category or grouping
    - e.g., STIG or CIS Benchmark

- Procedures: Line by line instructions.  

- Plans: Strategic and tactical guidance used to execute an initiative or respond
  to a situation, within a certain timeframe, usually defined with stages and
  with designated resources.  
    - Plans are bigger than procedures, but can point to procedures.  


### RACI Charts

These are charts ware a way to figure out who the key players are for tasks.

These are charts that deal with the involvement of key players in some process.
These help solve the problem in meetings where evyerone sees the problem but no
one wants to jump on the grenade.

- Responsible: The do-er
- Accountable: Owner
- Consulted: They are consulted on the task
- Informated: They know about the task but are not involved

From RACI charts, we can build a plan of action.

#### Plan of Action and Milestones (POAM)

When there's a deficiency found in a system, where it no longer meets the
functional requirements, a POAM is used to put together steps and a timeline to
resolve the issue.  

## Testing
All tests seek to record accurate info about the state of a system.  

This requires a good testing methodology.  
- Purpose: Why are we doing the test?
- Scope: How are we conducting the test? What is captured?
- Out of scope: What is NOT captured? What's acknowledged but not to be recorded? 

- Methodology: Description of how we will work to obejctively determione the
  quality of the outcomes. Are we using qualitative or quantitabtive results?

- Control: What will =be put in place to ensure that collection is done against a
  similar environment between different tests?

### Types of Testing
- unit testing
- integration testing
- functional testing
- acceptance testing
- performance testing
- load testing
- stress testing
- regression testing
- usability testing
- security testing
- A/B testing
- field testing

### Benchmarking and Baselining

Baselining: Follows along with observbability before to see how the system
works under normal operations.
    - "Low watermark"

Benchmarking: Testing the upper limits of the system capability.
    - "High watermark" or load testing on the system.  

---

Benchmarking methodology:

- plan phase
    - goals identification
    - Tools and metrics ID
    - planning and resource allocation
- experiment phase
    - experiment definition
    - experiment execution
    - experiment result analysis 
- improve phase
    - benchmark report
    - improvement planning
    - improvement monitoring


---

1. gather current info
2. make planned change to improve system
3. gather new info
4. verify - compare the "delta" or change for the  better or worse in the
   change that was made.  

## Security

Next to uptime, the most important concept is security. CIA triad. 
- Confidentiality
- Integrity
- Availablity

NIST Cybersecurity framework:
1. identify all your assets
2. protect those assets through layers/hardening
3. detect problems that are happening 
4. respond to the problems that are detected
5. recover the system back to a working state, then go back to identification
   (step 1)

#### Risk management
Potential of an undesirable or unfavorable outcome resulting from an
action/activity/inaction.  

Risk tolerance is how much of the undesirable outcome the risk taker is willing
to accept in exchange for the potential benefit.  

Risk management is the process of determining an acceptable level of risk (risk
appetite and tolerance), calculating the currect leve lof risk (risk assessment),
accepting the level of risk (risk acceptabnce), or taking steps to reduce risk
to the acceptable level (risk mitigation).  

Risk mitigation strats:
- Risk acceptance
- Mitigation
    - reduce with countermeasures
    - share risk with another entity
    - transfer risk to another entity (insurance)
    - modify or ceasing the risk causing activity (avoidance)
- risk reduction is accomplished by implementing one or more offensive or
  defensive controls to lower residual risk.  

- NIST Risk assessment methodology:
    - NIST SP-800-30 


#### Final Deliverables for this section

1. Work on documentation procedures
    - policies
    - procedures
    - capturing your work and turning it into meaningful processes that others
      can follow along
2. Study more about IT operations
    - understna how you go about dealing with risk and how orgs avoid risk
    - read related blog posts about IT operations
    - Read the free books on SRE (site reliability engineering)  


## Resume

- Up top:
    - Exp
    - Education
    - Tech/languages
- Lead with your strongest focus.  

## Interviewing

1. What questions should I expect?
2. What is an elevator pitch?
3. “Why are you the right person for this Linux Administrator job?”
4. How should I prepare for a Linux/DevOps interview?
5. How long should my answers be?


Ask "What are the 3 biggest(or current) pain points on the team?"  

### Two things they want to know in an interview

- Can you do the job?
- Will you do the job?

They're planning on handing over the reins of a working IT operations system.

You'll need to instill confidence that you're the right person to maintain and
keep this system operational.  

---

### Most common interview questions

- Question: Tell us a little about yourself
    - What they want to know:
        - They want a background summary
    - How you prep for it:
		- Practice a 2 min elevator pitch. Focus on roles and
          strengths, use % increase or numbers of improvements.

- Question: Why are you the right person for this role?
    - What they want to know:
        - Do you understand the role as they have described it?
    - How you prep for it:
		- Focus on what they're asking for. Do they want you to
          troubleshoot? Do they want you to monitor something? Talk about that.  

- Question: Any questions about the technology?
    - What they want to know:
        - Do you understand how to deploy and troubleshoot the technology?
    - How you prep for it:
		- Know the tech. Know how the industry uses it (blog
          posts, FAQ pages). Know about alternative technologies to compare with.  

- Question: How do you troubleshoot X topic?
    - What they want to know:
        - How well do you think on your feet? Do you have a standard method to
          troubleshoot? DO you understand this tool?
    - How you prep for it:
		- Know your troubleshooting methodology. Apply your
          methodology, talk about what you would be checking and who you'd be
          contacting. Check/verify and change directions.  

- Question: How do you handle X scenario?
    - What they want to know:
        - They want to know how you handle pressure
    - How you prep for it:
        - Think through when you've handled something well and when you've handled 
          something poorly.  
          Use the good example.  

## Look Up
- Open Waldo - open source community
    - <https://openwaldo.org/>

- Anti-methodologies for troubleshooting



