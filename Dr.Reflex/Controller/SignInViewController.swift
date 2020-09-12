//
//  SignInViewController.swift
//  Dr.Reflex
//
//  Created by priyanka gayathri on 30/08/20.
//  Copyright © 2020 priyanka. All rights reserved.
//

//UserDefaults.standard.bool(forKey: "Key")


import UIKit
import Firebase
class SignInViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInClicked.layer.cornerRadius = 15.0
        emailTextfield.delegate = self
        passwordTextfield.delegate = self 
        
    }
    @IBAction func logInClicked(_ sender: UIButton) {
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
                        print("succewss")
                        self?.getPatientName()
                        self?.performSegue(withIdentifier: Constants.loginSegue , sender: self)
                    }
                    else if let err = error {
                        strongSelf.alertController(err.localizedDescription)
                    }
                    
                }
            }
        }
    }
    
    func getPatientName() {
        db.collection("Patientusers").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if let PName = document.data()["name"] as? String , let Pemail = document.data()["email"] as? String {
                        if  Pemail == self.emailTextfield.text {
                            UserDefaults.standard.set(PName, forKey: "myUserName") //Bool
                            UserDefaults.standard.set(true, forKey: "logIn")  //
                            UserDefaults.standard.set("patient", forKey: "Type")
                            UserDefaults.standard.set(Pemail, forKey: "myUserEmail")
                            
                            //
                            
                        }
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
    
    
    
    @IBOutlet weak var signInClicked: UIButton!
    
}
