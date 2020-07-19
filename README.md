# HealthCheckUp

In order to get different data types like Heart rate, weight, height, step count etc, we are Using Google fit SDK.

- Overview of Google Fit 
    https://developers.google.com/fit

-Plugin used for demo purpose 
    https://pub.dev/packages/fit_kit

App Does ->

The kit on the native platform interacts with Google Fit for both & HealthKit for IOS. It provides Different type of data in the form of a list of object of type (Fitdata). Each Fitdata object is a data point which contains following object :-
1. From Time - the time started to record values
2. To Time - till the time it was recorded.
3. Value - actually units recorded.
4. Source - where it got recorded.
5. userEntered - whether user-entered or not


Below is the data recorded with units & how it is recorded.
Following data types and source: -

1. Heart_Rate: - for heart detection I used an app called Heart Rate monitor and enable google fit data sharing in that app.
2. Step Count - for step count mobile device does not need anything. It will count the steps using sensors already available.
3. Heigh & Weight - these are added in google fit app for once - so it is user-defined only, but devices can be used to integrate the data.
4. Distance - how much distance is covered in a session during footsteps
5. Energy - how much energy consumed based on steps and distance covered by the use
6. Water - for that I have used water remind app which reminds to have intake and that get sync to fitness store.
7. Sleep - there are apps that analyze the sleep time of user and sync data with google fit. We can get the same data to use.

Conclusion:- we can easily access most of the data, some data would be required by other app linked or any other device which will be linked to google fit
