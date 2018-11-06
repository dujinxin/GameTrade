//
//  PaperListCell.swift
//  Star
//
//  Created by 杜进新 on 2018/7/26.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class PaperListCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var authorView: UILabel!
    @IBOutlet weak var periodicalView: UILabel!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var downloadView: UILabel!
    
    var entity: PaperEntity? {
        didSet{
            self.titleView.text = entity?.title
            
            //self.authorView.text = entity?.author
            self.periodicalView.text = entity?.source
            self.dateView.text = entity?.issue
            self.downloadView.text = "交易：\(entity?.tradeCount ?? 0)"
            
            var source = ""
            if let source1 = entity?.source, source1.isEmpty == false {
                source = source1
            }
            
            if let author1 = entity?.author {
                let author = author1.replacingOccurrences(of: ",", with: ";")
                let authors = author.components(separatedBy: ";")
                if authors.count > 5 {
                    var newStr = ""
                    for i in 0..<5 {
                        newStr += authors[i]
                        newStr += ";"
                    }
                    self.authorView.text = newStr + source
                } else {
                    self.authorView.text = author + ";" + source
                }
            }
        }
    }
    var indexPath : IndexPath? {
        didSet{
            if (indexPath?.row)! % 2 == 0 {
                self.backView.backgroundColor = UIColor.rgbColor(from: 250, 250, 250)
            } else {
                self.backView.backgroundColor = UIColor.rgbColor(from: 241, 242, 247)
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
