//
//  ChatTableViewCell.swift
//  Dr.Reflex
//
//  Created by priyanka gayathri on 04/09/20.
//  Copyright © 2020 priyanka. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    @IBOutlet weak var myMesgLbl: UILabel!
    @IBOutlet weak var myLbl: UILabel!
    @IBOutlet weak var toMsgLbl: UILabel!
    @IBOutlet weak var containerMyMsgView: UIView!
    @IBOutlet weak var containerToMsgView: UIView!

    @IBOutlet weak var docLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
