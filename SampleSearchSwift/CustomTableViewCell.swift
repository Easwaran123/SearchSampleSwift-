//
//  CustomTableViewCell.swift
//  SampleSearchSwift
//
//  Created by v-20 on 7/19/17.
//  Copyright © 2017 VividInfotech. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblBody: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

           }

}
