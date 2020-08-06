//
//  FirebaseAPI.swift
//  FlowPomodoro
//
//  Created by Byron Ajin on 8/5/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class FirebaseAPI {
    
    class func isUserAuthenticated() -> User? {
        if let authUser = Auth.auth().currentUser {
            var user = User()
            user.userName = authUser.displayName ?? ""
            user.userId = authUser.uid
            user.userPhotoUrl = authUser.photoURL?.absoluteString ?? ""
            return user
        }
        return nil
    }
    
    class func signInWithFacebook(accessToken: String, completionHandler: @escaping (Bool, Error?) -> Void){
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                completionHandler(false, error)
            } else {
                completionHandler(true, nil)
            }
        }
    }
    
    class func signInWithGoogle(idToken: String, accessToken: String, completionHandler: @escaping (Bool, Error?) -> Void){
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                completionHandler(false, error)
            } else {
                completionHandler(true, nil)
            }
        }
    }
    
    class func saveTaskToFirebase(userId: String, task: Task){
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection(userId).addDocument(data: [
            "taskName": task.name,
            "timerMode": task.mode,
            "timer": task.seconds,
            "date": task.date,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    class func getTaskForUser(userId: String, completionHandler: @escaping ([Task], Error?) -> Void) {
        var newTaskList = [Task]()
        let db = Firestore.firestore()
        db.collection(userId).order(by: "date", descending: true).getDocuments() { (querySnapshot, err) in
            if let error = err {
                completionHandler(newTaskList, error)
            } else {
                for document in querySnapshot!.documents {
                    let date = document.data()["date"] as? Timestamp
                    let taskName = document.data()["taskName"] as? String
                    let taskMode = document.data()["taskMode"] as? String
                    let taskSeconds = document.data()["timer"] as? Int
                    
                    //                    let dateTemp: Date = date?.dateValue() ?? Date()
                    //                    let dateformat = DateFormatter()
                    //                    dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    //                    let dateString = dateformat.string(from: dateTemp)
                    //                    let temp =  (taskName ??  "") + dateString
                    
                    let task = Task(name: taskName ?? "",
                                    mode: taskMode ?? "",
                                    seconds: taskSeconds ?? 0,
                                    date: date?.dateValue() ?? Date())
                    
                    newTaskList.append(task)
                }
                completionHandler(newTaskList, nil)
            }
        }
    }
    
    
    class func userSignOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
