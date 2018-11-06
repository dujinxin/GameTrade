//
//  JXTopBarView.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/22.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit

class JXTopBarView: UIView {
    var rect = CGRect()
    
    var titles : Array<String> = []{
        didSet {
            setItemsInfo(titles: titles)
        }
    }
    var delegate : JXTopBarViewDelegate?
    var selectedIndex = 0
    var attribute = TopBarAttribute.init()
    
    var isBottomLineEnabled : Bool = false{
        didSet{
            if isBottomLineEnabled {
                for v in subviews {
                    if v is UIButton && v.tag == self.selectedIndex{
                        addSubview(self.bottomLineView)
                        self.bottomLineView.frame = CGRect(x: CGFloat(self.selectedIndex) * v.jxWidth, y: v.jxBottom - 1, width: v.jxWidth, height: 1)
                    }
                }
            }
        }
    }
    lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgbColor(rgbValue: 0xf64a07)
        return view
    }()
    
    

//    override func draw(_ rect: CGRect) {
//        // Drawing code
//        let context = UIGraphicsGetCurrentContext()
//        context?.setLineCap(CGLineCap.round)
//        context?.setLineWidth(1)
//        context?.setAllowsAntialiasing(true)
//        context?.setStrokeColor(JXSeparatorColor.cgColor)
//        context?.beginPath()
//        
//        if titles.count > 0 {
//            
//        }
//    }
    
    init(frame: CGRect,titles:Array<String>) {
        
        selectedIndex = 0
        isBottomLineEnabled = false
        
        super.init(frame: frame)
        self.rect = frame
        self.titles = titles
        backgroundColor = UIColor.white
        
        let width = frame.size.width / CGFloat(titles.count)
        let height = frame.size.height
        
        
        for i in 0..<titles.count {
            let title = titles[i]
            
            let button = UIButton()
            button.frame = CGRect.init(x: (width * CGFloat(i)), y: 0, width: width, height: height)
            
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.setTitleColor(attribute.normalColor, for: UIControlState.normal)
            button.setTitleColor(attribute.highlightedColor, for: UIControlState.selected)
            button.tag = i
            
            button.addTarget(self, action: #selector(tabButtonAction(button:)), for: UIControlEvents.touchUpInside)
            
            addSubview(button)
            
            if i == 0 {
                button.isSelected = true
                let attributeString = NSMutableAttributedString.init(string: title)
                attributeString.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor:attribute.highlightedColor], range: NSRange.init(location: 0, length: 3))
                attributeString.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor:attribute.highlightedColor], range: NSRange.init(location: 3, length: title.count - 3))
                
                button.setAttributedTitle(attributeString, for: .selected)
                
                
                let attributeString1 = NSMutableAttributedString.init(string: title)
                attributeString1.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor:attribute.normalColor], range: NSRange.init(location: 0, length: 3))
                attributeString1.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor:attribute.normalColor], range: NSRange.init(location: 3, length: title.count - 3))
                
                button.setAttributedTitle(attributeString1, for: .normal)
                
                //NotificationCenter.default.addObserver(self, selector: #selector(firstTabItemTitleChanged), name: NSNotification.Name(rawValue: NotificationMainDeliveringNumber), object: nil)
            }else{
                button.setTitle(title, for: UIControlState.normal)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tabButtonAction(button : UIButton) {
        print(button.tag)
        
        selectedIndex = button.tag
        button.isSelected = true
        

        UIView.animate(withDuration: 0.3, animations: { 
            self.bottomLineView.frame = CGRect(x: CGFloat(self.selectedIndex) * button.jxWidth, y: button.jxBottom - 1, width: button.jxWidth, height: 1)
        }) { (finished) in
            //
        }
        
        subviews.forEach { (v : UIView) -> () in
            
            if (v is UIButton){
    
                if (v.tag != button.tag){
                    let btn = v as! UIButton
                    btn.isSelected = false
                }
            }
        }
        
        if self.delegate != nil {
            self.delegate?.jxTopBarView(topBarView: self, didSelectTabAt: button.tag)
        }
    }
    func setItemsInfo(titles:Array<String>) {

        if titles.isEmpty == true {
            return
        }
        let title = titles[0]
        
        subviews.forEach { (v : UIView) -> () in
            
            if (v is UIButton){
                let button = v as! UIButton
                if button.tag == 0 {
                
                    let attributeString = NSMutableAttributedString.init(string: title)
                    attributeString.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor:attribute.highlightedColor], range: NSRange.init(location: 0, length: 3))
                    attributeString.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor:attribute.highlightedColor], range: NSRange.init(location: 3, length: title.count - 3))
                    
                    button.setAttributedTitle(attributeString, for: .selected)
                    
                    
                    let attributeString1 = NSMutableAttributedString.init(string: title)
                    attributeString1.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor:attribute.normalColor], range: NSRange.init(location: 0, length: 3))
                    attributeString1.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor:attribute.normalColor], range: NSRange.init(location: 3, length: title.count - 3))
                    
                    button.setAttributedTitle(attributeString1, for: .normal)
                }
            }
        }
  
    }
//    func setButtonTitle(button : UIButton, attributeTitle:String,isSelected:Bool = true) {
//        
//        let attributeString = NSMutableAttributedString.init(string: attributeTitle)
//        attributeString.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName:attribute.highlightedColor], range: NSRange.init(location: 0, length: 3))
//        attributeString.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 10),NSForegroundColorAttributeName:attribute.highlightedColor], range: NSRange.init(location: 3, length: attributeTitle.characters.count - 3))
//        
//        button.setAttributedTitle(attributeString, for: .normal)
//    }
//    
//    func firstTabItemTitleChanged(notif:Notification) {
//        if let num = notif.object as? Int {
//            titles[0] = String.init(format: "未发货(%@)", num)
//        }
//    }

}

extension JXTopBarView{
    
}

protocol JXTopBarViewDelegate {
    
    func jxTopBarView(topBarView : JXTopBarView,didSelectTabAt index:Int) -> Void
}

class TopBarAttribute: NSObject {
    var normalColor = UIColor.darkGray
    var highlightedColor = UIColor.rgbColor(rgbValue: 0xf64a07)
    var separatorColor = JXSeparatorColor
    
    
    
    override init() {
        normalColor = UIColor.darkGray
        highlightedColor = UIColor.rgbColor(rgbValue: 0xf64a07)
        separatorColor = JXSeparatorColor
    }
}
        
