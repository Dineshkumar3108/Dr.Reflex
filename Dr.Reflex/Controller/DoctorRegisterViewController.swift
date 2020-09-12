//
//  DoctorRegisterViewController.swift
//  Dr.Reflex
//
//  Created by priyanka gayathri on 04/09/20.
//  Copyright © 2020 priyanka. All rights reserved.
//

import UIKit
import Firebase

class DoctorRegisterViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var phoneNoTextfield: UITextField!
    @IBOutlet weak var ageVal: UILabel!
    @IBOutlet weak var cityNameTextfield: UITextField!
    @IBOutlet weak var proceedBtn: UIButton!
    
    @IBOutlet weak var nameTextfield: UITextField!
    var male = false
    var female = false
    
    @IBOutlet weak var domainSelectionBtn: UIButton!
    @IBOutlet weak var maleCheck: UIButton!
    
    @IBOutlet weak var femaleCheck: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        proceedBtn.layer.cornerRadius = 18.0
        nameTextfield.delegate = self
        phoneNoTextfield.delegate = self
        cityNameTextfield.delegate = self
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
    }
    
    @IBAction func ageStepper(_ sender: UIStepper) {
        
        ageVal.text = String(Int(sender.value))
    }
    
    @IBAction func maleCheck(_ sender: UIButton) {
        if male == false {
            sender.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
            femaleCheck.setImage(UIImage(systemName: "square"), for: .normal)
            male = true
            female = false
        } else {
            sender.setImage(UIImage(systemName: "square"), for: .normal)
            femaleCheck.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
            male = false
            female = true
        }
    }
    
    @IBAction func femaleCheck(_ sender: UIButton) {
        
        if female == false {
            sender.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
            maleCheck.setImage(UIImage(systemName: "square"), for: .normal)
            male = false
            female = true
        } else {
            sender.setImage(UIImage(systemName: "square"), for: .normal)
            maleCheck.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
            male = true
            female = false
        }
        
    }
    
    
    @IBAction func domainSlcBtn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "domainLists" , sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DoctorDomainViewController {
            vc.delegate = self
        }
    }
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBAction func registerPressed(_ sender: UIButton) {
        print("registerPressed")
        if nameTextfield.text == "" {
            
            let emailAlert = UIAlertController(title: Constants.enterName , message: nil, preferredStyle: .alert)
            emailAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler: { (alert) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(emailAlert, animated: true)
        }
            
        else if male == female {
            let nameAlert = UIAlertController(title: Constants.enterGender , message: nil , preferredStyle: .alert)
            nameAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler : { (alert)
                in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(nameAlert, animated: true)
        }
            
        else if ageVal.text == "0" {
            let nameAlert = UIAlertController(title: Constants.enterExperience , message: nil , preferredStyle: .alert)
            nameAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler : { (alert)
                in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(nameAlert, animated: true)
        }
            
        else if domainSelectionBtn.titleLabel?.text == "Select the domain" {
            
            let nameAlert = UIAlertController(title: Constants.enterDomain , message: nil , preferredStyle: .alert)
            nameAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler : { (alert)
                in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(nameAlert, animated: true)
            
        }
            
        else if phoneNoTextfield.text == "" {
            
            let nameAlert = UIAlertController(title: Constants.enterPNo , message: nil , preferredStyle: .alert)
            nameAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler : { (alert)
                in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(nameAlert, animated: true)
            
        }
            
        else if cityNameTextfield.text == "" {
            
            let nameAlert = UIAlertController(title: Constants.enterCity , message: nil , preferredStyle: .alert)
            nameAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler : { (alert)
                in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(nameAlert, animated: true)
            
        }
            
        else if emailTextfield.text == "" {
            
            let emailAlert = UIAlertController(title: Constants.enterMail , message: nil, preferredStyle: .alert)
            emailAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler: { (alert) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(emailAlert, animated: true)
        }
            
        else if passwordTextfield.text == "" {
            let passwordAlert = UIAlertController(title: Constants.enterPass , message: nil, preferredStyle: .alert)
            
            passwordAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler: { (alert) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(passwordAlert, animated: true)
        }
            
        else if !isValidEmail(emailTextfield.text!) {
            //                let emailResult = isValidEmail(emailTextfield.text!)
            //                let passwordResult = isValidPassword(passwordTextfield.text!)
            
            //  if emailResult == false{
            let invalidEmailAlert = UIAlertController(title: Constants.enterValidMail, message: nil, preferredStyle: .alert)
            invalidEmailAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler: { (alert) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(invalidEmailAlert, animated: true)
        }
            
        else if !isValidPassword(passwordTextfield.text!) {
            let invalidPasswordAlert = UIAlertController(title: Constants.enterValidPass, message: nil, preferredStyle: .alert)
            invalidPasswordAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler: { (alert) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(invalidPasswordAlert, animated: true)
        }
            
        else {
            Auth.auth().createUser(withEmail: emailTextfield.text ?? "", password: passwordTextfield.text ?? "") { authResult, error in
                
                if let success = authResult {
                    
                    let db = Firestore.firestore()
                    
                    var ref: DocumentReference? = nil
                    ref = db.collection("Doctorusers").addDocument(data: [
                        "email": self.emailTextfield.text , "specialist": self.domainSelectionBtn.titleLabel?.text ,"name": self.nameTextfield.text
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                            print("success")
                            UserDefaults.standard.set(self.nameTextfield.text, forKey: "myUserName")
                            UserDefaults.standard.set(true, forKey: "logIn")
                            UserDefaults.standard.set("doctor", forKey: "Type")
                            UserDefaults.standard.set(self.emailTextfield.text, forKey: "myUserEmail")
                            self.performSegue(withIdentifier: Constants.registerSegue , sender: self)
                        }
                    }
                } else if let err = error {
                    let anotherAccAlert = UIAlertController(title: Constants.error, message: err.localizedDescription, preferredStyle: .alert)
                    anotherAccAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler: { (alert) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(anotherAccAlert, animated: true, completion: nil)
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
        phoneNoTextfield.resignFirstResponder()
        cityNameTextfield.resignFirstResponder()
        nameTextfield.resignFirstResponder()
        return true
    }
}

extension DoctorRegisterViewController: DoctorDomain {
    //domainLists
    func selectedDoctor(domain: String) {
        print("The domain name is:\(domain)")
        domainSelectionBtn.setTitle(domain, for: .normal)
        
    }
}
