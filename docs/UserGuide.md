# Balance Test Mobile App User Guide

## Patient App

### Home Page

|   |   |
|---|---|
|<img src="../assets/new_test_page.PNG" width="75%">| In the Home page, patients will be able to see the movement tests assigned to them. The estimated movement duration is noted in the bottom left corner. |
|<img src="../assets/instructions_page.PNG" width="75%">| To start the test, click on the `Start` button of a movement test. This will open a new page containing the instructions to the movement. |
|<img src="../assets/recording_page.PNG" width="75%">| To head to the recording page, click on the Begin button. This will take you to a page with a timer and a `Start` button. |
|<img src="../assets/recording_countdown.PNG" width="75%">| When the `Start` button is pressed, a countdown page will appear to allow you to prepare for the movement. The countdown can be dismissed early by tapping anywhere on the screen. |
|<img src="../assets/recording_in_progress.PNG" width="75%">| Once the countdown is finished, the app will start recording. To stop the recording, tap anywhere on the screen. |
|<img src="../assets/test_summary_page.PNG" width="75%">| After the test recording, the app will navigate to a summary page for review. Additional notes can be entered and saved if needed. To upload and save the recording to the backend, click on the button with the arrow icon. |


>

### Past Tests Page

|   |   |
|---|---|
|<img src="../assets/past_tests_page.PNG" width="64%">| The Past Tests page displays a list of previously recorded movement tests. Each test block displays the score, the movement type, and the date it was completed. |
|<img src="../assets/test_details_page.PNG" width="64%">| Clicking on a test will open the Test Details page. The test details are displayed here, including date and time, test duration, score, and notes. | 
|<img src="../assets/test_graphs.PNG" width="64%">| IMU sensor graphs can be found below the test details. These graphs display the raw data recorded from each IMU sensor and axes.|


### Analytics Page

|   |   |
|---|---|
|<img src="../assets/analytics_page.PNG" width="100%">| The Analytics page displays the patient’s weekly and monthly balance score averages. Beside the averages shows how the current average compares to the previous week or month. Click on the Sit to Stand analytics button to view more movement specific analytics. |
|<img src="../assets/sit_to_stand_graphs.png" width="100%">| In the Sit to Stand analytics page, the score graph at the top of the page displays the scores of all the tests the patient has completed. Below the score graphs are IMU sensor range graphs. These graphs display the lowest and highest sensor reading of each IMU sensor on each day a Sit to Stand test was recorded. |


### Account Page 

|   |   |
|---|---|
|<img src="../assets/account_page.PNG" width="55%">| This page allows you to view your account information, including name, email, user ID, and recording countdown time. |
|<img src="../assets/countdown_selection.PNG" width="55%">| Clicking on the Countdown button will open a page allowing you to change the countdown duration. |

## Clinic App

### Patient List Page

|   |   |
|---|---|
|<img src="../assets/patient_list_page.PNG" width="77%">| In the Patient List page of the clinic app, administrators will be able to view the names and user IDs of all patients assigned to them. New patients are able to be assigned in the web dashboard.|

### Patient Page
Clicking on a patient takes you to the Patient Page.

<p float="left">
  <img src="../assets/clinic_past_tests_page.png" width="100"/>
  <img src="../assets/clinic_new_test_page.png" width="100"/>
  <img src="../assets/clinic_analytics_page.png" width="100"/>
</p>

From the Patient Page, the Past Tests page, New Test Page, and Analytics page from the Patient App can be viewed for each patient.

### Assigning Scores and Training a Patient Model

|   |   |
|---|---|
|<img src="../assets/clinic_summary_page.png" width="100%">| In the Test Summary page of recordings done on Clinic accounts, there is an option to assign a score between 0-100 for the tests. For every 10 tests sent with an assigned score, a traning job will be started to train the patient's machine learning model on all tests that have been sent with an assigned score.|
