
# AWS Lambda

## What is Lambda?

Lambda is a serverless execution environment.  
* Lambda allows you to execute code remotely without having to manage a server.  
* You can deploy your own containers with Lambda.  


### What is a serverless execution environment?
There is still a server running the code somewhere.  
A serverless environment just provides you an execution environment without having to manage the
server yourself.  

### Language Support
By default lambda environments only support Java, Ruby and Python.  
However, you can add "layers" to get support for other things.  

### Other serverless products:
* S3
* DynamoDB

---

- Other things AWS has:
EventBridge (CloudWatch Events) - Enables the use of cronjobs, automated script execution. 
Step Functions. These have a technical timeout of 1 year.



## Random AWS Questions and Answers

Q. Which product is not a good fit if you want to run a job for ten hours?
a. AWS Batch
b. EC2
c. Elastic Beanstalk
d. Lambda

A:
d. Lambda. No lambda function cannot be run for more than 15 minutes.



Q. What product should you use if you want to process a lot of streaming data?
a. Kinesis Firehose - Has no memory other than its buffer
b. Kinesis Data Stream
c. Kinesis Data Analytics
d. API Gateway


A:
b. Kinesis Data Stream
Kinesis Analyntics is used for transforming data 
API Gateway is used for managing apis
Firehose is used mainly for large amounts of nonstreaming data

