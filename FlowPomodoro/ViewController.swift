//
//  ViewController.swift
//  FlowPomodoro
//
//  Created by Byron Ajin on 7/25/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var lastDate: Date?
    private var timeElapsedInSeconds: Int = 0
    private let progressView = ProgressView()
    private var timerMode: TimerMode?
    
    @IBOutlet weak var clockBackground: UIImageView!
    @IBOutlet weak var clockDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intializeLifeCycleObservers()
        intializeProgressView()
        updateTimerMode(mode: TimerContants.focusMode)
    }
    
    private func updateTimerMode(mode: Int){
        if(mode == TimerContants.focusMode) {
            timerMode = TimerMode(timer: TimerContants.focusTime, currentMode: TimerContants.focusMode)
        } else {
            timerMode = TimerMode(timer: TimerContants.restTime, currentMode: TimerContants.restMode)
        }
        
        timeElapsedInSeconds = 0
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
        
        print("difference2: \(seconds)")
        
        self.timeElapsedInSeconds += seconds ?? 0
        if self.timeElapsedInSeconds > self.timerMode!.timer {
            self.timeElapsedInSeconds = self.timerMode!.timer
        }
        updateUITimer()
    }
    
    @IBAction func startTimer(_ sender: Any) {
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.timeElapsedInSeconds += 1
            self.updateUITimer()
            if self.timeElapsedInSeconds >= self.timerMode!.timer {
                timer.invalidate()
                self.moveToNextMode()
            }
        }
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
        self.progressView.updateValues(currentAmount: CGFloat(self.timeElapsedInSeconds), totalAmount: CGFloat(currentTimer - self.timeElapsedInSeconds))
        self.updateNumericTimerFrom(seconds: self.timeElapsedInSeconds)
    }
    
    private func updateNumericTimerFrom(seconds: Int){
        let remainingTime = timerMode!.timer - seconds
        
        let minutesFormatted = (remainingTime % 3600) / 60
        let secondsFormatted = (remainingTime % 3600) % 60
        let formattedTime = String(format: "%0.2d:%0.2d",  minutesFormatted, secondsFormatted)
        
        clockDisplay.text = formattedTime
        print("Formated timer2-> \(formattedTime)")
    }
    
    private func updateButtonConfiguration(){
        
    }
    
    
}
