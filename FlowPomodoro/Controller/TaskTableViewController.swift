//
//  TaskTableViewController.swift
//  FlowPomodoro
//
//  Created by Byron Ajin on 8/3/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit
import Kingfisher

class TaskTableViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
        
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    
    var user: User?
    private var taskList = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        taskTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        progressIndicator.startAnimating()
        progressIndicator.isHidden = false
        initializeUserInformation()
        getInfoFromFirebase()
    }
    
    @IBAction func logOutUser(_ sender: Any) {
        FirebaseAPI.userSignOut()
        self.performSegue(withIdentifier: "logOutUser", sender: nil)
    }
    
    private func initializeUserInformation(){
        if(user != nil) {
            userImageView.setProfileImage(imageUrl: user!.userPhotoUrl)            
            userNameLabel.text = user?.userName
        }
    }
    
    private func getInfoFromFirebase(){
        if let userId = user?.userId {
            FirebaseAPI.getTaskForUser(userId: userId, completionHandler: taskListHandler(remoteTaskList:error:))
        }
    }
    
    private func taskListHandler(remoteTaskList: [Task], error: Error?) {
        if error != nil {
            showAlertMessage(title: "Error", message: error!.localizedDescription)
            return
        }
        
        progressIndicator.stopAnimating()
        progressIndicator.isHidden = true
        
        if remoteTaskList.isEmpty {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
            taskList = remoteTaskList
            taskTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = taskList[(indexPath as NSIndexPath).row]
        let taskViewCell = tableView.dequeueReusableCell(withIdentifier: "TaskViewCell") as! TaskTableViewCell
        taskViewCell.taskNameLabel.text = getTaskName(name: task.name)
        taskViewCell.taskDate.text = getFormatedDate(taskDate: task.date)
        taskViewCell.taskTimeCompleted.text = task.seconds.getFormattedTimer()
        
        taskViewCell.taskView.layer.cornerRadius = 10
        taskViewCell.taskView.layer.shadowColor = UIColor.black.cgColor
        taskViewCell.taskView.layer.shadowOffset = CGSize(width: 3, height: 3)
        taskViewCell.taskView.layer.shadowRadius = 4
        taskViewCell.taskView.layer.shadowOpacity = 0.1
        
        if(task.mode == TimerContants.focusMode) {
            taskViewCell.timerImageView.image = UIImage(named: "focus_icon")
        } else {
            taskViewCell.timerImageView.image = UIImage(named: "rest_icon")
        }
        
        return taskViewCell
    }
    
    private func getFormatedDate(taskDate: Date) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "MM-dd-yyyy"
        return dateformat.string(from: taskDate)
    }
    
    private func getTaskName(name: String) -> String{
        if(name.isEmpty) {
            return "No name"
        }
        return name
    }
}
