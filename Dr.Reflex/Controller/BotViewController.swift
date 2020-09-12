//
//  BotViewController.swift
//  Dr.Reflex
//
//  Created by priyanka gayathri on 03/09/20.
//  Copyright © 2020 priyanka. All rights reserved.
//

import UIKit

class BotViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = getCellIdentifier(indexPath: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChatTableViewCell else {
            return UITableViewCell()
        }
        cell.myLbl.text = "khjjkxjkcvjknckbvcb"
        cell.myLbl.layer.cornerRadius = 10

       // cell.docLbl.text = "my name is doctor"
        //cell.layer.cornerRadius = 10
        return cell
        
    }
    
    func getCellIdentifier(indexPath: Int) -> String {
        if indexPath % 2 == 0 {
            return "myChatcell"
        } else {
            return "docChatcell"
        }
    }
    
   
    @IBOutlet weak var contentview: UIView!
    
    @IBOutlet weak var botTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        botTableView.delegate = self
        botTableView.dataSource = self
        
        messageField.layer.borderColor = UIColor.purple.cgColor
        
        messageField.layer.borderWidth = 2
        
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var messageField: UITextField!
    
    
}
