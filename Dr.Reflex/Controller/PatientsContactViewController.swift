//
//  PatientsContactViewController.swift
//  Dr.Reflex
//
//  Created by priyanka gayathri on 04/09/20.
//  Copyright © 2020 priyanka. All rights reserved.
//

import UIKit
import Firebase

class PatientsContactViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let db = Firestore.firestore()
    var userName = String()
    var messages = [Message]()
    var patientNameArray = [DoctorToChat]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = patientNameArray[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "doctorToPatientChat", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ChatViewController {
            let indexPath = PatientContactTableView.indexPathForSelectedRow
            if let index = indexPath {
                let email = patientNameArray[index.row].email
                vc.toEmail = email
                vc.toUserName = patientNameArray[index.row].name
                
            }
        }
    }
    
    @IBAction func logOutBtnClicked(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBOutlet weak var PatientContactTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        PatientContactTableView.delegate = self
        PatientContactTableView.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
               navigationItem.hidesBackButton = true
        getChatContactList()
    }
    
    //    func prepare(for segue: UIStoryboardSegue, sender: String) {
    //        if let vc = segue.destination as? ChatViewController {
    //            vc.toEmail = sender
    //        }
    //    }
    
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
                            if let sender = document.data()["sender"] as? String, let  Myemail = UserDefaults.standard.string(forKey: "myUserEmail"),let  toName =  document.data()["ToName"] as? String, let Mesgname = document.data()["senderName"] as? String {
                                
                                if Myemail == toName {
                                    
                                    self.patientNameArray.append(DoctorToChat(email: sender, name: Mesgname))
                                    
                                }
                            }
                        }
                    }
                    self.patientNameArray = self.removeDuplicateInts(values: self.patientNameArray)
                    self.PatientContactTableView.reloadData()
        }
    }
    
    func removeDuplicateInts(values: [DoctorToChat]) -> [DoctorToChat] {
        // Convert array into a set to get unique values.
        let uniques = Set<DoctorToChat>(values)
        // Convert set back into an Array of Ints.
        let result = Array<DoctorToChat>(uniques)
        return result
    }
}
