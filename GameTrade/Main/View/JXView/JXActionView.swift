//
//  JXActionView.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/12/22.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit
import JXFoundation

public enum JXActionViewStyle : Int {
    case plain
    case list
    case custom
}

private let reuseIdentifier = "reuseIdentifier"

private let topBarHeight : CGFloat = 44
private let actionViewMargin : CGFloat = 0
private let actionViewWidth : CGFloat = UIScreen.main.bounds.width - 2 * actionViewMargin
private let listHeight : CGFloat = 44
private let bottomViewHeight : CGFloat = kBottomMaginHeight + 44 //(iPhoneX 底部 多出34)
private let animateDuration : TimeInterval = 0.3



public class JXActionView: UIView {
    
    var alertViewTopHeight : CGFloat = 0
    var alertViewHeight : CGFloat = 0
    

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
            //self.resetFrame()
        }
    }
    
    var delegate : JXActionViewDelegate?
    var dataSource : JXActionViewDataSource?
    var style : JXActionViewStyle = .plain

    var selectRow : Int = -1
    var isCustomCell: Bool = false{
        didSet{
            if isCustomCell {
                
            }
        }
    }
    private var customCellName : String?
    
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

    var isUseBottomView : Bool = false {
        didSet{
            if isUseBottomView {
                addSubview(self.bottomBarView)
            }
        }
    }
    private var contentView : UIView?
    var customView: UIView? {
        didSet{
            self.contentView = customView
        }
    }
    var topBarView: UIView? {
        didSet{
            if let v = topBarView {
                alertViewTopHeight = v.bounds.height
                addSubview(v)
            }
        }
    }
    lazy var bottomBarView: BottomBarView = {
        let view = BottomBarView()
        view.backgroundColor = UIColor.white
        
        view.cancelBlock = {
            self.tapClick()
        }
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
        
        return table
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
    
    
    public init(frame: CGRect, style:JXActionViewStyle) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.style = style
        
        if style == .list {
            self.tableView.register(ActionlistViewCell.self, forCellReuseIdentifier: reuseIdentifier)
            self.contentView = self.tableView
        } else if style == .custom{
            
        } else{
            
        }
        alertViewHeight = frame.height
    }
    /// 自定义list cell
    ///
    /// - Parameters:
    ///   - name: cell class name
    ///   - isNib: 是否来至Nib
    public init(tableViewCell name: String, isNib: Bool = false) {
        super.init(frame: CGRect())
        
        self.backgroundColor = UIColor.white
        self.style = .list
        self.customCellName = name
        if isNib {
            self.tableView.register(UINib.init(nibName: name, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        } else {
            if let listCellClass = NSClassFromString(Bundle.main.bundleName + "." + name) as? UITableViewCell.Type {
                self.tableView.register(listCellClass.self, forCellReuseIdentifier: reuseIdentifier)
            }
        }
        
        self.contentView = self.tableView
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setContentView() {
        
        if isUseBottomView {
            addSubview(self.bottomBarView)
        }
        if let content = self.contentView {
            addSubview(content)
        }
    }
    func resetFrame(height: CGFloat = 0.0) {
        var h : CGFloat = 0
        if height > 0 {
            h = height
            alertViewHeight = height
        } else {
            if style == .list {
                let num : CGFloat = CGFloat(self.actions.count)
                if let ds = dataSource {
                    h = (num > 5 ? 5.5 : num) * ds.actionView(self, heightForRowAt: 0)
                    alertViewHeight = h
                } else {
                    h = (num > 5 ? 5.5 : num) * listHeight
                    alertViewHeight = h
                }
            }
        }
        
        h += alertViewTopHeight
        
        if isUseBottomView {
            h += bottomViewHeight + 10
        } else {
            h += kBottomMaginHeight
        }
        self.frame = CGRect.init(x: (UIScreen.main.bounds.width - actionViewWidth)/2, y: 0, width: actionViewWidth, height:h)
        
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if let v = topBarView {
            v.frame = CGRect(x: actionViewMargin, y: 0, width: actionViewWidth, height: alertViewTopHeight)
        }
        
        self.contentView?.frame = CGRect(x: actionViewMargin, y: alertViewTopHeight, width: actionViewWidth, height: alertViewHeight)
        if isUseBottomView {
            self.bottomBarView.frame = CGRect(x: actionViewMargin, y: alertViewTopHeight + alertViewHeight + 10, width: actionViewWidth, height: bottomViewHeight)
        }
    }
    
    func show(){
        self.show(inView: self.bgWindow)
    }
    
    func show(inView view:UIView? ,animate:Bool = true) {
        
        self.setContentView()
        self.resetFrame()
       
        let superView : UIView
        
        if let v = view {
            superView = v
        }else{
            superView = self.bgWindow
        }
        var frame = self.frame
        frame.origin.y = superView.frame.height
        self.frame = frame

        
        superView.addSubview(self.bgView)
        superView.addSubview(self)
        superView.isHidden = false
        
        if animate {
            UIView.animate(withDuration: animateDuration, delay: 0.0, options: .curveEaseIn, animations: {
                self.bgView.alpha = 0.5

                var frame = self.frame
                frame.origin.y = superView.frame.height - self.frame.height
                self.frame = frame
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

                var frame = self.frame
                frame.origin.y = self.superview!.frame.height
                self.frame = frame
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
extension JXActionView : UITableViewDelegate,UITableViewDataSource{
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ds = dataSource {
            return ds.numberOfRow(in: self)
        }
        return 0
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let ds = self.dataSource {
            return ds.actionView(self, heightForRowAt: indexPath.row)
        }
        return listHeight
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let _ = self.customCellName, let ds = self.dataSource {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

            return ds.actionView(self, listCell: cell, cellForRowAt: indexPath.row)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionlistViewCell
            if actions.isEmpty == false {
                cell.titleLabel.text = actions[indexPath.row]
            }
            return cell
        }
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //        if isUseTopBar {
        //            selectRow = indexPath.row
        //        }else{
        //            self.viewDisAppear(row: indexPath.row)
        //        }
        
        if let dg = delegate {
            //will present
            if let willPresent = dg.willPresentJXActionView {
                willPresent(self)
            }
            //click
            dg.actionView(self, clickButtonAtIndex: indexPath.row)
    
            //did present
            if let didPresent = dg.didPresentJXActionView {
                didPresent(self)
            }
        } else {
            dismiss()
        }
    }
}

class ActionlistViewCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = JX333333Color
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = JXSeparatorColor
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
class BottomBarView: UIView {

    lazy var cancelItem: UIButton = {
        let button = UIButton()
        button.setTitle("取消", for: .normal)
        button.setTitleColor(JX333333Color, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.isSelected = true
        button.tag = 10
        button.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        return button
    }()
    
    var cancelBlock : (()->())?
    var additionBlock : (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubViews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.cancelItem.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - kBottomMaginHeight)
    }
    func initSubViews() {
        addSubview(self.cancelItem)
    }
    
    @objc func buttonClick(button:UIButton) {
        button.isSelected = !button.isSelected
        
        switch button.tag {
        case 10:
            if let block = cancelBlock {
                block()
            }
        default:
            
            if let block = additionBlock {
                block()
            }
        }
    }
}
@objc public protocol JXActionViewDelegate {
    
    
    @objc func actionView(_ actionView :JXActionView, clickButtonAtIndex index:Int)
    @objc optional func actionViewCancel(_ :JXActionView)
    @objc optional func willPresentJXActionView(_ :JXActionView)
    @objc optional func didPresentJXActionView(_ :JXActionView)
    
}
protocol JXActionViewDataSource {
    
    //func actionView(_ actionView: JXActionView, entityForRowAt index: Int) -> WalletCoinEntity
    func actionView(_ actionView: JXActionView, heightForRowAt index: Int) -> CGFloat
    func numberOfRow(in actionView: JXActionView) -> Int
    func actionView(_ actionView: JXActionView, listCell: UITableViewCell, cellForRowAt index: Int) -> UITableViewCell
}
