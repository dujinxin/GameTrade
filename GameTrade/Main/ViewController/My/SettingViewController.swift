//
//  SettingViewController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/20.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class SettingViewController: JXTableViewController {

    var loginVM = LoginVM()
    var settingVM = SettingVM()
    
    var noticeView : JXSelectView?
    
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "系统设置"
        
        self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight + 48, width: kScreenWidth, height: 200)
        self.tableView?.separatorStyle = .none
        self.tableView?.rowHeight = 64
        //self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        self.tableView?.register(UINib(nibName: "PersonCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        self.tableView?.bounces = false
        self.tableView?.isScrollEnabled = false
        
        self.logoutButton.setTitleColor(JXFfffffColor, for: .normal)
        self.logoutButton.backgroundColor = JXMainColor
        self.logoutButton.layer.cornerRadius = 2
        self.logoutButton.layer.shadowOpacity = 1
        self.logoutButton.layer.shadowRadius = 10
        self.logoutButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.logoutButton.layer.shadowColor = JX10101aShadowColor.cgColor
        
        self.requestData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func requestData() {
        self.settingVM.version(2) { (_, msg, isSuc) in
            if isSuc {
                
            }
        }
    }
    @IBAction func logout(_ sender: Any) {
        self.loginVM.logout { (data, msg, isSuccess) in
            if isSuccess {
                self.navigationController?.popToRootViewController(animated: false)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLoginStatus), object: false)
            }else {
                ViewManager.showNotice(msg)
            }
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PersonCell
        cell.backgroundColor = UIColor.clear
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.leftLabel.textColor = JXMainTextColor
        cell.leftLabel.font = UIFont.systemFont(ofSize: 14)
        if indexPath.row == 0 {
            cell.leftLabel.text = "清理缓存"
        } else {
            cell.leftLabel.text = "检查更新"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            ViewManager.showImageNotice("清理成功")
        }  else {
            self.showNoticeView()
        }
    }
    
}
//MARK: version notice
extension SettingViewController {
    func showNoticeView() {
        //let margin : CGFloat = 40
        let width : CGFloat = kScreenWidth - 40 * 2
        let height : CGFloat = 300
        
        self.noticeView = JXSelectView(frame: CGRect(x: 0, y: 0, width: width, height: height), style: .custom)
        self.noticeView?.position = .middle
        self.noticeView?.customView = {
            
            let contentView = UIView()
            contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: height)
            
            let backgroundView = UIView()
            backgroundView.frame = CGRect(x: 40, y: 0, width: width, height: height)
            backgroundView.backgroundColor = JXFfffffColor
            backgroundView.layer.cornerRadius = 5
            contentView.addSubview(backgroundView)
            
            if app_style <= 1 {
                let gradientLayer = CAGradientLayer.init()
                gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
                gradientLayer.locations = [0]
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
                gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
                gradientLayer.cornerRadius = 5
                backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            }
            
            
            
            let titleLabel = UILabel()
            titleLabel.frame = CGRect(x: 24, y: 0, width: width - 48, height: 64)
            //label.center = view.center
            titleLabel.text = "新版本！\(self.settingVM.versionEntity.versionName ?? "")"
            titleLabel.textAlignment = .left
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            titleLabel.textColor = JXMainTextColor
            backgroundView.addSubview(titleLabel)
            
            let label = UILabel()
            label.frame = CGRect(x: 24, y: titleLabel.jxBottom + 5, width: width - 48, height: 15)
            //label.center = view.center
            label.text = "更新内容："
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = JXMainTextColor
            backgroundView.addSubview(label)
            
            
            
            let margin : CGFloat = 16
            let space : CGFloat = 24
            let buttonWidth : CGFloat = (width - 24 - 16 * 2) / 2
            let buttonHeight : CGFloat = 44
            
            let textView = UITextView(frame: CGRect(x: 24, y: label.jxBottom + 10, width: width - 24 * 2, height: height - label.jxBottom - buttonHeight - 24 - 20))
            textView.backgroundColor = UIColor.clear
            textView.text = self.settingVM.versionEntity.content
            textView.textColor = JXMainTextColor
            textView.font = UIFont.systemFont(ofSize: 12)
            textView.textAlignment = .left
            textView.isEditable = false
            
            backgroundView.addSubview(textView)
            textView.center.y = backgroundView.center.y
            
            
            let button1 = UIButton()
            button1.frame = CGRect(x: margin, y: height - space - buttonHeight, width: buttonWidth, height: buttonHeight)
            button1.setTitle("稍后再说", for: .normal)
            button1.setTitleColor(JXMainColor, for: .normal)
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button1.addTarget(self, action: #selector(hideNoticeView), for: .touchUpInside)
            backgroundView.addSubview(button1)
            
            
            let button = UIButton()
            button.frame = CGRect(x: button1.jxRight + space, y: button1.jxTop, width: buttonWidth, height: buttonHeight)
            button.setTitle("立即更新", for: .normal)
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(confirm), for: .touchUpInside)
            backgroundView.addSubview(button)
            
            
            button.layer.cornerRadius = 2
            button.layer.shadowOpacity = 1
            button.layer.shadowRadius = 10
            button.layer.shadowOffset = CGSize(width: 0, height: 10)
            button.layer.shadowColor = JX10101aShadowColor.cgColor
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.backgroundColor = JXMainColor
            
            return contentView
        }()
        
        self.noticeView?.show()
    }
    @objc func hideNoticeView() {
        self.noticeView?.dismiss()
    }
    @objc func confirm() {
        self.hideNoticeView()
      
        if
            let str = self.settingVM.versionEntity.url,
            let url = URL(string: str),
            UIApplication.shared.canOpenURL(url) == true {
            UIApplication.shared.open(url, options: [:]) { (isF) in
                //
            }
        }
    }
}
