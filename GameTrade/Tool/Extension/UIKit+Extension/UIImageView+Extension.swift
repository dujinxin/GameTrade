
//
//  UIImageView+Extension.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/7/18.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func jx_setImage(obj: Any?) {
        guard let obj = obj else {
            return
        }
        if obj is UIImage {
            self.image = obj as? UIImage
        }
        
        if obj is String {
            let objStr = obj as! String
            if objStr.isEmpty == true {
                return
            }
            if objStr.hasPrefix("http") {
                jx_setImage(with: objStr, placeholderImage: nil)
            }else{
                self.image = UIImage(named: objStr)
            }
        }
    }
    
    func jx_setImage(with urlStr:String, placeholderImage: UIImage?,isRound:Bool = false){
        
        guard let url = URL(string: urlStr) else {
            self.image = placeholderImage
            return
        }
        self.sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) { (image, error, _, url) in
            if
                let image = image,
                isRound == true{
                
                //self.image.
            }
        }
    }
    
}
