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
git clone git@github.com:UBC-CIC/balance-test-app.git
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
Give the project a name and initialize the project with these settings:
<pre>
Enter a name for the environment <b>dev</b>
Choose your default editor: <b>Android Studio</b>
Choose the type of app that you're building <b>flutter</b>
Where do you want to store your configuration file? <b>./lib/</b>
</pre>
## Import Existing Amazon Cognito Resources into your Amplify Project

### Import Cognito Resources
To import existing Amazon Cognito resources into your Amplify project, execute this command from the root directory of the project:
```
amplify import auth
```
Select **Cognito User Pool and Identity Pool**

Select the correct User Pool ID 

Once the User Pool and Identity Pool is successfully imported, run **amplify push** to complete the import process and deploy the changes.
```
amplify push
```

### Import Storage
Import the existing Amazon S3 bucket by executing this command from the root directory of the project:
```
amplify import storage
```
Select **S3 bucket - Content (Images, audio, video, etc.)** and the **balancetest-datastorage-bucket**.

Once the S3 bucket is successfully imported, run **amplify push** to complete the import process and deploy the changes.
```
amplify push
```

### Import AppSync API
In your AWS Management Console, navigate to the AWS AppSync page and select your API:

![AppSync Home](/assets/AppSyncConsoleHome.png)

Navigate to the settings page and locate the API ID:

![AppSync Settings](/assets/AppSyncAPISettings.png)

In terminal, run the following command with your API ID:
```
amplify add codegen –apiId [API ID]
```
Once the API is successfully added to the project, run **amplify push** to save the changes.

## Deploy to TestFlight

To deploy your app to TestFlight, you must first register your app on App Store Connect.

The official guide to register your app can be found [here](https://docs.flutter.dev/deployment/ios#register-your-app-on-app-store-connect).


### Register a Bundle ID
1. To get started, log in to [App Store Connect](https://appstoreconnect.apple.com/) with your Apple Developer account and open the [Identifiers Page](https://developer.apple.com/account/resources/identifiers/list).
2. Click **+** to create a new Bundle ID.
3. Select **App ID > App**
4. Enter a description (name for the Bundle ID) and an **Explicit** unique Bundle Id (e.g. **com.[organization name].balanceTestApp**)
5. Leave the **Capabilites** and **App Services** as default and click **Continue>Register**

### Create an application record on App Store Connect
1. Now, in the [My Apps](https://appstoreconnect.apple.com/apps) page of App Store Connect, click **+** in the top left corner and select **New App**
2. Select **iOS** under **Platforms**
3. Enter a name for the app (e.g. **Balance Test App**)
4. Select the **Bundle ID** you have just created
5. Enter a unique ID for your app under **SKU** (e.g. **com.[organization name].balanceTestApp**)
6. Select **Full Access** for **User Access** and click **Create**

### Beta Test Information
To start testing with TestFlight, fill out the **Beta App Information**  in the `General Information > Test Information` page of your app in App Store Connect.


### Update Xcode project settings
For an official guide, please view the **Update Xcode project settings** section of the page found [here](https://docs.flutter.dev/deployment/ios#review-xcode-project-settings).

1. Navigate to your project settings by running the following command from the root directory of your project
```
open ios/Runner.xcworkspace
```
2. Select the **Runner** with the App Store Connect icon in the Xcode navigator
![Xcode Navigator](/assets/xcode_navigator.png)
3. In the **General** tab, choose a display name for the app
4. Under **Minimum Deployments**, ensure it is set to iOS 11.0
5. Please **ENTER and VERIFY** the **Bundle Identifier** matches with the Bundle Id created in App Store Connect
![Xcode settings](/assets/xcode_settings.png)
6. In the **Signing & Capabilities** tab, ensure **Automatically manage signing** is checked and Team is set to the account/team associated with your Apple Developer account. Under Bundle Identifier, check that the Bundle Id matches with the Bundle Id created in App Store Connect

### Create a Build
1. In Xcode, under the General tab, check that the Version number is set to 1.0.0 and the Build number is set to 1 **for your first deployment**. For future deployments, increment the Version number and reset the Build number for major updates (e.g. 1.0.1+1). For minor updates, incrementing just the Build number is sufficient (e.g. 1.0.0+2). 
2. In Android Studio, open the **pubspec.yaml** file located in the root directory of your project. Set the version and build number located near the top of the file to match with the version and build number of the current deployment and save the file:
```yaml
version: 1.0.0+1
```
3. In Xcode, set the Target to be: `Runner > Any iOS Device`
![Xcode Target](/assets/xcode_deployment_target.png)
4. From the root directory of your project in **Terminal**, run:
```
flutter build ios
```
5. Once the Xcode build is complete, select `Product>Archive` in the Xcode menu bar. Wait for the archive to complete.
6. Once the archive has completed, a window should appear showing all your archives. Select the most recent archive and click `Distribute App`
![Xcode Archives](/assets/xcode_archives.png)
7. Select `App Store Connect > Upload > Strip Swift Symbols + Upload your app's symbols + Manage Version and Build Number > Automatically manage signing > Upload`

### Deploy to TestFlight

1. Once the Xcode upload is complete, navigate to your app page on App Store Connect. Under `Builds > iOS`, there should be a list of builds uploaded from Xcode. Builds may take a few minutes to appear here. 
2. Once the uploaded build appears, click on it, fill in the Test Details, and **add Testers by their Apple ID**
3. Once a tester is added, the app should be automatically submitted for review. The reviewing process could take a few days to process.
4. Once the build is processed, testers will recieve a code in their email for TestFlight.
5. Testers can then install TestFlight from the Apple App Store, sign in with their Apple ID, enter the TestFlight code from their email, and install the build.
