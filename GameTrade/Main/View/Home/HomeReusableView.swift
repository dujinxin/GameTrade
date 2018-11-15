//
//  HomeReusableView.swift
//  Star
//
//  Created by 杜进新 on 2018/7/11.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import AVFoundation

class HomeReusableView: UICollectionReusableView {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var totalNumLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var useNumLabel: UILabel!
    @IBOutlet weak var usePriceLabel: UILabel!
    
    @IBOutlet weak var limitNumLabel: UILabel!
    @IBOutlet weak var limitPriceLabel: UILabel!
    
    @IBOutlet weak var noticeLabel: UILabel!
    
    
    @IBOutlet weak var itemContentView: UIView!

    @IBOutlet weak var scanIconBackView: UIView!
    @IBOutlet weak var scanIconButton: UIButton!
    @IBOutlet weak var scanArrow: UIButton!
    
    
    @IBOutlet weak var switchContentView: UIView!

    @IBOutlet weak var infoContentView: UIView!
    
    
    var additionBlock : (()->())?
    var noticeBlock : (()->())?
    var scanBlock : (()->())?
    
    var entity : PropertyEntity? {
        didSet{
            self.totalNumLabel.text = "\(entity?.totalCounts ?? 0)"
            self.useNumLabel.text = "\(entity?.balance ?? 0)"
            self.limitNumLabel.text = "\(entity?.blockedBalance ?? 0)"
            
            self.totalPriceLabel.text = "=\((entity?.totalCounts ?? 0) * configuration_coinPrice)\(configuration_valueType)"
            self.usePriceLabel.text = "=\((entity?.balance ?? 0) * configuration_coinPrice)\(configuration_valueType)"
            self.limitPriceLabel.text = "=\((entity?.blockedBalance ?? 0) * configuration_coinPrice)\(configuration_valueType)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.topConstraint.constant = kStatusBarHeight + 7
        
        self.rightButton.backgroundColor = UIColor.clear
        
        
        self.infoContentView.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.infoContentView.layer.shadowOpacity = 1
        self.infoContentView.layer.shadowRadius = 40
        self.infoContentView.layer.shadowColor = UIColor.rgbColor(rgbValue: 0x10101a, alpha: 0.5).cgColor
        self.infoContentView.layer.cornerRadius = 4
        
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0xff4465).cgColor,UIColor.rgbColor(rgbValue: 0xF6CA1D).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        gradientLayer.cornerRadius = 5
        
        self.scanIconBackView.layer.insertSublayer(gradientLayer, at: 0)
        
        self.scanIconButton.tintColor = UIColor.black
        self.scanIconButton.setImage(UIImage(named: "scanIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        
        self.switchContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(noticeTap(tap:))))
        self.infoContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scanTap(tap:))))
        
    }

    @IBAction func addition(_ sender: Any) {
        if let block = self.additionBlock {
            block()
        }
    }
    @objc func noticeTap(tap: UITapGestureRecognizer) {
        if let block = self.noticeBlock {
            block()
        }
    }
    @objc func scanTap(tap: UITapGestureRecognizer) {
        if let block = self.scanBlock {
            block()
        }
    }

    func tapClick(subView:UIView) {
        
    }
}
class DiamondView: UIView {
    lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }()
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "imgDiamond")
        iv.isUserInteractionEnabled = true
        return iv
    }()
    lazy var titleView: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()

    var tapBlock : ((_ view:DiamondView)->())?
    
    var entity: DiamondEntity? {
        didSet{
            self.titleView.text = entity?.diamondNumber
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(self.contentView)
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleView)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageHeight : CGFloat = 52 * 167 / 156
        let labelHeight : CGFloat = 20
        //水晶+数字 宽高
        //let crystalViewWidth : CGFloat = 52
        //let crystalViewHeight = imageHeight + 20

        contentView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: imageHeight)
        titleView.frame = CGRect(x: 0, y: imageHeight, width: frame.width, height: labelHeight)
    }
    @objc func tap(tap:UITapGestureRecognizer) {
        if let block = tapBlock {
            block(self)
        }
    }
    
    func beginAnimate(time:CFTimeInterval = 0) {
        
        let v = self.contentView
        

        let animation = CAKeyframeAnimation.init(keyPath: "position")
        let path = CGMutablePath.init()
        
        path.move(to: CGPoint(x: v.center.x, y: v.center.y))//设置起始点
        path.addLine(to: CGPoint(x: v.center.x, y: v.center.y + 5))//终点
        path.addLine(to: CGPoint(x: v.center.x, y: v.center.y))//终点
        path.addLine(to: CGPoint(x: v.center.x, y: v.center.y - 5))//终点
        path.addLine(to: CGPoint(x: v.center.x, y: v.center.y))//终点
        
        animation.path = path
        
        animation.isRemovedOnCompletion = false
        animation.repeatCount =  Float.greatestFiniteMagnitude
        //animation.repeatDuration = 3
        animation.beginTime = time
        animation.duration = 5
        animation.autoreverses = false
        animation.fillMode = kCAFillModeForwards
        animation.calculationMode = kCAAnimationPaced
        
        v.layer.add(animation, forKey: nil)
    }
}
