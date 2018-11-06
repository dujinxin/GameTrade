//
//  LabelCell.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/29.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class LabelCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.nameLabel.textColor = JXText50Color
        self.infoLabel.textColor = JXTextColor
        self.lineView.backgroundColor = JXSeparatorColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
