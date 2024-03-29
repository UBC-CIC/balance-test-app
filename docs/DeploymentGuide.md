# Balance Test Mobile App Deployment Guide

<b>Note: This is the deployment guide for the Mobile App of the Balance Test Project. Please ensure you have deployed the [AWS backend and web dashboard](https://github.com/UBC-CIC/balance-test-dashboard/blob/main/docs/DeploymentGuide.md) before proceeding with this guide.</b>

| Index                                                      | Description                                               |
|:-----------------------------------------------------------|:----------------------------------------------------------| 
| [Dependencies](#Dependencies)                              | Required services and tools for deployment                                 |
| [Clone the Repository](#clone-the-repository)              | How to clone this repository                              |
| [Import Amplify Project](#import-amplify-project)| Import the existing Amplify project           |
| [Deploy to TestFlight](#deploy-to-testflight)              | Deploy your app to TestFlight for testers to use          |


## Dependencies
The full list of steps to create and deploy a new Flutter application from scratch can be found [here](https://docs.flutter.dev/get-started/install/macos).

 Below are the required tools and services to deploy the existing project from the GitHub repository:
 - [Apple Developer Account enrolled in the Apple Developer Program](https://developer.apple.com/programs/enroll/)
- [GitHub Account](https://github.com/)
- [Git](https://git-scm.com/) v2.14.1 or later
- [Node.js](https://nodejs.org/en/download) v14.x or later
- [npm](https://www.npmjs.com/) v6.14.4 or later
- [AWS Account](https://aws.amazon.com/account/)
- [Flutter](https://docs.flutter.dev/get-started/install/macos#get-sdk) version 3.3 or higher
- [Amplify CLI](https://docs.amplify.aws/cli/start/install/)
- [Android Studio, version 2020.3.1 (Arctic Fox) or later](https://docs.flutter.dev/get-started/install/macos#install-android-studio)
- [Xcode](https://docs.flutter.dev/get-started/install/macos#install-xcode)
- [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#installation) - Additionally, if you are installing on an Apple Silicon Mac, follow step 2 of [this section](https://docs.flutter.dev/get-started/install/macos#deploy-to-ios-devices)



Please configure your AWS Account user with administrator access in the Amplify CLI by following the instructions found [here](https://docs.amplify.aws/cli/start/install/#configure-the-amplify-cli).




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

## Import Amplify Project

1. In terminal, from your project's root directory, run the following command to import the existing Amplify project in your AWS account
```
amplify pull
```
2. Select the Amplify project that you created when deploying the web dashboard and backend. Confirm that the ID matches the Amplify project ID found in the AWS console.
![Xcode Navigator](/assets/amplify_console_page.png)
3. Choose **Android Studio** as your default editor and **flutter** as the type of app. 
4. Set the storage location for the configuration file as `./lib/`
5. Select **Yes** for "Do you plan on modifying this backend?"


## Deploy to TestFlight

To deploy your app to TestFlight, you must first register your app on App Store Connect.

The official guide to register your app can be found [here](https://docs.flutter.dev/deployment/ios#register-your-app-on-app-store-connect).


### Register a Bundle ID
1. To get started, sign in to [App Store Connect](https://appstoreconnect.apple.com/) with your Apple Developer account and open the [Identifiers Page](https://developer.apple.com/account/resources/identifiers/list).
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
5. Head to the **Signing & Capabilities** tab and sign in with your Apple Developer account if have not done so already
![Xcode settings](/assets/xcode_settings.png)
5. Please **ENTER and VERIFY** the **Bundle Identifier** matches with the Bundle Id created in App Store Connect
6. In the **Signing & Capabilities** tab, ensure **Automatically manage signing** is checked and Team is set to the account/team associated with your Apple Developer account. Under Bundle Identifier, check that the Bundle Id matches with the Bundle Id created in App Store Connect

### Create a Build
1. In Xcode, in the General tab under Identity, check that the Version number is set to 1.0.0 and the Build number is set to 1 **for your first deployment**. For future deployments, increment the Version number and reset the Build number for major updates (e.g. 1.0.1+1). For minor updates, incrementing just the Build number is sufficient (e.g. 1.0.0+2). 
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
6. Once the archive has completed, a window should appear showing all of your archives. Select the most recent archive and click `Distribute App`
![Xcode Archives](/assets/xcode_archives.png)
7. Select `App Store Connect > Upload > Strip Swift Symbols + Upload your app's symbols + Manage Version and Build Number > Automatically manage signing > Upload`

### Deploy to TestFlight

1. Once the Xcode upload is complete, navigate to your app page in App Store Connect. Under `Builds > iOS`, there should be a list of builds uploaded from Xcode. Builds may take a few minutes to appear here. 
2. Once the uploaded build appears, click on it, fill in the Test Details, and **add Testers by their Apple ID**
3. Once a tester is added, the app should be automatically submitted for review. The reviewing process could take a few days to process.
4. Once the build is processed, testers will recieve a code in their email for TestFlight.
5. Testers can then install TestFlight from the Apple App Store on an iPhone running iOS 13.0 or later and sign in with their Apple ID. 
6. In TestFlight, testers can press the `Redeem` button and enter the TestFlight code from their email. The app should then appear in TestFlight under Apps and testsers will be able to install the build.
7. Builds uploaded to TestFlight have a lifespan of 90 days and will expire after that. To create another build of the app to upload to TestFlight after the 90 day period, please follow the steps above to [create another build](#create-a-build) and [upload to TestFlight](#deploy-to-testflight-1).
