//
//  CommentCell.swift
//  Star
//
//  Created by 杜进新 on 2018/5/30.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteButtonHeightConstraint: NSLayoutConstraint!
    
    var deleteBlock : (()->())?
    
    
    var entity: CommentListEntity? {
        didSet {
            self.nickNameLabel.text = entity?.user?.nickname
            self.contentLabel.text = entity?.commentRepl
            
            if let str = entity?.user?.avatar,let url = URL(string: str) {
                self.userImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "portrait_default"), options: [], completed: nil)
            } else {
                self.userImageView.image = UIImage(named: "portrait_default")
            }
            //置顶
            if entity?.topStatus == 2 {
                self.statusLabel.isHidden = false
            } else {
                self.statusLabel.isHidden = true
            }
            //作者
            if entity?.isAuthor == 1 {
                self.actorLabel.isHidden = false
            } else {
                self.actorLabel.isHidden = true
            }
            //我、删除按钮
            if entity?.isMine == 1 {
                self.deleteButton.isHidden = false
                self.deleteButtonHeightConstraint.constant = 30
            } else {
                self.deleteButton.isHidden = true
                self.deleteButtonHeightConstraint.constant = 0
            }
            
        }
    }
    
    @IBAction func deleteComment(_ sender: Any) {
        if let block = deleteBlock {
            block()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.userImageView.layer.cornerRadius = 20
        self.userImageView.layer.masksToBounds = true
        self.userImageView.clipsToBounds = true
        
        self.actorLabel.textColor = UIColor.rgbColor(from: 24, 109, 182)
        self.actorLabel.layer.borderColor = UIColor.rgbColor(from: 24, 109, 182).cgColor
        self.actorLabel.layer.borderWidth = 1
        
        self.statusLabel.textColor = UIColor.rgbColor(from: 247, 147, 26)
        self.statusLabel.layer.borderColor = UIColor.rgbColor(from: 247, 147, 26).cgColor
        self.statusLabel.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
