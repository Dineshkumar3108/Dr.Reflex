//
//  ContactViewController.swift
//  Dr.Reflex
//
//  Created by priyanka gayathri on 02/09/20.
//  Copyright © 2020 priyanka. All rights reserved.
//

import UIKit
import Firebase
class ContactViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    var contactList = [String]()
    let db = Firestore.firestore()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = contactList[indexPath.row]
       return cell
    }
    

    @IBOutlet weak var contactTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTableView.delegate = self
        contactTableView.dataSource = self
    }
    
    
    func getChatContactList() {
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField)
            .getDocuments()
                { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            if let sender = document.data()["sender"] as? String, let to = document.data()["To"] as? String ,let message = document.data()["body"] as? String, let  Myemail = UserDefaults.standard.string(forKey: "myUserEmail"),let  toName =  document.data()["ToName"] as? String, let Mesgname = document.data()["senderName"] as? String {
                                
                                if Myemail == sender || Myemail == toName {
                                    self.contactList.append(Mesgname)
                                }
                                
                                
                               // UserDefaults.standard.set(email, forKey: "myUserEmail")

//                                if (self.userName == to && sender == Auth.auth().currentUser?.email) || (to == Auth.auth().currentUser?.email && sender == self.userName) {
//                                    self.messages.append(Message(sender: sender , body: message))
//                                    DispatchQueue.main.async {
//                                        self.tableView.reloadData()
//                                        let indexPath = IndexPath(row: self.messages.count-1 , section : 0)
//                                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//                                    }
                             //   }
                            }
                        }
                    }
                    self.contactTableView.reloadData()
        }
    }
}
