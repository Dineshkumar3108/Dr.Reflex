//
//  ChatViewController.swift
//  Dr.Reflex
//
//  Created by priyanka gayathri on 03/09/20.
//  Copyright © 2020 priyanka. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var textfieldView: UIView!
    enum ChatUserType: String {
        case mine = "myChatCell"
        case toChat = "toChatCell"
    }
    
    @IBOutlet weak var contactName: UILabel!
    var messages = [Message]()
    let db = Firestore.firestore()
    var toEmail = String()
    var toUserName = String()
    //var doctorTypeMail = String()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    @IBOutlet weak var messageTextfield: UITextField!
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        let cellIdentifier = getIdentifiers(type: message.sender).rawValue
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChatTableViewCell {
            if message.sender == UserDefaults.standard.string(forKey: "myUserEmail") {
                cell.myMesgLbl?.text = message.body
                cell.containerMyMsgView.layer.cornerRadius = 18.0
                cell.containerMyMsgView.layer.masksToBounds = true
               
            } else {
                cell.toMsgLbl?.text = message.body
                cell.containerToMsgView.layer.cornerRadius = 18.0
                cell.containerToMsgView.layer.masksToBounds = true
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }
    
    func getIdentifiers(type: String) -> ChatUserType {
        if type == toEmail {
            return .toChat
        }
        return .mine
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextfield.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        textfieldView.layer.cornerRadius = 28.0
        contactName.text = toUserName
        getMessages()
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        sendMessages()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextfield.resignFirstResponder()
        return true
    }
    
}

extension ChatViewController {
    
    // Mark: - get Messages
    func getMessages() {
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField)
            .getDocuments()
                { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            
                            if UserDefaults.standard.string(forKey: "Type") == "patient" {
                                if let sender = document.data()["sender"] as? String, let to = document.data()["ToName"] as? String ,let message = document.data()["body"] as? String {
                                    if (self.toEmail == to && sender == Auth.auth().currentUser?.email) || (to == Auth.auth().currentUser?.email && sender == self.toEmail) {
                                        self.messages.append(Message(sender: sender , body: message))
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
                                            let indexPath = IndexPath(row: self.messages.count-1 , section : 0)
                                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                        }
                                    }
                                }
                                
                                //                                if let sender = document.data()["sender"] as? String, let to = document.data()["ToName"] as? String ,let message = document.data()["body"] as? String {
                                
                                
                            }
                            else if UserDefaults.standard.string(forKey: "Type") == "doctor" {
                                
                                if let sender = document.data()["sender"] as? String, let to = document.data()["ToName"] as? String ,let message = document.data()["body"] as? String {
                                    
                                    if sender == self.toEmail || sender == UserDefaults.standard.string(forKey: "myUserEmail") {
                                        if sender == self.toEmail || to == self.toEmail {
                                            self.messages.append(Message(sender: sender , body: message))
                                            DispatchQueue.main.async {
                                                self.tableView.reloadData()
                                                let indexPath = IndexPath(row: self.messages.count-1 , section : 0)
                                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                            }
                                        }
                                    }
                                }
                                //                                sender == self.toEmail || sender == UserDefaults.standard.string(forKey: "myUserEmail") {
                                //                                self.messages.append(Message(sender: sender , body: message))
                                //                                 DispatchQueue.main.async {
                                //                                                                      self.tableView.reloadData()
                                //                                                                      let indexPath = IndexPath(row: self.messages.count-1 , section : 0)
                                //                                                                      self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                //                                                                  }
                                
                                
                                
                            }
                        }
                    }
        }
    }




// Mark: - send Messages
func sendMessages() {
    if messageTextfield.text != "" {
        
        if let messageBody = messageTextfield.text , let messageSender = Auth.auth().currentUser?.email, let currentUser = UserDefaults.standard.string(forKey: "myUserName") {
            db.collection(Constants.FStore.collectionName).addDocument(data: [Constants.FStore.senderField : messageSender , Constants.FStore.bodyField : messageBody, Constants.FStore.dateField : Date().timeIntervalSince1970, "senderName" : currentUser, "ToName": toEmail
                ])
            { (error) in
                if let e = error {
                    print("Error has occured \(e)")
                }
                else {
                    self.messages.append(Message(sender: messageSender, body: messageBody))
                    self.tableView.reloadData()
                    self.messageTextfield.text = ""
                    print("Running successfully")
                }
            }
        }
        
    }
    
}

}
