//
//  TimerMode.swift
//  FlowPomodoro
//
//  Created by Byron Ajin on 7/29/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import Foundation


enum TimerContants{
    static let focusTime = 60 * 20
    static let restTime = 60 * 1
    static let focusMode = 0
    static let restMode = 1
}

struct TimerMode {
    let timer: Int
    let currentMode: Int
}
