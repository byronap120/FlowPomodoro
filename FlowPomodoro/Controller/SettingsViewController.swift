//
//  SettingsViewController.swift
//  FlowPomodoro
//
//  Created by Byron Ajin on 8/15/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var focusPickerView: UIPickerView!
    @IBOutlet weak var restPickerView: UIPickerView!
    
    var callback : ((Bool)->())?
    private var pickerFocusTime = [Int]()
    private var pickerRestTime = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        pickerFocusTime = [2, 5 , 10 , 20 , 25]
        pickerRestTime = [1, 3 , 5]
        
        updatePickersDefaultOption()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func updatePickersDefaultOption(){
        let focusTime = getFocusTime()
        let defaultFocusIndex: Int = pickerFocusTime.firstIndex(of: focusTime) ?? 0
        focusPickerView.selectRow(defaultFocusIndex, inComponent: 0, animated: true)
        
        let restTime = getRestTime()
        let defaultRestIndex: Int = pickerRestTime.firstIndex(of: restTime) ?? 0
        restPickerView.selectRow(defaultRestIndex, inComponent: 0, animated: true)
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
    
    private func updateTimerFor(key: String, value: Int){
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return pickerFocusTime.count
        } else {
            return pickerRestTime.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return "\(pickerFocusTime[row])"
        } else {
            return "\(pickerRestTime[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var title = ""
        if pickerView.tag == 1 {
            title =  "\(pickerFocusTime[row])"
        } else {
            title =  "\(pickerRestTime[row])"
        }
        return NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            updateTimerFor(key: "focusTimerKey", value: pickerFocusTime[row])
        } else {
            updateTimerFor(key: "restTimerKey", value: pickerRestTime[row])
        }
        callback?(true)
    }
    
}
