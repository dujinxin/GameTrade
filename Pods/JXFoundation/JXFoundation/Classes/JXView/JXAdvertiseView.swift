//
//  JXAdvertiseView.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/7/13.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

let rightMargin : CGFloat = 20
let buttonWidth : CGFloat = 40

public class JXAdvertiseView: UIView {
    
    public var timeInterval : Int = 5
    //MARK: properties
    public lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        //iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    public lazy var enterButton: UIButton = {
        let button = UIButton()
        button.setTitle( "\(self.timeInterval)", for: .normal)
        button.frame = CGRect(origin: CGPoint(), size: CGSize(width: 40, height: 40))
        //button.sizeToFit()
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(touchDismiss), for: .touchUpInside)
        button.layer.cornerRadius = buttonWidth / 2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    var adTimer : Timer?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(self.imageView)
        addSubview(self.enterButton)
        
        
        if #available(iOS 10.0, *) {
            self.adTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                self.autoChangeNumber(timer: timer)
            }
        } else {
            self.adTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(autoChangeNumber(timer:)), userInfo: self.adTimer, repeats: true)
        }
    }
    deinit {
        
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = bounds
        self.enterButton.frame = CGRect(x: kScreenWidth - buttonWidth - rightMargin, y: kStatusBarHeight, width: buttonWidth, height: buttonWidth)
    }

    //MARK: methods
    @objc func autoChangeNumber(timer:Timer) {
        if
            let numberStr = self.enterButton.currentTitle,
            var number = Int(numberStr),
            number > 1
        {
            number -= 1
            self.enterButton.setTitle("\(number)", for: .normal)
        }else{
            self.touchDismiss()
        }
    }
    
    @objc func touchDismiss() {
        
        self.adTimer?.invalidate()
        /// animate 放大动画，消失
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 0.0
            self.transform = CGAffineTransform(scaleX: 2, y: 2)
            
        }) { (finished) in
            self.removeAllSubView()
            self.removeFromSuperview()
        }
    }
}
