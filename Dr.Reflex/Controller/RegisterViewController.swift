//
//  RegisterViewController.swift
//  Dr.Reflex
//
//  Created by priyanka gayathri on 30/08/20.
//  Copyright © 2020 priyanka. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    let symbol = UIImage(systemName: "checkmark.seaj.fill")
    @IBOutlet weak var nameTxt: UITextField!
    var male = false
    var female = false
    @IBOutlet weak var ageVal: UILabel!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    
    
    @IBOutlet weak var femaleCheck: UIButton!
    
    @IBOutlet weak var maleCheck: UIButton!
    
    @IBOutlet weak var signUpButtonClicked: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTxt.underlined()
        emailTxt.underlined()
        passwordTxt.underlined()
        emailTxt.delegate = self
        passwordTxt.delegate = self
        nameTxt.delegate = self
        signUpButtonClicked.layer.cornerRadius = 18.0
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
    
    @IBAction func ageSlider(_ sender: UISlider) {
        
        ageVal.text = String(Int(sender.value))
        
        
    }
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if nameTxt.text == "" {
            let nameAlert = UIAlertController(title: Constants.enterName , message: nil , preferredStyle: .alert)
            nameAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler : { (alert)
                in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(nameAlert, animated: true)
        } else if emailTxt.text == "" {
            
            let emailAlert = UIAlertController(title: Constants.enterMail , message: nil, preferredStyle: .alert)
            emailAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler: { (alert) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(emailAlert, animated: true)
        }
            
        else if passwordTxt.text == "" {
            let passwordAlert = UIAlertController(title: Constants.enterPass , message: nil, preferredStyle: .alert)
            
            passwordAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler: { (alert) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(passwordAlert, animated: true)
        }
            
        else if male == female {
            let nameAlert = UIAlertController(title: Constants.enterGender , message: nil , preferredStyle: .alert)
            nameAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler : { (alert)
                in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(nameAlert, animated: true)
        }
        else if ageVal.text == "" {
            let nameAlert = UIAlertController(title: Constants.enterAge , message: nil , preferredStyle: .alert)
            nameAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler : { (alert)
                in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(nameAlert, animated: true)
        }
            
        else {
            let emailResult = isValidEmail(emailTxt.text!)
            let passwordResult = isValidPassword(passwordTxt.text!)
            
            if emailResult == false{
                let invalidEmailAlert = UIAlertController(title: Constants.enterValidMail, message: nil, preferredStyle: .alert)
                invalidEmailAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler: { (alert) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(invalidEmailAlert, animated: true)
            }
                
            else if passwordResult == false {
                let invalidPasswordAlert = UIAlertController(title: Constants.enterValidPass, message: nil, preferredStyle: .alert)
                invalidPasswordAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler: { (alert) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(invalidPasswordAlert, animated: true)
            }
                
            else{
                Auth.auth().createUser(withEmail: emailTxt.text ?? "", password: passwordTxt.text ?? "") { authResult, error in
                    
                    if let success = authResult {
                        self.performSegue(withIdentifier: Constants.registerSegue , sender: self)
                        let db = Firestore.firestore()
                        
                        var ref: DocumentReference? = nil
                        ref = db.collection("Patientusers").addDocument(data: [
                            "email": self.emailTxt.text ?? "" , "name": self.nameTxt.text ?? ""
                        ]) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                UserDefaults.standard.set(self.nameTxt.text, forKey: "myUserName")
                                UserDefaults.standard.set(true, forKey: "logIn")  //
                                UserDefaults.standard.set("patient", forKey: "Type")
                                UserDefaults.standard.set(self.emailTxt.text, forKey: "myUserEmail")
                                self.performSegue(withIdentifier: Constants.registerSegue , sender: self)
                                print("proceed: \(ref!.documentID)")
                            }
                        }
                        
                        
                    } else if let err = error {
                        
                        let anotherAccAlert = UIAlertController(title: Constants.error, message: err.localizedDescription, preferredStyle: .alert)
                        
                        anotherAccAlert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler: { (alert) in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        
                        self.present(anotherAccAlert, animated: true, completion: nil)
                        
                        
                        
                        print("Result Error: \(err.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailTxt.text)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let validate = ("(?:(?:(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_])|(?:(?=.*?[0-9])|(?=.*?[A-Z])|(?=.*?[-!@#$%&*ˆ+=_])))|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_]))[A-Za-z0-9-!@#$%&*ˆ+=_]{6,15}")
        
        let passwordvalid = NSPredicate(format:"SELF MATCHES %@", validate)
        return passwordvalid.evaluate(with: passwordTxt.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        nameTxt.resignFirstResponder()
        return true
    }
}

extension UITextField {
    func underlined() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width-20, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
