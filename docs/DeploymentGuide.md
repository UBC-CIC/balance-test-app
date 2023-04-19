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
3. Clone the github repository by entering the following:
```
git clone https://github.com/UBC-CIC/balance-test-app.git
```

The code should now be copied into the new folder. Now **cd** into the project folder by running the following command:
```
cd balance-test-app
```


## Deployment
### Backend
The `backend` folder contains AWS CDK stacks and AWS Lambda function code that will manage the data stores and corresponding interactions with the webapp.

Run `cd backend` and follow the instructions in [backend/README.md](./backend/README.md).

### Frontend
The `frontend` folder contains the Health Platform dashboard as a React app.

Run `cd frontend` and follow the instructions in [frontend/README.md](./frontend/README.md).
