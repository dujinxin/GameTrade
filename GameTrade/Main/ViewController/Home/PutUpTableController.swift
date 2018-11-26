//
//  PutUpTableController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/4.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

let textCellIdentifier : String = "normalCellIdentifier"
let labelCellIdentifier : String = "emptyCellIdentifier"

class PutUpTableController: JXTableViewController {
    
    
    var defaultArray: Array = [["title":"可用币数量"],["title":"卖出币数量"],["title":"卖出单价"],["title":"卖出总价"],["title":"手续费"],["title":"实际总价"],["title":"支付方式"]]
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 30, y: 0, width: 200, height: 44)
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("添加", for: .normal)
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.addTarget(self, action: #selector(addOrder), for: .touchUpInside)
        button.backgroundColor = JXOrangeColor
        return button
    }()
    
    var vm = SellVM()
    
    var number = 0
    var sellTotal = "0 \(configuration_valueType)"
    var sellRealTotal = "0 \(configuration_valueType)"
    
    var payName = "支付宝"
    var payType = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "添加挂单"
        
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Close"), style: .plain, target: self, action: #selector(close))
        
        self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        
        //self.tableView?.separatorStyle = .none
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.register(UINib(nibName: "SellTextFieldCell", bundle: nil), forCellReuseIdentifier: textCellIdentifier)
        self.tableView?.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: labelCellIdentifier)
        
        self.button.frame = CGRect(x: 24, y: 24, width: kScreenWidth - 24 * 2, height: 44)
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 44 + 48))
        footer.addSubview(self.button)
        self.tableView?.tableFooterView = footer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.defaultArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = self.defaultArray[indexPath.row]
        if self.defaultArray.count > indexPath.row {
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! SellTextFieldCell
                cell.selectionStyle = .none
                cell.textField.delegate = self
                cell.textField.keyboardType = .numberPad
                cell.textField.attributedPlaceholder = NSAttributedString(string: "请输入卖出数量", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:JXPlaceHolerColor])
                
                NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
                
                cell.nameLabel.text = dict["title"]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: labelCellIdentifier, for: indexPath) as! LabelCell
                //cell.selectionStyle = .none
                cell.nameLabel.text = dict["title"]
                
                if indexPath.row == self.defaultArray.count - 1{
                    cell.accessoryType = .disclosureIndicator
                }
                
                if indexPath.row == 0 {
                    cell.infoLabel.text = "\(UserManager.manager.userEntity.property.balance)"
                } else if indexPath.row == 2 {
                    cell.infoLabel.text = "\(configuration_coinPrice) \(configuration_valueType)"
                } else if indexPath.row == 3 {
                    cell.infoLabel.text = self.sellTotal
                } else if indexPath.row == 4 {
                    cell.infoLabel.text = "\(configuration_service)"
                } else if indexPath.row == 5 {
                    cell.infoLabel.text = self.sellRealTotal
                } else {
                    cell.infoLabel.text = self.payName
                }
                
                return cell
                
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 6 {
            print("T##items: Any...##Any")
        } else if indexPath.row == 1 {
            
        } else {
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "cardPay") as! CardPayController
            vc.hidesBottomBarWhenPushed = true
            //vc.type = .tab
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        self.view.endEditing(true)
    //    }
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        if scrollView.isDragging {
    //            self.view.endEditing(true)
    //        }
    //    }
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func addOrder() {
        print("T##items: Any...##Any")
        
        self.vm.sellCreate(payType: self.payType, amount: self.number, safePassword: "1111") { (_, msg, isSuc) in
            if isSuc {
                if let block = self.backBlock {
                    block()
                }
                self.navigationController?.popViewController(animated: true)
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
}

extension PutUpTableController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @objc func textChange(notify: NSNotification) {
        
        if
            notify.object is UITextField,
            let textField = notify.object as? UITextField,
            let num = textField.text,
            let numDouble = Double(num) {
            
            self.number = Int(num) ?? 0
            self.sellTotal = "\(configuration_coinPrice * numDouble) \(configuration_valueType)"
            self.sellRealTotal = "\((configuration_coinPrice) * numDouble - configuration_coinPrice) \(configuration_valueType)"
        } else {
            self.sellTotal = "\(0) \(configuration_valueType)"
            self.sellRealTotal = "\(0) \(configuration_valueType)"
        }
        //self.tableView?.reloadData()
    }
    
}
