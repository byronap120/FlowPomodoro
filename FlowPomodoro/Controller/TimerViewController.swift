//
//  TimerViewController.swift
//  FlowPomodoro
//
//  Created by Byron Ajin on 7/25/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    @IBOutlet weak var clockBackground: UIImageView!
    @IBOutlet weak var clockDisplay: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var userNameView: UILabel!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    
    var user: User?
    private var lastDate: Date?
    private var timeElapsedInSeconds: Int = 0
    private var timerActive = false
    private var timerChangedOnSettings = false
    private let circularProgressView = CircularProgressView()
    private var timerMode: TimerMode?
    private var timer = Timer()
    private let focusModeHint = "Add Task Name"
    private let restModeTitle = "REST TIME"
    private let alertTitleCancel = "Are you sure you want to cancel your focus time?"
    private let alertTitleSkip = "Are you sure you want to skip your rest time?"
    private let alertConfirm = "Confirm"
    private let alertCancel = "Cancel"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intializeLifeCycleObservers()
        initializeUserInformation()
        intializeProgressView()
        updateTimerMode(mode: TimerContants.focusMode)
        edittingGesture()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSettings"{
            let settingsVC = segue.destination as! SettingsViewController
            settingsVC.callback = timeWasChangeOnSettings
        }
    }
    
    @IBAction func logOutUser(_ sender: Any) {
        FirebaseAPI.userSignOut()
        self.performSegue(withIdentifier: "logOutUser", sender: nil)
    }
    
    @IBAction func startTimer(_ sender: Any) {
        if(timerActive) {
            showAlertToUser()
        } else {
            timerActive = true
            self.updateUITimer()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.timeElapsedInSeconds += 1
                self.updateUITimer()
                if self.timeElapsedInSeconds >= self.timerMode!.timer {
                    timer.invalidate()
                    self.saveToFirebase()
                    self.moveToNextMode()
                }
            }
        }
    }
    
    @IBAction func openSettingsScreen(_ sender: Any) {
        self.performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    private func timeWasChangeOnSettings(updated: Bool){
        if(timerActive) {
            return
        } else {
            updateTimerMode(mode: timerMode!.currentMode)
        }
    }
    
    private func initializeUserInformation(){
        if(user != nil) {
            userNameView.text = user?.userName
            userImageView.setProfileImage(imageUrl: user!.userPhotoUrl)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            userInfoView.isHidden = true
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    private func edittingGesture(){
        let tap  = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func updateTimerMode(mode: Int){
        if(mode == TimerContants.focusMode) {
            timerMode = TimerMode(mode: TimerContants.focusMode)
        } else {
            timerMode = TimerMode(mode: TimerContants.restMode)
        }
        
        timerActive = false
        timeElapsedInSeconds = 0
        updateTimerTitle()
        updateUITimer()
    }
    
    private func intializeProgressView(){
        circularProgressView.frame = CGRect(x: 0, y: 0, width: 320, height: 320)
        clockBackground.addSubview(circularProgressView)
    }
    
    private func intializeLifeCycleObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func appMovedToBackground() {
        print("appMovedToBackground")
        lastDate = Date()
    }
    
    @objc private func appCameToForeground() {
        print("appCameToForeground")
        updateTimer()
    }
    
    private func updateTimer(){
        if(lastDate == nil || timerActive == false) {
            return
        }
        
        let date = Date()
        let diffComponents = Calendar.current.dateComponents([.minute, .second], from: lastDate!, to: date)
        let seconds = diffComponents.second
        self.timeElapsedInSeconds += seconds ?? 0
        if self.timeElapsedInSeconds > self.timerMode!.timer {
            self.timeElapsedInSeconds = self.timerMode!.timer
        }
        updateUITimer()
    }
    
    private func saveToFirebase() {
        if let userId = user?.userId {
            let mode = timerMode?.currentMode ?? 0
            FirebaseAPI.saveTaskToFirebase(userId: userId,
                                           task: Task(name: taskNameTextField.text ?? "",
                                                      mode: mode,
                                                      seconds: self.timeElapsedInSeconds,
                                                      date: Date()))
        }
    }
    
    private func showAlertToUser(){
        var title = ""
        if(timerMode?.currentMode == TimerContants.focusMode) {
            title = alertTitleCancel
        } else {
            title = alertTitleSkip
        }
        
        let alert = UIAlertController(title: title,
                                      message: "",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: alertConfirm,
                                       style: .default) {
                                        action in
                                        self.confirmCancelTimer()
        }
        
        let cancelAction = UIAlertAction(title: alertCancel,
                                         style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func confirmCancelTimer(){
        timer.invalidate()
        saveToFirebase()
        updateTimerMode(mode: TimerContants.focusMode)
    }
    
    private func moveToNextMode(){
        if(timerMode?.currentMode == TimerContants.focusMode) {
            updateTimerMode(mode: TimerContants.restMode)
        } else {
            updateTimerMode(mode: TimerContants.focusMode)
        }
    }
    
    private func updateUITimer(){
        let currentTimer = self.timerMode!.timer
        circularProgressView.updateValues(currentAmount: CGFloat(self.timeElapsedInSeconds), totalAmount: CGFloat(currentTimer - self.timeElapsedInSeconds))
        updateNumericTimerFrom(seconds: self.timeElapsedInSeconds)
        updateUIBackground()
    }
    
    private func updateNumericTimerFrom(seconds: Int){
        let remainingTime = timerMode!.timer - seconds
        clockDisplay.text = remainingTime.getFormattedTimer()
    }
    
    private func updateTimerTitle(){
        if(timerMode?.currentMode == TimerContants.focusMode) {
            taskNameTextField.text = ""
            taskNameTextField.isEnabled = true
            taskNameTextField.attributedPlaceholder = NSAttributedString(string: focusModeHint,
                                                                         attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)])
        } else {
            taskNameTextField.isEnabled = false
            taskNameTextField.text = restModeTitle
        }
    }
    
    private func updateUIBackground(){
        var clockBackgroundAsset = ""
        var buttonBackgroundAsset = ""
        if(timerMode?.currentMode == TimerContants.focusMode) {
            clockBackgroundAsset = "clock_background_orange"
            if(timerActive) {
                buttonBackgroundAsset = "stop_button_orange"
            } else {
                buttonBackgroundAsset = "play_button_orange"
            }
        } else {
            clockBackgroundAsset = "clock_background_blue"
            if(timerActive) {
                buttonBackgroundAsset = "stop_button_blue"
            } else {
                buttonBackgroundAsset = "play_button_blue"
            }
            
        }
        clockBackground.image = UIImage(named: clockBackgroundAsset)
        timerButton.setBackgroundImage(UIImage(named: buttonBackgroundAsset), for: UIControl.State.normal)
    }
    
}
