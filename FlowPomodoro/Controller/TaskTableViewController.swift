//
//  TaskTableViewController.swift
//  FlowPomodoro
//
//  Created by Byron Ajin on 8/3/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit

class TaskTableViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    var user: User?
    private var taskList = [Task]()
    
    @IBOutlet weak var taskTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getInfoFromFirebase()
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
        taskList = remoteTaskList
        taskTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = taskList[(indexPath as NSIndexPath).row]
        let taskViewCell = tableView.dequeueReusableCell(withIdentifier: "TaskViewCell") as! TaskTableViewCell
        taskViewCell.taskNameLabel.text = "\(task.name)"
        return taskViewCell
    }
    
}
