//
//  BotSampleViewController.swift
//  Dr.Reflex
//
//  Created by priyanka gayathri on 04/09/20.
//  Copyright © 2020 priyanka. All rights reserved.
//

import UIKit

class BotSampleViewController: UIViewController {
    @IBOutlet weak var lbl1: UILabel!
    
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl1.layer.cornerRadius = 20
        lbl1.layer.masksToBounds = true
        lbl2.layer.cornerRadius = 20
        lbl2.layer.masksToBounds = true
        lbl3.layer.cornerRadius = 20
        lbl3.layer.masksToBounds = true

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
