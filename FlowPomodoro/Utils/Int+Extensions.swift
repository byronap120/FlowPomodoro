//
//  Int+Extensions.swift
//  FlowPomodoro
//
//  Created by Byron Ajin on 8/12/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import Foundation

extension Int {
    
    func getFormattedTimer() -> String{
        let minutesFormatted = (self % 3600) / 60
        let secondsFormatted = (self % 3600) % 60
        return String(format: "%0.2d:%0.2d",  minutesFormatted, secondsFormatted)
    }

}
