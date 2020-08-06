//
//  User.swift
//  FlowPomodoro
//
//  Created by Byron Ajin on 8/3/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import Foundation

enum SignInMethod {
    static let firebase = 2
    static let guest = 2
}

struct User {
    var userId: String = ""
    var userName: String = ""
    var userPhotoUrl: String = ""
    var signInMethod: Int = SignInMethod.guest
    
    func isGuestUser() -> Bool {
        return signInMethod == SignInMethod.guest
    }
}
