# Telemetry Pipelines


Telemetry pipelines are distinct from the standard observability tooling you'll
see on most systems.  

These pipelines are used to take large amounts of data being generated and
convert it into actionable, informative data.  

For instance, in your observability platform (e.g., Grafana), you don't need to
see *all* the `200 OK` response codes from an Apache Webserver log file.  

A telemetry pipeline would take that data, pull out the useful bits, and
deliver it to a destination.  

The idea is to provide **useful** information while also cutting down on data
storage costs.  

## Broad Overview (Data Lifecycle)

1. Raw data from a single source can be verbose with minimal value. It would
   require a lot of manual parsing in order to get something useful out of it.  

2. Sending raw data from multiple sources into a telementry pipeline
   centralizes the data and allows us to process it in an automated fashion.  

3. As the data enters the pipeline and it's analyzed, it becomes possible to
   optimize it by identifying common patterns and identifying useful vs. redundant data.

4. As it passes through the pipeline, the data is transformed and optimized by
   "processor chains" that are built to extract the most meaningful info for
   the teams that will be looking at it.  

5. At the end of the pipeline, raw data becomes useful, actionable information.
   This can allow teams to rapidly respond to incidents.  

## Components

At a very basic structural level, there are three main components to a
telemetry pipeline.  

1. Data sources
2. Processors
3. Downstream desinations

What the processing chains look like is determined by the input data (the
format and info requirements of the tool) and storage destinations.  



