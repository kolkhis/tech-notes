# Notes from Gremlin 

These are my notes from the Gremlin Enterprise Chaos Engineering Certification
(GECEC) course.  

They're not meant to be comprehensive. They're for my personal use.  

---

## Intro to Chaos Engineering

Chaos Engieering is the practice of running thoughtful, planned experiments to
identify hidden reliability risks in systems.  

It helps us improve our systems by giving us a deeper understanding of how the systems
work.  


Chaos engineering involves injecting faults into a system (e.g., high CPU, network
latency, dependency loss), observing how oursystems behave, then using that knowledge
to make our systems resilient to those faults.  

We identify these issues early and make our systems more fault-tolerant.  

The concept came from Netflix (chaos monkey).

### Why is it necessary?

Software apps in the past were large monoliths that were updated slowly and deployed
on servers managed by hand. That's not the case anymore.  

Today, distributed systems are full of hidden risks.  

We prefer services over monoloiths now. Services are deployed to cloud platforms and
hosted on temporary infrastructure (e.g., EC2 instances).  

The shift from waterfall development to agile-based development and the DevOps
methodology means the systems and services are changing faster than before.  


---

Like how QA testing finds bugs in code, CE finds reliability problems that would
normally go unnoticed before they turn into incidents or outages.  

These un detected risks are like a relibility minefield.  

Chaos Engineering helps:

- Discover reliability risks before an incident occurs
- Reecreate past incidents to verify resiliency mechanisms
- Validate runbooks and training teams to respond to incidents in a controlled
  environment
- Reduce risks in large-scale initiatives (e.g., cloud migrations)
- Reduce downtime

It's a preventative practice.  


### Misconceptions

- Chaos Engineering is not about creating chaos.
    - It only creates chaos in controlled environments.
    - In the end, it reduces chaos.  
- It's not unsafe
    - Safety techniques are built in to the Chaos Engineering practice
    - E.g., target the smallest number of components needed
    - You should use a tool that lets you stop and roll back experiments immediately if 
      something goes wrong.  
- You can do it without affecting customers
    - CE experiments should eventually be run in prod, but it's not required.  
    - experiments can be done in pre-prod environments (dev, testing)
    - In prod, we can use existing techniques (canary deployments, A-B testing, dark
      launches) to reduce risk  
- It's easy to stop an experiment after you've started it
    - Mature CE tools have controls in place to stop experiments from becoming
      uncontrollable
    - E.g., setting short default time for experiments, or (hosted solutions) failing 
      safe if the control plane loses connection to the test system

## How Chaos Engineering Works

Teams perform CE by methodically injecting fault into their systems.  

Fault injection is for causing intentional failure in a component (e.g., host,
container, service).  

Causing failure on a system comes with risk, which is why we use Chaos Engineering
experiments (chaos experiments) to structure fault injection.  


### Chaos Experiment Steps

1. Step 1: Create a hypothesis
    - How do you expect your system to respond to a certain type of fault?

2. Step 2: Define the experiment
    - What type of fault are you injecting? Which systems do you want to test?

3. Step 3: Observe your system to understand baseline behavior.  
    - Use monitoring tools to measure key metrics related to the test.  
    - If you're checking how your system responds to CPU spike, monitor the baseline
      CPU usage.  

4. Step 4: Perform the experiment
    - Inject faults to test the hypothesis (from step 1) and monitor the effects

5. Step 5: Analyze the results
    - Use observations gathered during the experiment to determine whether the
      systems passed.  
    - If they didn't, figure out what fixes you might need to apply.  
    - Then repeat the experiment to test that the fix works.  

### Example Experiment

We have a basic web app. It's a task tracker that stores data in MariaDB.  

The app could fail in many ways.  

- App loses connection to database
- Latency between app and database
- Connection between app and user is unstable

We create a chaos experiment out of one of these.  

1. Hypothesis: If the app loses connection to the database, it will display a
   user-friendly error msg and prevent them from performing actions.  
2. Experiment: Block network traffic from the app to the dtabase and refresh the web
   page.  
3. Basline metrics: Monitor successful database calls over a 5-min period.  
4. Perform Experiment: Use a CE solution to drop database network traffic, then
   refresh the page to see what happens.  
5. Results: The rate of failed DB calls spikes to 100%. Page loads, no items shown.
   No error message shown either, but the unhandled exceptions are logged.  
    - Fix: We try adding a `try-catch` block that detects exception and shows an
      error msg to the user.  


### Setting Abort Conditions

Sometimes a chaos experiment doesn't go as planned and we need to cut it off.  

So, we set abort conditions.  

These are system conditions that indicate when we should stop a chaos experiment to
avoid negatively impacting other systems or users.  

These are something you decide before starting the chaos experiment. You should build
them into the experiment plans.

While you perform an experiment, compare system state to abort conditions. If the
conditions are met, stop the experiment.  


Some examples of abort conditions:

- System crashes or restarts
- We lose network connection to the test system
- We exceed our SLIs, SLAs, or SLOs.  



## Types of Chaos Experiments

Different CE tools provide different types of faults you can inject.  
Gremlin provides 12 of them, and organizes them into 3 types.  

1. State: Changes an aspect of a system's state (e.g., system clock or whether the system is running)
    - Shutdown: Shuts down (optionally reboots) the OS.
    - Time travel: Changes the host's system time.  
    - Process killer: Kills specified processes on the host.  

2. Resource: Consume available resources (CPU, RAM, Storage)
    - CPU: Generates high load for one or more CPU cores.  
    - Memory: Allocate a specific amount of RAM
    - I/O: Put read/write pressure on I/O devices (e.g., SSDs, HDDs)
    - Disk: Fills storage to a certain % by writing temp files.  

3. Network: Change the system's network behavior (e.g., introducing latency, blocking connections to deps)
    - Blackhole: Drop all matching network traffic.
    - Latency: Inject latency into matching outbout traffic.
    - Packet loss: Induce packet loss into all matching outbound traffic
    - DNS: Block access to DNS servers.
    - Certificate Expiration: Checks for expiring TLS certs

### Experiment Customization

Each experiment is customizable in Gremlin.  

You can specify duration (how long), magnitude (how significant), and blast radius (how many machines).  
You can also specify experiment-specific options.  

### Scenarios

One-off chaos experiments are useful for small tests.  
Running advanced, complex, realistic experiments requires a way to run multiple
experiments sequentially.  
Sequential experiements is called a Scenario.  

With scenarios, you:

- Test your systems against common failure modes
- Simulate complex failure modes (e.g., cascading outages)
- Reproduce past incidents that you've had to respond to


Gremlin Scenarios support Health Checks. They're automated checks that check an
endpoint and half the scenario if the endpoint indicates that the system is
unhealthy.  

Health Checks are the mechanism that lets you automate abort conditions.  


### GameDays

These CE concepts so far can be done individually.  

But, CE is best done as a team.  
Getting a team together and running experiements as a team is called a GameDay.  

GameDays are important because:

- They test your systems against failure modes that could cause outages
- Greate teambuilding exercises
- Encourage team members to share ideas and learnings about system operation


Usually organized/led by a team lead, but everyone participates.  



### Automating Experiments

Experiments and scenarios have one thing in common: They require someone to set them up each time they're run.  
This is not useful if:

- You're not sure what the risks are in your systems
- You're not sure which systems to test first
- You want to automate and scale experiments across many systems

This is where Reliability TEsts help. This is a test that validates system
reliability by injecting fault and uses health checks to determine a clear pass or fail.  

Reliability tests use fault injection as the underlying mechanism.  
These are generated automatically each time you define a Service in Gremlin.  

This:

- Standardizes reliability testing across services
- Makes onboarding easier
- Scales up the number of systems being tested (doesn't requaire you to create new experiments/scenarios)

There's no significant difference between Reliability Tests and Chaos Experiments.  


## Scaling your Chaos Engineering Practice

The key to early CE adoption is to start small. Introduce CE to a single team to
start.  

Run a low magnitude chaos experiment in a production environment following the
GameDay structure.  
Use this opportunity to find and fix problems in these systems. Develop runbooks that
eng teams can use to respond to outages.  

Once you understand how your systems respond to failure, and your team has a plan in
place for responding to failures, start running GameDays.  

### Moving Chaos Engineering into Prod

Most teams start in pre-prod (dev, staging).  
This is fine for learning how to run experiments/onboard with new tools.  
But, for real-world usage, it has limits.  

Prod is a unique environment with its own behaviors, faults, and risks.  

No matter how automated your infrastructure is, pre-prod will never be the same as
prod.  


But, how do we safely run experiments in prod?  

1. Reduce the scope and magnitude.  
    - Number of systems and how strong the experiment is
2. Define abort conditions and set up health checks to automate stopping experiments
    - Set thresholds for health checks lower than alert thresholds
3. Rather than running experiments directly in prod, use an alternate deployment 
   method (e.g., blue/green deployments, canary deployments, dark launches) to limit risk.  
    - These separate prod environments into two versions. Live and Dark.  
    - Live is your "real" prod env. Dark serves little or no real traffic.  
    - Test in your dark env until you're confident. Then go to your real prod env.  


### Getting Other Teams to Buy-In

The hardest thing is to get others excited about CE.  
Have a champion (Chaos Engineering champion).  

This is someone who promotes and/or manages the CE practice in the team or org.  

They take responsibility for scaling up the practice and getting other teams bought
in, and demonstrating progress to the org.  

Get another team excited by showing them a success story.  


### Measuring Progress / Showing Results

If you can't show the business side of the org that CE is positive, the practice
won't take root.  

Reliability doesn't seem as important as building new products and features.  

Four metrics are usually used to measure reliability.  

1. Uptime: The amount of time the system is up for use. Measured as a % over a given time (e.g., Five 9s).   
1. Service level agreements (SLAs): Contracts between org and customers. Promises
   minimum level of availability or uptime.
1. Mean time between failure (MTBF): Average time between system failures. Low MTBF
   means systems fail often. Goal is to increase this number.  
1. Mean time to resolve (MTTR): Average time to detect and fix problems. We want this
   low.  

These metrics are valuable for engineers. We still need to link them to the
businesses KPIs (key performance indicators).  

Correlate these technical metrics to things like:

- Lost revenue: Potential income and business lost due to downtime
- Added costs: Additional money the business spent on responding to/resolving outages
- Customer Attriction: Host many customers abandoned the product/service because of
  downtime

Fidning && fixing failure modes increases availability and reduces failure rates.
This reduces risk of missing revenue targets. Lowers costs and losses due to
downtime. Improves customer satisfaction. 


