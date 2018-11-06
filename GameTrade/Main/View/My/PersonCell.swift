//
//  PersonCell.swift
//  Star
//
//  Created by 杜进新 on 2018/7/11.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var indexPath : IndexPath? {
        didSet{
            if (indexPath?.row)! % 2 == 0 {
                self.contentView.backgroundColor = UIColor.rgbColor(from: 250, 250, 250)
            } else {
                self.contentView.backgroundColor = UIColor.rgbColor(from: 241, 242, 247)
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
