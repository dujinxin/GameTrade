//
//  SellTextFieldCell.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/27.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class SellTextFieldCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.nameLabel.textColor = JXMainText50Color
        self.textField.textColor = JXMainTextColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
