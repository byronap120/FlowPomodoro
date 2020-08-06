//
//  TimerViewController.swift
//  FlowPomodoro
//
//  Created by Byron Ajin on 7/25/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    var user: User?
    private var lastDate: Date?
    private var timeElapsedInSeconds: Int = 0
    private var timerActive = false
    private let progressView = ProgressView()
    private var timerMode: TimerMode?
    private var timer = Timer()
    
    @IBOutlet weak var clockBackground: UIImageView!
    @IBOutlet weak var clockDisplay: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var userInfoView: UIStackView!
    @IBOutlet weak var userNameView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intializeLifeCycleObservers()
        initializeUserInformation()
        intializeProgressView()
        updateTimerMode(mode: TimerContants.focusMode)
        edittingGesture()
    }
    
    private func initializeUserInformation(){
        if(user != nil) {
            userNameView.text = user?.userName
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            userInfoView.isHidden = true
        }
    }
    
    @IBAction func logOutUser(_ sender: Any) {
        FirebaseAPI.userSignOut()
        self.performSegue(withIdentifier: "logOutUser", sender: nil)
    }
    
    private func edittingGesture(){
        let tap  = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func updateTimerMode(mode: Int){
        if(mode == TimerContants.focusMode) {
            timerMode = TimerMode(timer: TimerContants.focusTime, currentMode: TimerContants.focusMode)
        } else {
            timerMode = TimerMode(timer: TimerContants.restTime, currentMode: TimerContants.restMode)
        }
        
        timerActive = false
        timeElapsedInSeconds = 0
        updateTimerTitle()
        updateUITimer()
    }
    
    private func intializeProgressView(){
        progressView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        clockBackground.addSubview(progressView)
    }
    
    private func intializeLifeCycleObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        print("app enters background")
        lastDate = Date()
    }
    
    @objc func appCameToForeground() {
        print("app enters foreground")
        updateTimer()
    }
    
    private func updateTimer(){
        guard  lastDate != nil else {
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
    
    @IBAction func startTimer(_ sender: Any) {
        if(timerActive) {
            showAlertToUser()
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.timeElapsedInSeconds += 1
                self.updateUITimer()
                if self.timeElapsedInSeconds >= self.timerMode!.timer {
                    timer.invalidate()
                    self.saveToFirebase()
                    self.moveToNextMode()
                }
            }
            timerActive = true
        }
    }

    private func saveToFirebase() {
        if let userId = user?.userId {
            let taskName = taskNameTextField.text ?? "FocusTime"
            let mode = "mode:\(String(describing: timerMode?.currentMode))"
            FirebaseAPI.saveTaskToFirebase(userId: userId,
                                           task: Task(name: taskName,
                                                      mode: mode,
                                                      seconds: self.timeElapsedInSeconds,
                                                      date: Date()))
        }
    }
    
    private func showAlertToUser(){
        var title = ""
        if(timerMode?.currentMode == TimerContants.focusMode) {
            title = "Are you sure you want to cancel your focus time?"
        } else {
            title = "Are you sure you want to skip your rest time?"
        }
        
        let alert = UIAlertController(title: title,
                                      message: "",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Confirm",
                                       style: .default) {
                                        action in
                                        self.confirmCancelTimer()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
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
        progressView.updateValues(currentAmount: CGFloat(self.timeElapsedInSeconds), totalAmount: CGFloat(currentTimer - self.timeElapsedInSeconds))
        updateNumericTimerFrom(seconds: self.timeElapsedInSeconds)
        
    }
    
    private func updateNumericTimerFrom(seconds: Int){
        let remainingTime = timerMode!.timer - seconds
        
        let minutesFormatted = (remainingTime % 3600) / 60
        let secondsFormatted = (remainingTime % 3600) % 60
        let formattedTime = String(format: "%0.2d:%0.2d",  minutesFormatted, secondsFormatted)
        
        clockDisplay.text = formattedTime
        print("Formated timer2-> \(formattedTime)")
    }
    
    private func updateButtonConfiguration() {
        
    }
    
    private func updateTimerTitle(){
        if(timerMode?.currentMode == TimerContants.focusMode) {
            taskNameTextField.text = ""
            taskNameTextField.isEnabled = true
            taskNameTextField.attributedPlaceholder = NSAttributedString(string: "Add Task Name",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)])
        } else {
            taskNameTextField.isEnabled = false
            taskNameTextField.text = "REST TIME!"
        }
    }
    
}
