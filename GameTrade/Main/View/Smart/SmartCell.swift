//
//  SmartCell.swift
//  Star
//
//  Created by 杜进新 on 2018/7/27.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class SmartCell: UITableViewCell {

    @IBOutlet weak var SmartImageView: UIImageView!
    
    var indexPath: IndexPath? {
        didSet{
            if indexPath?.row == 0 {
                self.SmartImageView.image = #imageLiteral(resourceName: "articleBackground")
            } else {
                self.SmartImageView.image = #imageLiteral(resourceName: "paperBackground")
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
