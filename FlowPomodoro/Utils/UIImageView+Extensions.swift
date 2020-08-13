//
//  UIImageView+Extensions.swift
//  FlowPomodoro
//
//  Created by Byron Ajin on 8/13/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit
import Kingfisher


extension UIImageView {
    
    func setProfileImage(imageUrl: String){
        let url = URL(string: imageUrl)
        self.kf.setImage(with: url)
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}
