//
//  TestViewController.swift
//  Dr.Reflex
//
//  Created by priyanka gayathri on 03/09/20
//  Copyright © 2020 priyanka. All rights reserved
//

import UIKit
import Firebase

class TestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let db = Firestore.firestore()
    var nameList = [String]()
    var emailList = [String]()
    var specialistList = [String]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = nameList[indexPath.row]
        
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    var specialistType = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        // navigationItem.hidesBackButton = true
        
        print("receiveedddd:\(specialistType)")
        tableView.delegate = self
        tableView.dataSource = self
        db.collection("Doctorusers").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if let specialist = document.data()["specialist"] as? String, let name = document.data()["name"] as? String , let email = document.data()["email"] as? String {
                        if  specialist == self.specialistType {
                            self.nameList.append(name)
                            self.emailList.append(email)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "patientToDoctorChat" , sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ChatViewController {
            let indexPath = tableView.indexPathForSelectedRow
            if let index = indexPath {
                let email = emailList[index.row]
                let name = nameList[index.row]
                vc.toEmail = email
                vc.toUserName = name
            }
        }
    }
}
