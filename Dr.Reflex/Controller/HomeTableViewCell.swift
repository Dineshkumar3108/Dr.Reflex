//
//  HomeTableViewCell.swift
//  Dr.Reflex
//
//  Created by priyanka gayathri on 01/09/20.
//  Copyright © 2020 priyanka. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

   
    @IBOutlet weak var lblDomain: UILabel!
    @IBOutlet weak var domainImages: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
