//
//  HomeViewController.swift
//  Dr.Reflex
//
//  Created by priyanka gayathri on 01/09/20.
//  Copyright © 2020 priyanka. All rights reserved.
//

import UIKit
import Firebase
class HomeViewController: UIViewController , UITableViewDelegate ,UITableViewDataSource {
    
    var filtered : [String] = []
    var searchActive : Bool = false
    let db = Firestore.firestore()
       var specialistList = [String]()

    
    var imageArray  = ["generalphyscician.jpg","cardiologist.jpg","gynaecologist.jpg", "allergist.jpg", "pediatricians.jpg",  "dermatologist.jpg",
        "psychologist.jpg", "neurology.jpg","urologist.jpg"]
    var domainNames : [String] = ["General Physcician","Cardiologist","Gynaecologist","Allergist","Pediatrician","Dermatologist","Psychologist","Neurologist","Urologist"]
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HomeTableViewCell {
            cell.domainImages.image = UIImage(named: imageArray[indexPath.row])
            cell.lblDomain.text = domainNames[indexPath.row]

            return cell
        }
      return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cell", sender: indexPath.row)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TestViewController {
           // let indexPath = homeTableView.indexPathForSelectedRow
            if let row = sender as? Int {
                vc.specialistType = domainNames[row]
            }
        }
    }
    
    @IBAction func logOutButtonClicked(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
               do {
                   try firebaseAuth.signOut()
                UserDefaults.standard.set("", forKey: "myUserName")
                UserDefaults.standard.set(false, forKey: "logIn")
                UserDefaults.standard.set("", forKey: "Type")
                UserDefaults.standard.set("", forKey: "myUserEmail")
                   navigationController?.popToRootViewController(animated: true)
               } catch let signOutError as NSError {
                   print ("Error signing out: %@", signOutError)
               }
    }


    @IBOutlet weak var homeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.isNavigationBarHidden = true
        navigationItem.hidesBackButton = true
        homeTableView.delegate = self
        homeTableView.dataSource = self
        db.collection("Doctorusers").getDocuments() { (querySnapshot, err) in
                   if let err = err {
                       print("Error getting documents: \(err)")
                   } else {
                       for document in querySnapshot!.documents {
                           if let email = document.data()["specialist"] as? String {
                               if email != Auth.auth().currentUser?.email{
                                   self.specialistList.append(email)
                               }
                           }
                       }
                       print("specialist:\(self.specialistList)")
                   
                       
                   }
               }
     
        
    }




}

