//
//  PayListController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/18.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

let normalCellIdentifier : String = "normalCellIdentifier"
let emptyCellIdentifier : String = "emptyCellIdentifier"

class PayListController: JXTableViewController {

    var vm = PayVM()
    var defaultArray: Array = [["image":"icon-ali","title":"支付宝"],["image":"icon-wechat","title":"微信"],["image":"icon-card","title":"银行卡"]]
    
 
    var psdTextView : PasswordTextView!
    lazy var statusBottomView: JXSelectView = {
        let selectView = JXSelectView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 200), style: JXSelectViewStyle.custom)
        selectView.isBackViewUserInteractionEnabled = false
       
        return selectView
    }()
    
    var isFirstEnter : Bool = false
    
    var type : Int = 0 // 0添加，1编辑，2删除
    var currentIndexPath : IndexPath?
    var psdText : String = ""
    
    var id: String = ""
    var payType: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收款方式"
        
        self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        
        //self.tableView?.separatorStyle = .none
        self.tableView?.estimatedRowHeight = 88
        self.tableView?.register(UINib(nibName: "PayNormalCell", bundle: nil), forCellReuseIdentifier: normalCellIdentifier)
        self.tableView?.register(UINib(nibName: "PayEmptyCell", bundle: nil), forCellReuseIdentifier: emptyCellIdentifier)
    
        self.requestData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstEnter {
            isFirstEnter = false
            if let controllers = self.navigationController?.viewControllers, controllers.count > 2 {
                print(controllers)
                self.navigationController?.viewControllers.remove(at: controllers.count - 2)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func requestData() {
        self.vm.payCustomList { (_, msg, isSuc) in
            self.tableView?.reloadData()
        }
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = self.defaultArray[indexPath.item]
        
        if indexPath.row == 0 {
            if let entity = self.vm.customListEntity?.list["ali"], entity.isEmpty == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: normalCellIdentifier, for: indexPath) as! PayNormalCell
            
                cell.selectionStyle = .none
                cell.payImageView.image = UIImage(named: dict["image"]!)
                cell.payNameLabel.text = dict["title"]
                cell.entity = entity
                cell.editBlock = {
                    cell.setEditing(true, animated: true)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: emptyCellIdentifier, for: indexPath) as! PayEmptyCell
                //cell.selectionStyle = .none
                cell.payImageView.image = UIImage(named: dict["image"]!)
                cell.payNameLabel.text = dict["title"]
                return cell
            }
            
        } else if indexPath.row == 1{
            if let entity = self.vm.customListEntity?.list["weChat"], entity.isEmpty == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: normalCellIdentifier, for: indexPath) as! PayNormalCell
                
                cell.selectionStyle = .none
                cell.payImageView.image = UIImage(named: dict["image"]!)
                cell.payNameLabel.text = dict["title"]
                cell.entity = entity
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: emptyCellIdentifier, for: indexPath) as! PayEmptyCell
                //cell.selectionStyle = .none
                cell.payImageView.image = UIImage(named: dict["image"]!)
                cell.payNameLabel.text = dict["title"]
                return cell
            }
        } else {
            if let entity = self.vm.customListEntity?.list["card"], entity.isEmpty == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: normalCellIdentifier, for: indexPath) as! PayNormalCell
                
                cell.payImageView.image = UIImage(named: dict["image"]!)
                cell.payNameLabel.text = dict["title"]
                cell.entity = entity
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: emptyCellIdentifier, for: indexPath) as! PayEmptyCell
                //cell.selectionStyle = .none
                cell.payImageView.image = UIImage(named: dict["image"]!)
                cell.payNameLabel.text = dict["title"]
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            
            if let entity = self.vm.customListEntity?.list["ali"], entity.isEmpty == 0 {
                return true
            }
            
        } else if indexPath.row == 1 {
            if let entity = self.vm.customListEntity?.list["weChat"], entity.isEmpty == 0 {
                return true
            }
        } else {
            if let entity = self.vm.customListEntity?.list["card"], entity.isEmpty == 0 {
                return true
            }
        }
        return false
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除！"
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        let style : UITableViewCellEditingStyle = .delete
        return style
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.currentIndexPath = indexPath
        self.type = 0
        self.statusBottomView.customView = self.customViewInit()
        self.statusBottomView.show(inView: self.view)
        self.psdTextView.textField.becomeFirstResponder()
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //default,destructive默认红色，normal默认灰色，可以通过backgroundColor 修改背景颜色，backgroundEffect 添加模糊效果
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { (action, indexPath) in
            
            var en = PayEntity()
            
            if indexPath.row == 0 {
                if let entity = self.vm.customListEntity?.list["ali"]{
                    en = entity
                }
            } else if indexPath.row == 1 {
                if let entity = self.vm.customListEntity?.list["weChat"]{
                    en = entity
                }
            } else  {
                if let entity = self.vm.customListEntity?.list["card"]{
                    en = entity
                }
            }
            self.id = en.id ?? ""
            self.payType = indexPath.row + 1
            
//            self.showInputView()
        
            self.currentIndexPath = indexPath
            self.type = 2
            self.statusBottomView.customView = self.customViewInit()
            self.statusBottomView.show(inView: self.view)
            self.psdTextView.textField.becomeFirstResponder()
        }
        let markAction = UITableViewRowAction(style: .default, title: "编辑") { (action, indexPath) in
            print("编辑")
            
            self.currentIndexPath = indexPath
            self.type = 1
            self.statusBottomView.customView = self.customViewInit()
            self.statusBottomView.show(inView: self.view)
            self.psdTextView.textField.becomeFirstResponder()
        }
        let cancelAction = UITableViewRowAction(style: .normal, title: "取消") { (action, indexPath) in
            //
            print("取消")
        }
        markAction.backgroundColor = JXGreenColor
        deleteAction.backgroundColor = JXRedColor
        cancelAction.backgroundColor = JXOrangeColor
        return [deleteAction,cancelAction,markAction]
    }
    func editActionsForRowAt(indexPath: IndexPath) {
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "netPay") as! NetPayController
            vc.hidesBottomBarWhenPushed = true
            vc.type = 1
            vc.psdText = self.psdText
            vc.backBlock = {
                //tableView.reloadRows(at: [indexPath], with: .automatic)
                self.requestData()
            }
            if let entity = self.vm.customListEntity?.list["ali"], entity.isEmpty == 0 {
                vc.entity = entity
                vc.isEdit = true
            } else {
                vc.isEdit = false
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 1 {
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "netPay") as! NetPayController
            vc.hidesBottomBarWhenPushed = true
            vc.type = 2
            vc.psdText = self.psdText
            vc.backBlock = {
                //tableView.reloadRows(at: [indexPath], with: .automatic)
                self.requestData()
            }
            if let entity = self.vm.customListEntity?.list["weChat"], entity.isEmpty == 0 {
                vc.entity = entity
                vc.isEdit = true
            } else {
                vc.isEdit = false
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "cardPay") as! CardPayController
            vc.hidesBottomBarWhenPushed = true
            vc.psdText = self.psdText
            vc.backBlock = {
                //tableView.reloadRows(at: [indexPath], with: .automatic)
                self.requestData()
            }
            if let entity = self.vm.customListEntity?.list["card"], entity.isEmpty == 0 {
                vc.entity = entity
                vc.isEdit = true
            } else {
                vc.isEdit = false
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension PayListController {
    func customViewInit() -> UIView {
        
        let width : CGFloat = kScreenWidth - 48
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 402)
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 402 + kBottomMaginHeight)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
 
        
        
        let topBarView1 = { () -> UIView in
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60))
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
            //label.center = view.center
            label.text = "输入资金密码"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = JXFfffffColor
            view.addSubview(label)
            //label.sizeToFit()
            
            let button = UIButton()
            button.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            //button.setTitle("×", for: .normal)
            button.tintColor = JXFfffffColor
            button.setImage(UIImage(named: "Close")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.setTitleColor(JX333333Color, for: .normal)
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = .center
            button.addTarget(self, action: #selector(closeStatus), for: .touchUpInside)
            view.addSubview(button)
            
            
            let button1 = UIButton()
            button1.frame = CGRect(x: kScreenWidth - 80 - 24, y: 10, width: 80, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            button1.setTitle("忘记密码？", for: .normal)
            
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button1.setTitleColor(JXOrangeColor, for: .normal)
            button1.contentVerticalAlignment = .center
            button1.contentHorizontalAlignment = .right
            button1.addTarget(self, action: #selector(forgotPsd), for: .touchUpInside)
            view.addSubview(button1)
            
            return view
        }()
        contentView.addSubview(topBarView1)
        
        
        self.psdTextView = PasswordTextView(frame: CGRect(x: (kScreenWidth - 176) / 2, y: topBarView1.jxBottom, width: 176, height: 60))
        //psdTextView.textField.delegate = self
        psdTextView.backgroundColor = UIColor.white //要先设置颜色，再设置透明，不然不起作用，还有绘制的问题，待研究
        contentView.addSubview(psdTextView)
        
        psdTextView.backgroundColor = UIColor.clear
        psdTextView.limit = 4
        psdTextView.bottomLineColor = JXSeparatorColor
        psdTextView.textColor = JXFfffffColor
        psdTextView.font = UIFont.systemFont(ofSize: 21)
        psdTextView.completionBlock = { (text,isFinish) -> () in
            
            if isFinish {
                self.closeStatus()
                self.confirm(psd: text)
            }
        }
        
        return contentView
    }
    @objc func forgotPsd() {
        let storyboard = UIStoryboard(name: "My", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "modifyTradePsw") as! ModifyTradePswController
        vc.hidesBottomBarWhenPushed = true
        vc.type = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func closeStatus() {
        self.statusBottomView.dismiss()
    }
    
    func confirm(psd: String) {
        //删除
        if self.type == 2 {
            self.showMBProgressHUD()
            self.vm.deletePay(id: self.id, payType: self.payType, safePassword: psd, completion: { (_, msg, isSuc) in
                self.hideMBProgressHUD()
                if isSuc {
                    self.requestData()
                } else {
                    ViewManager.showNotice(msg)
                }
            })
        } else {
            self.showMBProgressHUD()
            self.vm.validateTradePassword(psd) { (_, msg, isSuc) in
                self.hideMBProgressHUD()
                if isSuc == true, let indexPath = self.currentIndexPath{
                    self.psdText = psd
                    self.editActionsForRowAt(indexPath: indexPath)
                } else {
                    ViewManager.showNotice(msg)
                }
            }
        }
    }
    
    func showInputView() {
        let inputTextView = JXNumInputTextView(frame: CGRect(x: 0, y: self.view.frame.height, width: view.bounds.width, height: 60), completion:nil)
        inputTextView.sendBlock = { (_,object) in
            
        }
        inputTextView.cancelBlock = { (_,_) in
            
        }
        inputTextView.limitWords = 4
        inputTextView.useTopBar = true
        inputTextView.show()
    }
}
