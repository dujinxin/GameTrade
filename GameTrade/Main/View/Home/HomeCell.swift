//
//  HomeCell.swift
//  Star
//
//  Created by 杜进新 on 2018/7/11.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {


    @IBOutlet weak var subContentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var indexPath : IndexPath? {
        didSet{
//            self.indexButton.setTitle("\((indexPath?.row ?? 0) + 1)", for: .normal)
            if (indexPath?.item)! % 2 == 0 {
                self.subContentView.backgroundColor = UIColor.rgbColor(from: 250, 250, 250)
            } else {
                self.subContentView.backgroundColor = UIColor.rgbColor(from: 241, 242, 247)
            }
//            if indexPath?.item == 0 {
//                self.indexButton.setBackgroundImage(UIImage(named: "indexImg1"), for: .normal)
//
//            } else if indexPath?.item == 1 {
//                self.indexButton.setBackgroundImage(UIImage(named: "indexImg2"), for: .normal)
//
//            } else if indexPath?.item == 2 {
//                self.indexButton.setBackgroundImage(UIImage(named: "indexImg3"), for: .normal)
//
//            } else {
//                self.indexButton.setBackgroundImage(UIImage(), for: .normal)
//
//            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

}
