//
//  ImageTitleCell.swift
//  Star
//
//  Created by 杜进新 on 2018/7/10.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ImageTitleCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleView: UILabel!{
        didSet{
            titleView.textColor = JXMainTextColor
        }
    }
    @IBOutlet weak var detailView: UILabel!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!{
        didSet{
            trailingConstraint.constant = -34
        }
    }
    @IBOutlet weak var separatorView: UIView!{
        didSet{
            separatorView.backgroundColor = JXSeparatorColor
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.accessoryView?.tintColor = JXMainTextColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
