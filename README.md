# COMMUNION WEBAPP

[Visit Communion](http://www.communionstudio.com)

## Application Overview

Our web application is a responsive and user-friendly static website hosted on AWS S3. It allows visitors to effortlessly input their phone numbers, which are then securely processed and stored using AWS services such as API Gateway, Lambda functions, and DynamoDB. Thanks to our automated deployment pipeline, powered by GitHub Actions, updates and scalability are seamless. Explore our app to experience its efficient data collection and management capabilities firsthand.

## High-Level Design Overview

1. **Code Repository**: This repository contains the source code of our web application.

2. **Deployment Automation**: GitHub Actions automate the deployment process. When code changes are pushed, these actions:
   - Build the application.
   - Deploy it to AWS.

3. **Static Website**: Our website is hosted as a static website on an AWS S3 bucket.

4. **User Interaction**: Visitors can access our website, enter their phone numbers, and submit the data.

5. **AWS Infrastructure**:
   - **API Gateway**: User input is sent to an API Gateway, which acts as an entry point for processing.
   - **Lambda Functions**: API Gateway invokes Lambda functions to process and store user input.
   - **DynamoDB**: User phone numbers are securely stored in DynamoDB, our NoSQL database.

![High-Level System Design](https://s3.amazonaws.com/www.communionstudio.com/communionstudioHLD.jpeg)


# Roadmap

## Frontend

- **Transition to HTTPS**
  - **Requirement:** Integrate with AWS CloudFront and obtain an SSL/TLS certificate from ACM.
  - **Status:** ACM certificate requested.

## IAC (Infrastructure as Code)

- **Resolve Race Condition in Base Infrastructure Deployment**
  - **Requirement:** Debug session.
  - **Status:** Ongoing race condition on Bucket Policy.

- **Implement GitHub Actions for IAC**
  - **Requirement:** Configure Actions.
  - **Status:** Pending resolution of race condition.
