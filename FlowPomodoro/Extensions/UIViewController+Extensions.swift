//
//  UIViewController+Extensions.swift
//  FlowPomodoro
//
//  Created by Byron Ajin on 8/5/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
