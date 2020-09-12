//
//  DoctorDomainViewController.swift
//  Dr.Reflex
//
//  Created by priyanka gayathri on 04/09/20.
//  Copyright © 2020 priyanka. All rights reserved.
//

protocol DoctorDomain {
    func selectedDoctor(domain: String)
}

import UIKit

class DoctorDomainViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var delegate: DoctorDomain?
    let domainNames : [String] = ["General Physcician","Cardiologist","Gynaecologist","Allergist","Pediatrician","Dermatologist","Psychologist","Neurologist","Urologist"]
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select The Domain"
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = domainNames[indexPath.row]
             return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedDoctor(domain: domainNames[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBOutlet weak var docDomainTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        docDomainTableView.delegate = self
        docDomainTableView.dataSource = self
        
    }
    


}
