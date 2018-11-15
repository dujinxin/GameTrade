//
//  MyViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/8.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class MyViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var dataArray = [["image":"icon-collection","title":"收款方式"],["image":"icon-protect","title":"安全中心"],["image":"icon-help","title":"帮助反馈"],["image":"icon-system","title":"系统设置"]]
    
    var vm = LoginVM()
    @IBOutlet weak var tableView: UITableView!
    
    var noticeView : JXSelectView?
    
    var nickName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.tableView?.contentInsetAdjustmentBehavior = .never
            self.tableView?.scrollIndicatorInsets = UIEdgeInsetsMake(kNavStatusHeight, 0, 0, 0)
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.tableView.register(UINib(nibName: "MyCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier1")
        self.tableView.register(UINib(nibName: "ImageTitleCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier2")
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.isScrollEnabled = false
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.clear
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !UserManager.manager.isLogin {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            let loginVC = UINavigationController.init(rootViewController: login)
            self.navigationController?.present(loginVC, animated: false, completion: nil)
        } else {
            self.requestData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "accound" {
            if let vc = segue.destination as? AccountViewController,let mobile = sender as? String {
                vc.mobile = mobile
            }
        }
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
    override func requestData() {
        self.vm.personInfo { (data, msg, isSuccess) in
            if isSuccess == true {
                self.tableView.reloadData()
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
    @IBAction func edit(_ sender: UIButton) {

        let alertVC = UIAlertController(title: "修改昵称", message: nil, preferredStyle: .alert)
        //键盘的返回键 如果只有一个非cancel action 那么就会触发 这个按钮，如果有多个那么返回键只是单纯的收回键盘
        alertVC.addTextField(configurationHandler: { (textField) in
            textField.text = self.vm.profileInfoEntity?.nickname
            textField.delegate = self
            //textField.addTarget(self, action: #selector(self.valueChanged(textField:)), for: .editingChanged)
        })
        alertVC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
            
            if
                let textField = alertVC.textFields?[0],
                let text = textField.text,
                text.isEmpty == false,
                text != self.vm.profileInfoEntity?.nickname{
                
                self.showMBProgressHUD()
                self.vm.modify(nickName: text, completion: { (_, msg, isSuccess) in
                    self.hideMBProgressHUD()
                    if isSuccess == false {
                        ViewManager.showNotice(msg)
                    } else {
                        self.vm.profileInfoEntity?.nickname = text
                        self.tableView.reloadData()
                    }
                })
            }
        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        }))
        self.present(alertVC, animated: true, completion: nil)
    }

    @objc func valueChanged(textField:UITextField) {
        let maxLength = 12
        
        guard let string = textField.text as NSString? else {
            return
        }
        //当前输入框语言
        let lang = textField.textInputMode?.primaryLanguage
        //系统语言
        //let lang = UIApplication.shared.textInputMode?.primaryLanguage
        if lang == "zh-Hans" {
            guard
                let selectedRange = textField.markedTextRange,
                let position = textField.position(from: selectedRange.start, offset: 0) else{
                return
            }
            print(position)
            if string.length > maxLength {
                let rangeIndex = string.rangeOfComposedCharacterSequence(at: maxLength)
                if rangeIndex.length == 1 {
                    textField.text = string.substring(to: maxLength)
                } else {
                    let range = string.rangeOfComposedCharacterSequences(for: NSRange.init(location: 0, length: maxLength))
                    textField.text = string.substring(with: range)
                }
            }
        } else {
            if string.length > maxLength {
                print(string.length)
                let rangeIndex = string.rangeOfComposedCharacterSequence(at: maxLength)
                if rangeIndex.length == 1 {
                    textField.text = string.substring(to: maxLength)
                } else {
                    let range = string.rangeOfComposedCharacterSequences(for: NSRange.init(location: 0, length: maxLength))
                    textField.text = string.substring(with: range)
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableViewAutomaticDimension
        if indexPath.row == 0 {
            return 200 + kNavStatusHeight
        } else {
            return 50
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier1", for: indexPath) as! MyCell
            cell.accessoryType = .none
            
            if let str = self.vm.profileInfoEntity?.headImg {
                let url = URL.init(string:str)
                cell.userImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "defaultImage"), options: [], completed: nil)
                //cell.userImageView.sd_setImage(with: url, completed: nil)
            }
            cell.nickNameLabel.text = self.vm.profileInfoEntity?.nickname
            cell.editButton.addTarget(self, action: #selector(edit(_:)), for: .touchUpInside)
            cell.rankLabel.text = self.vm.profileInfoEntity?.mobile
            cell.modifyBlock = {
                let storyboard = UIStoryboard(name: "Task", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ModifyImageVC") as! ModifyImageController
                vc.hidesBottomBarWhenPushed = true
                vc.avatar = self.vm.profileInfoEntity?.headImg
                vc.backBlock = {
                    self.requestData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier2", for: indexPath) as! ImageTitleCell
            let dict = dataArray[indexPath.row - 1]
            
            cell.iconView.image = UIImage(named: dict["image"]!)
            cell.titleView.text = dict["title"]
            cell.accessoryType = .disclosureIndicator
//            if indexPath.row == 2 {
//                cell.accessoryType = .none
//                cell.detailView.text = "开发中..."
//            } else {
//                cell.accessoryType = .disclosureIndicator
//            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            //performSegue(withIdentifier: "property", sender: nil)
            if UserManager.manager.userEntity.user.safePwdInit != 0 {
                if UserManager.manager.userEntity.realName.isEmpty == false {
                    let vc = PayListController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let storyboard = UIStoryboard(name: "My", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "nameSet") as! NameSetController
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                self.showNoticeView()
            }
            
        } else if indexPath.row == 2{
            let vc = SecurityCenterController()
            vc.hidesBottomBarWhenPushed = true
            vc.mobile = self.vm.profileInfoEntity?.mobile
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3{
            let vc = HelpFeedBackController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 4{
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "setting") as! SettingViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } 
    }
}
extension MyViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location > 11 {
            //let s = textField.text! as NSString
            //let str = s.substring(to: 10)
            //textField.text = str
            //ViewManager.showNotice(notice: "字符个数为11位")
            return false
        }
        return true
    }
}
//MARK: trade psd notice
extension MyViewController {
    func showNoticeView() {
        let width : CGFloat = kScreenWidth - 40 * 2
        let height : CGFloat = 300
        
        self.noticeView = JXSelectView(frame: CGRect(x: 0, y: 0, width: width, height: height), style: .custom)
        self.noticeView?.position = .middle
        self.noticeView?.customView = {
            
            let contentView = UIView()
            contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: height)
            
            let backgroundView = UIView()
            backgroundView.frame = CGRect(x: 40, y: 0, width: width, height: height)
            contentView.addSubview(backgroundView)
            
            let gradientLayer = CAGradientLayer.init()
            gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
            gradientLayer.locations = [0]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
            gradientLayer.cornerRadius = 5
            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            
            
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: width, height: 100)
            //label.center = view.center
            label.text = "提示"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = JXTextColor
            backgroundView.addSubview(label)
            
            
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: 24, y: label.jxBottom + 20, width: width - 24 * 2, height: 30)
            nameLabel.text = "您还未设置资金密码"
            nameLabel.textColor = JXTextColor
            nameLabel.font = UIFont.systemFont(ofSize: 16)
            nameLabel.textAlignment = .center
            
            backgroundView.addSubview(nameLabel)
            nameLabel.center.y = backgroundView.center.y
            
            
            let margin : CGFloat = 16
            let space : CGFloat = 24
            let buttonWidth : CGFloat = (width - 24 - 16 * 2) / 2
            let buttonHeight : CGFloat = 44
            
            let button1 = UIButton()
            button1.frame = CGRect(x: margin, y: height - space - buttonHeight, width: buttonWidth, height: buttonHeight)
            button1.setTitle("稍后再说", for: .normal)
            button1.setTitleColor(JXOrangeColor, for: .normal)
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button1.addTarget(self, action: #selector(hideNoticeView), for: .touchUpInside)
            backgroundView.addSubview(button1)
            
            
            let button = UIButton()
            button.frame = CGRect(x: button1.jxRight + space, y: button1.jxTop, width: buttonWidth, height: buttonHeight)
            button.setTitle("立即设置", for: .normal)
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(setPsd), for: .touchUpInside)
            backgroundView.addSubview(button)
            
            
            button.layer.cornerRadius = 2
            button.layer.shadowOpacity = 1
            button.layer.shadowRadius = 10
            button.layer.shadowOffset = CGSize(width: 0, height: 10)
            button.layer.shadowColor = JX10101aShadowColor.cgColor
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.backgroundColor = JXOrangeColor
            
            return contentView
        }()
        
        self.noticeView?.show()
    }
    @objc func hideNoticeView() {
        self.noticeView?.dismiss()
    }
    @objc func setPsd() {
        self.hideNoticeView()
        
        let storyboard = UIStoryboard(name: "My", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "modifyTradePsw") as! ModifyTradePswController
        vc.hidesBottomBarWhenPushed = true
        vc.type = 2
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

