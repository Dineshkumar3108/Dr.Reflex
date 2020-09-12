//
//  DoctorSignInViewController.swift
//  Dr.Reflex
//
//  Created by priyanka gayathri on 04/09/20.
//  Copyright © 2020 priyanka. All rights reserved.
//

import UIKit
import Firebase

class DoctorSignInViewController: UIViewController,UITextFieldDelegate{

    let db = Firestore.firestore()
    @IBOutlet weak var logInBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextfield.delegate = self
        passwordTextfield.delegate = self
    
        
    }
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func logInPressed(_ sender: UIButton) {
    
    if emailTextfield.text == "" {
               
               alertController(Constants.enterMail)
               
           }
               
           else if passwordTextfield.text == "" {
               alertController(Constants.enterPass)
           }
               
           else {
               let emailResult = isValidEmail(emailTextfield.text!)
               let passwordResult = isValidPassword(passwordTextfield.text!)
               
               if emailResult == false{
                   alertController(Constants.enterValidMail)
               }
                   
               else if passwordResult == false {
                   alertController(Constants.enterValidPass)
               }
                   
               else{
                   Auth.auth().signIn(withEmail: emailTextfield.text ?? "", password: passwordTextfield.text ?? "") { [weak self] authResult, error in
                       guard let strongSelf = self else { return }
                       
                       if let success = authResult {
                        self?.getDoctorName()
                       }
                       else if let err = error {
                           strongSelf.alertController(err.localizedDescription)
                       }
                       
                   }
               }
           }
    }
    
    
       func isValidEmail(_ email: String) -> Bool {
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
           
           let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailPred.evaluate(with: emailTextfield.text)
       }
       
       func isValidPassword(_ password: String) -> Bool {
           let validate = ("(?:(?:(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_])|(?:(?=.*?[0-9])|(?=.*?[A-Z])|(?=.*?[-!@#$%&*ˆ+=_])))|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_]))[A-Za-z0-9-!@#$%&*ˆ+=_]{6,15}")
           
           let passwordvalid = NSPredicate(format:"SELF MATCHES %@", validate)
           return passwordvalid.evaluate(with: passwordTextfield.text)
       }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        return true
    }
    func alertController (_ alertTitle : String) {
        let globalAlert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        globalAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler: { (alert) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(globalAlert, animated: true)
    }
    
    
    func getDoctorName () {
        db.collection("Doctorusers").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if let DName = document.data()["name"] as? String , let email = document.data()["email"] as? String{
                        if  email == self.emailTextfield.text {
                            UserDefaults.standard.set(DName, forKey: "myUserName")
                            UserDefaults.standard.set(true, forKey: "logIn")
                            UserDefaults.standard.set("doctor", forKey: "Type")
                            UserDefaults.standard.set(email, forKey: "myUserEmail")
                            self.performSegue(withIdentifier: Constants.loginSegue , sender: self)

                        }
                    }
                }
            }
            
        }
        print("doctor name")
        print(UserDefaults.standard.string(forKey: "myUserName") ?? "")

    }
    
    
}
