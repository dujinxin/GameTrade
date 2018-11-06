//
//  JXDropListView.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/24.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

enum JXDropListViewStyle : Int {
    case list
    case custom
}

private let reuseIdentifier = "reuseIdentifier"
private let topBarHeight : CGFloat = 60
private let tableViewCellHeight : CGFloat = 44
private let animateDuration : TimeInterval = 0.3

class JXDropListView: UIView {

    override func draw(_ rect: CGRect) {
        //画三角
//        var rect1 = rect
//        rect1.size.height -= 10
//        rect1.origin.y += 10
//
//        UIColor.white.setFill()
//
//        let bezier2 = UIBezierPath()
//
//        bezier2.move(to: CGPoint(x: rect.width - (20 + 10), y: 10))
//        bezier2.addLine(to: CGPoint(x: rect.width - 20, y: 0))
//        bezier2.addLine(to: CGPoint(x: rect.width - (20 - 10), y: 10))
//        bezier2.close()
//        //bezier2.fill()
//
//        let bezier1 = UIBezierPath(roundedRect: rect1, cornerRadius: 0)
//        bezier1.append(bezier2)
//        bezier1.fill()
    }
    
    //var rect = CGRect.init()
    private var selectViewTop : CGFloat = 0//10
    private var selectViewHeight : CGFloat = 0
    private var selectViewWidth : CGFloat = 100
    var selectRow : Int = -1
    var limit: Int = 5
    var style : JXDropListViewStyle = .list
    var customView : UIView? {
        didSet{
            self.style = .custom
            self.contentView = customView
        }
    }
    private var contentView : UIView?
    var isUseCustomTopBar : Bool = false {
        didSet{
            if isUseCustomTopBar == true {
                selectViewTop = topBarHeight
                self.addSubview(self.topBarView)
            }
            self.resetFrame()
        }
    }
    
    
    var delegate : JXDropListViewDelegate?
    var dataSource : JXDropListViewDataSource?
    
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
    var isEnabled : Bool = true {
        didSet{
            
        }
    }
    var isShowed : Bool = false
    
    var topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    
    lazy var tableView : UITableView = {
        let table = UITableView.init(frame: CGRect.init(), style: .plain)
        table.backgroundColor = UIColor.clear
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false
        table.bounces = false
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        //table.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
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
    
    
    init(frame: CGRect, style: JXDropListViewStyle) {
        super.init(frame: frame)
        
        self.style = style
        
        if style == .list {
            self.contentView = self.tableView
        }
        self.selectViewWidth = frame.size.width
        self.resetFrame()
    }
    init(frame: CGRect, customView: UIView) {
        super.init(frame: frame)
        self.style = .custom
        self.contentView = customView
        self.selectViewWidth = frame.size.width
        self.resetFrame()
    }
    func resetFrame(height: CGFloat = 0.0) {
        var h : CGFloat = 0
        if height > 0 {
            h = height
            selectViewHeight = height
        } else {
            if style == .list{
                let num = self.dataSource?.dropListView(listView:self, numberOfRowsInSection: 0) ?? 0
                let cellHeight = self.dataSource?.dropListView(listView: self, heightForRowAt: 0) ?? tableViewCellHeight
                h = CGFloat(num > limit ? limit : num) * cellHeight
                if num > limit {
                    tableView.isScrollEnabled = true
                    tableView.bounces = true
                    tableView.showsVerticalScrollIndicator = true
                }else{
                    tableView.isScrollEnabled = false
                    tableView.bounces = false
                    tableView.showsVerticalScrollIndicator = false
                }
            }
        }
        selectViewHeight = h
        
        var rect = self.frame
        rect.size.height = selectViewHeight + selectViewTop
        self.frame = rect
        
        self.layoutSubviews()
        
        if style == .list {
            self.contentView?.frame = CGRect(x: 0, y: selectViewTop, width: selectViewWidth, height: selectViewHeight)
        } else {
            self.contentView?.frame = CGRect(x: 0, y: selectViewTop, width: selectViewWidth, height: selectViewHeight + kBottomMaginHeight)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        if style == .list {
//            self.contentView?.frame = CGRect(x: 0, y: selectViewTop, width: selectViewWidth, height: selectViewHeight)
//        } else {
//            self.contentView?.frame = CGRect(x: 0, y: selectViewTop, width: selectViewWidth, height: selectViewHeight + kBottomMaginHeight)
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(){
        self.show(inView: self.bgWindow)
    }
    
    func show(inView view:UIView? ,animate:Bool = true) {
        
        self.addSubview(self.contentView!)
        self.resetFrame(height: selectViewHeight)
        
        let superView : UIView
        
        if let v = view {
            superView = v
        }else{
            superView = self.bgWindow
        }
        
        
        superView.addSubview(self.bgView)
        superView.addSubview(self)
        superView.isHidden = false
        
        var rect1 = self.frame
        rect1.size.height = 0
        self.frame = rect1
        
        var rect2 = self.contentView?.frame
        rect2!.size.height = 0
        self.contentView?.frame = rect2!
        
        
        rect1.size.height = selectViewTop + selectViewHeight
        rect2!.size.height = selectViewHeight
        
        if animate {
            UIView.animate(withDuration: animateDuration, delay: 0.0, options: .curveEaseIn, animations: {
                self.bgView.alpha = 0.5
                
                self.frame = rect1
                self.contentView?.frame = rect2!
                
            }, completion: { (finished) in
                self.isShowed = true
            })
        }
    }
    func dismiss(animate: Bool = true) {
        guard let superView = self.superview else {
            return
        }
        if animate {
            
            UIView.animate(withDuration: animateDuration, delay: 0.0, options: .curveEaseOut, animations: {
                self.bgView.alpha = 0.0
                
                var rect1 = self.frame
                rect1.size.height = 0
                self.frame = rect1
                
                var rect2 = self.contentView?.frame
                print(rect2)
                rect2!.size.height = 0
                self.contentView?.frame = rect2!
                
            }, completion: { (finished) in
                self.clearInfo()
            })
        }else{
            self.clearInfo()
        }
    }
    
    fileprivate func clearInfo() {
        self.isShowed = false
        bgView.removeFromSuperview()
        self.removeFromSuperview()
        bgWindow.isHidden = true
    }
    @objc private func tapClick() {
        self.dismiss()
    }
    fileprivate func viewDisAppear(row: Int, section: Int) {
        if self.delegate != nil && selectRow >= 0{
            self.delegate?.dropListView(listView: self, didSelectRowAt: row, inSection: section)
        }
        self.dismiss()
    }
}

extension JXDropListView : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (dataSource != nil) {
            return dataSource?.dropListView(listView:self, numberOfRowsInSection: section) ?? 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataSource != nil {
            return dataSource?.dropListView(listView: self, heightForRowAt: indexPath.row) ?? tableViewCellHeight
        }
        return tableViewCellHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        //let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: reuseIdentifier)
            cell?.backgroundColor = UIColor.clear
            cell?.selectionStyle = .none
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell?.textLabel?.numberOfLines = 1
            cell?.textLabel?.textColor = JXFfffffColor
        
            if isEnabled == false{
                cell?.selectionStyle = .none
            }
            if dataSource != nil {
                cell?.textLabel?.text = dataSource?.dropListView(listView: self, contentForRow: indexPath.row, InSection: indexPath.section)
            }
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isEnabled {
            tableView.deselectRow(at: indexPath, animated: true)
            self.selectRow = indexPath.row
            self.viewDisAppear(row: indexPath.row, section: indexPath.section)
            self.dismiss(animate: true)
            
        }else{
            
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
@objc protocol JXDropListViewDataSource {
    
    func dropListView(listView :JXDropListView, numberOfRowsInSection section:Int) -> Int
    func dropListView(listView :JXDropListView, heightForRowAt row:Int) -> CGFloat
    func dropListView(listView :JXDropListView, contentForRow row:Int, InSection section:Int) -> String
    
    @objc optional func numberOfComponents(listView :JXDropListView) -> Int
    
}
@objc protocol JXDropListViewDelegate {
    
    func dropListView(listView :JXDropListView, didSelectRowAt row:Int, inSection section:Int)
    @objc optional func dropListView(listView :JXDropListView, clickButtonAtIndex index:Int)
}

