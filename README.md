# FlowPomodoro

<img src='https://imgur.com/eatpwoS.png' title='AndroidAR' width='200' height='400' alt='Pomodoro1' />.  <img src='https://i.imgur.com/h1Vxd3M.png' title='AndroidAR' width='200' height='400' alt='Pomodoro1' />.  <img src='https://i.imgur.com/HGFXRrP.png' title='AndroidAR' width='200' height='400' alt='Pomodoro1' />

This app is created to help people with their time management, keep focus and finish their pending tasks using the [pomodoro](https://francescocirillo.com/pages/pomodoro-technique) technique. The main idea of this technique is focus during a period of time (recommended 25 minutes) and take a short break (recommended 5 minutes). 

This iphone app provides a configurable timer which follows the pomodoro technique. First the user adds a name to the task, then press start, and the timer will start,  after the focus timer finishes the timer will automatically change to break mode and the user should press start to keep track of his break time. The app also provides a screen to see the user history activity. 

## Features provides on this app:

- Timer dedicated to focus and break mode (following pomodoro technique core process)
- Configurable timer if the users decided to adjust the timer to their own needs. 
- Add a name to every task 
- SignIn process keep track of every task finished on the history screen
- Login with Facebook and Google
- Guest mode if the users just want to use the timer

## Tecnical Overview

- Swift Timers
- Custom animations using UIViews and Timers
- Offline mode using Firestore from Firebase so the user can use the app without a network connection 
- Persist information using NSUserDefaults for the timer values
- Responsive interface using vectors 
- Custom fonts and Views 
- Login using Social providers: Facebook and Google

## Note:

Apple limits the use of timers when the app is in background, so please keep your screen activated while using the app.

## License

you can check license details [here](https://github.com/byronap120/FlowPomodoro/blob/master/LICENSE) 
