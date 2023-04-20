# Balance Test Mobile App Deployment



| Index                                                      | Description                                               |
|:-----------------------------------------------------------|:----------------------------------------------------------| 
| [Dependencies](#Dependencies)                              | Prerequisite dependencies                                 |
| [Clone the Repository](#clone-the-repository)              | How to clone this repository                              |
| [Deployment](#Deployment)                                  | Deploy the app to TestFlight                   |

## Dependencies
Before you start deploying, you must have the following dependencies:
- [NodeJS](https://nodejs.org/en/download/)
- [Git](https://git-scm.com/downloads)
- [AWS Account](https://aws.amazon.com/account/) 
- [GitHub Account](https://github.com/) 
- Install the [Amplify CLI](https://docs.amplify.aws/cli) tool.

If you do not currently have a configured AWS Account, configure an account with the following instructions:

- Configure the AWS CLI tool for your AWS Account in the `ca-central-1` region, using a user with programmatic access and the "AdministratorAccess" policy (moving forward, we will assume you have [configured a profile](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/configure/index.html) called `health-platform`):
  > `aws configure --profile health-platform`

If you already have a configured AWS account, you may use your own configured account to deploy. Please note that if you decide to use your own account to deploy, be sure to change our command line commands to use your profile whenever there is a ```--profile``` command.
```
--profile YOUR_AWS_PROFILE_HERE
```

## Clone The Repository

First, clone the github repository onto your machine. To do this:
1. Create an empty folder to contain the code.
2. Open terminal and **cd** into the newly created folder.
3. Clone the github repository by running the following command:
```
git clone https://github.com/UBC-CIC/balance-test-app.git
```

The code should now be copied into the new folder.


In terminal, **cd** into root directory of the project folder by running the following command from the newly created folder's directory:
```
cd balance-test-app/
```

## Initialize a new Amplify project
To initialize a new Amplify project, run the following command from the root directory of the project:
```
amplify init
```

## Import Existing Amazon Cognito Resources into your Amplify Project

### Import Cognito Resources
To import existing Amazon Cognito resources into your Amplify project, execute this command from the root directory of the project:
```
amplify import auth
```
Select the
### Import Storage
To import an existing Amazon S3 bucket execute this command from the root directory of the project:
```
amplify import storage
```
### Import AppSync API
In your AWS Management Console, navigate to the AWS AppSync page and select your API.
![AppSync Home](/assets/images/AppSyncConsoleHome.png)

Navigate to the settings page and locate the API ID
![AppSync Settings](/assets/images/AppSyncAPISettings.png)

In terminal, run the following command with your API ID:
```
amplify add codegen –apiId [API ID]
```



## Deploy to TestFlight

