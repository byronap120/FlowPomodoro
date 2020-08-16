//
//  TimerMode.swift
//  FlowPomodoro
//
//  Created by Byron Ajin on 7/29/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import Foundation


enum TimerContants{
    static let focusTimeDefaultMinutes = 5
    static let restTimeDefaultMinutes = 1
    static let focusMode = 0
    static let restMode = 1
}

struct TimerMode {
    let timer: Int
    let currentMode: Int
    
    init(mode:Int) {
        currentMode = mode
        if(mode == TimerContants.focusMode) {
            timer = getFocusTime() * 60
        } else {
            timer = getRestTime() * 60
        }
    }
}

private func getFocusTime() -> Int{
    let defaults = UserDefaults.standard
    let focusTimer = defaults.object(forKey:"focusTimerKey") as? Int ?? TimerContants.focusTimeDefaultMinutes
    return focusTimer
}

private func getRestTime() -> Int{
    let defaults = UserDefaults.standard
    let focusTimer = defaults.object(forKey:"restTimerKey") as? Int ?? TimerContants.restTimeDefaultMinutes
    return focusTimer
}
