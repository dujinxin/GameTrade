//
//  PasswordTextView.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/26.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class PasswordTextView: JXSecretTextView {
    
    var bottomLineColor : UIColor = JXSeparatorColor
    var bottomLineHeight : CGFloat = 4
    var bottomLineWidth : Float = 32
    var bottomLineSpace : Float = 12
    

//    override func textChange(textField: UITextField) {
//        var num = 0
//        if let txt = textField.text {
//            num = txt.count
//            self.text = txt
//
//            if num > limit {
//                textField.resignFirstResponder()
//            }
//        }
//        print(self.text)
//        if let block = passwordBlock {
//            block(self.text)
//        }
//        self.setNeedsDisplay()
//        if let block = completionBlock {
//            block(self.text, num == limit)
//        }
//    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //画背景图
        let field = UIImage.imageWithColor(UIColor.clear)
        field.draw(in: CGRect(origin: CGPoint(), size: self.frame.size))
        
        //画圆点
        let w : CGFloat = 30
        let h : CGFloat = 44
        var x : CGFloat = 0
        let y = (frame.size.height - h) / 2
        let margin : CGFloat = 0
        let padding = (frame.size.width / CGFloat(self.limit) - w) / 2
        //guard let string = self.textField.text else { return }
        
        for i in 0..<self.text.count {
            x = margin + padding + CGFloat(i) * (w + 2 * padding)
            let point = UIImage(named: "yuan")
            //point?.draw(in: CGRect(x: x, y: y, width: w, height: h))
            
            //密文输入
            let subStr : NSString = "＊"
            //明文输入
//            let index1 = self.text.index(self.text.startIndex, offsetBy: i)
//            let index2 = self.text.index(self.text.startIndex, offsetBy: i + 1)
//            let sub = self.text[index1..<index2]
//            let subStr = String(sub) as NSString
            let para = NSMutableParagraphStyle()
            para.alignment = NSTextAlignment.center
            para.minimumLineHeight = 0
            
            subStr.draw(in: CGRect(x: x, y: y, width: w, height: h), withAttributes: [NSAttributedStringKey.font: self.font,NSAttributedStringKey.foregroundColor:self.textColor,NSAttributedStringKey.paragraphStyle:para])
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)

        let rect = CGRect(x: 0, y: frame.size.height - self.bottomLineHeight, width: frame.size.width , height: self.bottomLineHeight)
        let shapeLayer = self.drawDashLine(rect: rect, lineWidth: self.bottomLineHeight, lineLength: self.bottomLineWidth, lineSpace: self.bottomLineSpace, lineColor: self.bottomLineColor)
        layer.addSublayer(shapeLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let rect = CGRect(x: 0, y: frame.size.height - self.bottomLineHeight, width: frame.size.width , height: self.bottomLineHeight)
        let shapeLayer = self.drawDashLine(rect: rect, lineWidth: self.bottomLineHeight, lineLength: self.bottomLineWidth, lineSpace: self.bottomLineSpace, lineColor: self.bottomLineColor)
        layer.addSublayer(shapeLayer)
    }
    
    func drawDashLine(rect: CGRect, lineWidth: CGFloat, lineLength: Float, lineSpace: Float, lineColor :UIColor) -> CAShapeLayer{
        let shapeLayer = CAShapeLayer()
    
        shapeLayer.frame = rect
        shapeLayer.position = CGPoint(x: 0, y: frame.size.height - lineWidth)
        //只要是CALayer这种类型,他的anchorPoint默认都是(0.5,0.5)
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = kCALineJoinRound
        
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength),NSNumber(value: lineSpace)]
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: CGFloat(lineSpace / 2), y: lineWidth / 2))
        path.addLine(to: CGPoint(x: rect.size.width, y: lineWidth / 2))
        shapeLayer.path = path
        
        return shapeLayer
    }
}
class LineView: UIView {
    override func draw(_ rect: CGRect) {
//        let context = UIGraphicsGetCurrentContext()
//        context?.setStrokeColor(UIColor.rgbColor(rgbValue: 0x464855).cgColor)
//        context?.setLineWidth(4)
//        context?.move(to: CGPoint())
//        context?.addLine(to: CGPoint(x: 0, y: self.frame.size.width))
//        context?.setLineDash(phase: 4, lengths: [8,4])
//
//        context?.drawPath(using: CGPathDrawingMode.stroke)
    }
    
    
}
