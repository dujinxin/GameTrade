//
//  JXAlertView.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/25.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit

enum JXAlertViewStyle : Int {
    case plain
    case list
    case custom
}
enum JXAlertViewShowPosition {
    case middle
    case bottom
}

private let reuseIdentifier = "reuseIdentifier"

private let topBarHeight : CGFloat = 40
private let alertViewMargin : CGFloat = kScreenWidth * 0.1
private let alertViewWidth : CGFloat = UIScreen.main.bounds.width - 2 * alertViewMargin
private let listHeight : CGFloat = 40
private let cancelViewHeight : CGFloat = 40
private let animateDuration : TimeInterval = 0.3

class JXAlertView: UIView {

    private var alertViewHeight : CGFloat = 0
    private var alertViewTopHeight : CGFloat = 0
    
    var title : String?
    var message : String?
    var actions : Array<String> = [String](){
        didSet{
            if actions.count > 5 {
                self.tableView.isScrollEnabled = true
                self.tableView.bounces = true
                self.tableView.showsVerticalScrollIndicator = true
            }else{
                self.tableView.isScrollEnabled = false
                self.tableView.bounces = false
                self.tableView.showsVerticalScrollIndicator = false
            }
            //self.resetFrame(height: CGFloat(actions.count) * listHeight)
            self.resetFrame()
        }
    }
    
    var delegate : JXAlertViewDelegate?
    var style : JXAlertViewStyle = .plain
    var position : JXAlertViewShowPosition = .middle {
        didSet{
            self.resetFrame()
        }
    }
    var selectRow : Int = -1
    var contentHeight : CGFloat {
        set{//可以自己指定值带来替默认值eg: （myValue）
            var h : CGFloat = 0
            if newValue > 0 {
                h = newValue
                alertViewHeight = newValue
            }else{
                if style == .list{
                    let num : CGFloat = CGFloat(self.actions.count)
                    h = (num > 5 ? 5.5 : num) * listHeight
                    alertViewHeight = h
                }
            }
            if isUseTopBar {
                h += topBarHeight
            }
            self.frame = CGRect(x: alertViewMargin, y: 0, width: alertViewWidth, height: alertViewHeight + topBarHeight + cancelViewHeight + 10)
        }
        get{
            return self.frame.height
        }
    }
    
    var isScrollEnabled : Bool = false {
        didSet{
            if isScrollEnabled == true {
                self.tableView.isScrollEnabled = true
                self.tableView.bounces = true
                self.tableView.showsVerticalScrollIndicator = true
            }else{
                self.tableView.isScrollEnabled = false
                self.tableView.bounces = false
                self.tableView.showsVerticalScrollIndicator = false
            }
        }
    }
    
    var isUseTopBar : Bool = false {
        didSet{
            if isUseTopBar {
                alertViewTopHeight = topBarHeight
                if (self.topBarView.superview == nil){
                    self.addSubview(self.topBarView)
                }
            }else{
                alertViewTopHeight = 0
                if (self.topBarView.superview != nil){
                    self.topBarView.removeFromSuperview()
                }
            }
            self.resetFrame()
        }
    }
    var isSetCancelView : Bool = false {
        didSet{
            if isSetCancelView {
                
                self.addSubview(self.cancelButton)
                self.resetFrame()
            }
        }
    }
    private var contentView : UIView?
    var customView: UIView? {
        didSet{
            self.contentView = customView
        }
    }
    var topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    lazy var tableView : UITableView = {
        let table = UITableView.init(frame: CGRect.init(), style: .plain)
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false
        table.bounces = false
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.separatorStyle = .none
        table.register(listViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        return table
    }()
    lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.white
        btn.setTitle("取消", for: UIControlState.normal)
        btn.setTitleColor(JX333333Color, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(tapClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    lazy private var bgWindow : UIWindow = {
        let window = UIWindow()
        window.frame = UIScreen.main.bounds
        window.windowLevel = UIWindowLevelAlert + 1
        window.backgroundColor = UIColor.clear
        window.isHidden = false
        return window
    }()
    
    lazy private var bgView : UIView = {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = UIColor.black
        view.alpha = 0
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    
    init(frame: CGRect, style:JXAlertViewStyle) {
        super.init(frame: frame)
        //self.rect = frame
        //self.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 15.0
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.style = style
        
        if style == .list {
            self.contentView = self.tableView
        }else if style == .custom{
            
        }else{
            
        }
        alertViewHeight = frame.height
        self.resetFrame()
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func resetFrame(height:CGFloat = 0.0) {
        var h : CGFloat = 0
        if height > 0 {
            h = height
            alertViewHeight = height
        }else{
            if style == .list{
                let num : CGFloat = CGFloat(self.actions.count)
                h = (num > 5 ? 5.5 : num) * listHeight
                alertViewHeight = h
            }
        }
        if isUseTopBar {
            h += topBarHeight
        }
        if isSetCancelView {
            h += cancelViewHeight + 10
        }
        //如果为iPhoneX，则把底部的34空间让出来
//        if deviceModel == .iPhoneX {
//            h += 34
//        }
        self.frame = CGRect.init(x: (UIScreen.main.bounds.width - alertViewWidth)/2, y: 0, width: alertViewWidth, height:h)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isUseTopBar {
            topBarView.frame = CGRect.init(x: 0, y: 0, width: alertViewWidth, height: alertViewTopHeight)
            
            //confirmButton.frame = CGRect.init(x: rect.width - 60, y: 0, width: 60, height: topBarHeight)
        }
        
        self.contentView?.frame = CGRect.init(x: 0, y: alertViewTopHeight, width: alertViewWidth, height: alertViewHeight)
        if isSetCancelView {
            cancelButton.frame = CGRect.init(x: 0, y: alertViewTopHeight + alertViewHeight + 10, width: alertViewWidth, height: cancelViewHeight)
        } 
    }
    
    func show(){
        self.show(inView: self.bgWindow)
    }
    
    func show(inView view:UIView? ,animate:Bool = true) {
        
        self.addSubview(self.contentView!)
        self.resetFrame(height: alertViewHeight)
        
        let superView : UIView
        
        if let v = view {
            superView = v
        }else{
            superView = self.bgWindow
        }
        //let center = CGPoint.init(x: contentView.center.x, y: contentView.center.y - 64 / 2)
        let center = superView.center
        
        if position == .bottom {
            var frame = self.frame
            frame.origin.y = superView.frame.height
            self.frame = frame
        }else{
            self.center = center
        }
        
        superView.addSubview(self.bgView)
        superView.addSubview(self)
        superView.isHidden = false
        
        if animate {
            UIView.animate(withDuration: animateDuration, delay: 0.0, options: .curveEaseIn, animations: {
                self.bgView.alpha = 0.5
                if self.position == .bottom {
                    var frame = self.frame
                    frame.origin.y = superView.frame.height - self.frame.height
                    self.frame = frame
                }else{
                    self.center = center
                }
            }, completion: { (finished) in
                if self.style == .list {
                    self.tableView.reloadData()
                }else if self.style == .plain {

                }
            })
        }
    }
    func dismiss(animate:Bool = true) {
        
        if animate {
            UIView.animate(withDuration: animateDuration, delay: 0.0, options: .curveEaseOut, animations: {
                self.bgView.alpha = 0.0
                if self.position == .bottom {
                    var frame = self.frame
                    frame.origin.y = self.superview!.frame.height
                    self.frame = frame
                }else{
                    self.center = self.superview!.center
                }
            }, completion: { (finished) in
                self.clearInfo()
            })
        }else{
            self.clearInfo()
        }
    }
    
    fileprivate func clearInfo() {
        bgView.removeFromSuperview()
        self.removeFromSuperview()
        bgWindow.isHidden = true
        
    }
    @objc private func tapClick() {
        self.dismiss()
    }
    fileprivate func viewDisAppear(row:Int) {
//        if self.delegate != nil && selectRow >= 0{
//            self.delegate?.jxSelectView(self, didSelectRowAt: row)
//        }
        self.dismiss()
    }
}
extension JXAlertView : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (actions.isEmpty == false) {
            return actions.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! listViewCell
        
        if actions.isEmpty == false {
            cell.titleLabel.text = actions[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        if isUseTopBar {
//            selectRow = indexPath.row
//        }else{
//            self.viewDisAppear(row: indexPath.row)
//        }
        
        
        //self.delegate?.willPresentJXAlertView!(self)
        self.delegate?.jxAlertView(self, clickButtonAtIndex: indexPath.row)
        self.dismiss()
        //self.delegate?.didPresentJXAlertView!(self)
       
    }
}

class listViewCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = JX333333Color
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.separatorView)
        self.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.separatorView.frame = CGRect.init(x: 0, y: self.bounds.height - 0.5, width: self.bounds.width, height: 0.5)
    }
}

@objc protocol JXAlertViewDelegate {
    
    func jxAlertView(_ alertView :JXAlertView, clickButtonAtIndex index:Int)
    @objc optional func jxAlertViewCancel(_ :JXAlertView)
    @objc optional func willPresentJXAlertView(_ :JXAlertView)
    @objc optional func didPresentJXAlertView(_ :JXAlertView)
    
}
