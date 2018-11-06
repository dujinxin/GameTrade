//
//  MyCell.swift
//  Star
//
//  Created by 杜进新 on 2018/7/10.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var modifyBlock : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.topConstraint.constant = kNavStatusHeight
        
        backView.layer.shadowOffset = CGSize(width: 0, height: 10)
        backView.layer.shadowColor = JX10101aShadowColor.cgColor
        backView.layer.shadowOpacity = 1
        backView.layer.shadowRadius = 40
        
        self.userImageView.backgroundColor = JXOrangeColor
        self.userImageView.layer.cornerRadius = 34
        self.userImageView.layer.masksToBounds = true
        self.userImageView.clipsToBounds = true
        
        self.userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(modifyImage)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func modifyImage() {
        if let block = modifyBlock {
            block()
        }
    }
}
