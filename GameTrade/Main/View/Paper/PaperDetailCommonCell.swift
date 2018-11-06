//
//  PaperDetailCommonCell.swift
//  Star
//
//  Created by 杜进新 on 2018/7/26.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class PaperDetailCommonCell: UITableViewCell {

    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var entity : CustomDetailEntity? {
        didSet{
            self.titleView.text = entity?.title
            
            if entity?.title == "【摘要】" {
                
                let data = entity?.content?.data(using: .unicode)
                let attributeStr = try? NSMutableAttributedString.init(data: data!, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
                
                let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgbColor(rgbValue: 0x3b4368)]
                //entity?.content?.count > attributeStr?.length
                if let length = attributeStr?.length, length != 0 {
                    attributeStr?.addAttributes(attributes, range: NSRange.init(location: 0, length: length))
                }
                self.contentLabel.attributedText = attributeStr
            
            } else {
                self.contentLabel.text = entity?.content
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
