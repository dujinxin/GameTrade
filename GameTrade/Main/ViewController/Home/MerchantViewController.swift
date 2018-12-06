//
//  MerchantViewController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/17.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

class MerchantViewController: JXCollectionViewController {
    
    var vm = SellVM()
    var id : String?
    
    var buyVM = BuyVM()
    var buyEntity : MerchantOrderEntity?
    var textField1 : UITextField!
    lazy var statusBottomView1: JXSelectView = {
        let selectView = JXSelectView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 200), style: JXSelectViewStyle.custom)
        selectView.backgroundColor = JXMainColor
        selectView.isBackViewUserInteractionEnabled = false
        
        self.setKeyBoardObserver()
        return selectView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.title = "商家"
        
        self.collectionView?.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        // Register cell classes
        self.collectionView?.register(UINib.init(nibName: "MerchantSubCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(UINib.init(nibName: "MerchantReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIndentifierHeader)
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = CGSize(width: kScreenWidth, height: 131)
        
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width: kScreenWidth, height: 231 + kNavStatusHeight)
        
        self.collectionView?.collectionViewLayout = layout
        
        self.requestData()
        //每次进入都刷新，则不用监听登录状态
        //NotificationCenter.default.addObserver(self, selector: #selector(loginStatus(notify:)), name: NSNotification.Name(rawValue: NotificationLoginStatus), object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "invite":
//            if let vc = segue.destination as? InviteViewController, let inviteEntity = sender as? InviteEntity {
//                vc.inviteEntity = inviteEntity
//            }
//        default:
//            print("123456")
//        }
    }
    override func requestData() {
        
        self.vm.merchantDetail(id: self.id ?? "") { (_, msg, isSuc) in
            if isSuc {
                
            } else {
                ViewManager.showNotice(msg)
            }
            self.collectionView?.reloadData()
        }
        
    }
}
extension MerchantViewController {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vm.merchantEntity.listArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let entity = self.vm.merchantEntity.listArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MerchantSubCell
        cell.entity = entity
        cell.buyBlock = {
            self.buyEntity = entity
            self.statusBottomView1.customView = self.customViewInit1(number: "\(entity.limitMax)", address: "address", gas: "gas", remark: "无")
            self.statusBottomView1.show()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIndentifierHeader, for: indexPath) as! MerchantReusableView
        reusableView.entity = self.vm.merchantEntity
        if kind == UICollectionView.elementKindSectionHeader {
            
        }
        
        return reusableView
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            
        }
    }
}
//MARK: SelectView - normal
extension MerchantViewController {
    
    private func setKeyBoardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func customViewInit1(number: String, address: String, gas: String, remark: String) -> UIView {
        
        let width : CGFloat = kScreenWidth - 48
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 398)
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 398 + kBottomMaginHeight)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        let leftContentView = UIView()
        leftContentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 398 + kBottomMaginHeight)
        contentView.addSubview(leftContentView)
        
        //左侧视图
        
        let topBarView = { () -> UIView in
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60))
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
            //label.center = view.center
            label.text = "确认购买"
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
            button.addTarget(self, action: #selector(closeStatus1), for: .touchUpInside)
            view.addSubview(button)
            
            return view
        }()
        leftContentView.addSubview(topBarView)
        
        let textField = UITextField(frame: CGRect(x: 24, y: topBarView.jxBottom + 20, width: width , height: 48))
        textField.backgroundColor = UIColor.rgbColor(rgbValue: 0x2f2f3c)
        //textField.delegate = self
        textField.placeholder = "输入购买金额"
        textField.text = number
        textField.keyboardType = .numberPad
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = JXFfffffColor
        textField.attributedPlaceholder = NSAttributedString(string: "输入购买金额", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:JXPlaceHolerColor])
        leftContentView.addSubview(textField)
        
        textField.rightViewMode = .always
        textField.rightView = {
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: 24, y: topBarView.jxBottom + 20, width: 60, height: 30)
            nameLabel.text = "\(configuration_coinName)"
            nameLabel.textColor = JXFfffffColor
            nameLabel.font = UIFont.systemFont(ofSize: 13)
            nameLabel.textAlignment = .center
            
            return nameLabel
        }()
        self.textField1 = textField
        
        
        //1
        let leftLabel1 = UILabel()
        leftLabel1.frame = CGRect(x: 24, y: textField.jxBottom + 16, width: 65, height: 51)
        leftLabel1.text = "交易金额"
        leftLabel1.textColor = JXMainText50Color
        leftLabel1.font = UIFont.systemFont(ofSize: 13)
        leftLabel1.textAlignment = .left
        leftContentView.addSubview(leftLabel1)
        
        let rightLabel1 = UILabel()
        rightLabel1.frame = CGRect(x: leftLabel1.jxRight, y: leftLabel1.jxTop, width: kScreenWidth - 48 - leftLabel1.jxWidth, height: 51)
        if let num = Double(number) {
            rightLabel1.text = "\(num * configuration_coinPrice) \(configuration_valueType)"
        } else {
            rightLabel1.text = "\(0) \(configuration_valueType)"
        }
        
        rightLabel1.textColor = JXRedColor
        rightLabel1.font = UIFont.systemFont(ofSize: 14)
        rightLabel1.textAlignment = .right
        leftContentView.addSubview(rightLabel1)
        
        let line1 = UIView()
        line1.frame = CGRect(x: textField.jxLeft, y: leftLabel1.jxBottom, width: width, height: 1)
        line1.backgroundColor = JXSeparatorColor
        leftContentView.addSubview(line1)
        
        //2
        let leftLabel2 = UILabel()
        leftLabel2.frame = CGRect(x: 24, y: line1.jxBottom, width: 65, height: 51)
        leftLabel2.text = "交易单价"
        leftLabel2.textColor = JXMainText50Color
        leftLabel2.font = UIFont.systemFont(ofSize: 13)
        leftLabel2.textAlignment = .left
        leftContentView.addSubview(leftLabel2)
        
        let rightLabel2 = UILabel()
        rightLabel2.frame = CGRect(x: leftLabel2.jxRight, y: leftLabel2.jxTop, width: kScreenWidth - 48 - leftLabel2.jxWidth, height: 51)
        rightLabel2.text = "\(configuration_coinPrice) \(configuration_valueType)"
        rightLabel2.textColor = JXMainTextColor
        rightLabel2.font = UIFont.systemFont(ofSize: 14)
        rightLabel2.textAlignment = .right
        leftContentView.addSubview(rightLabel2)
        
        let line2 = UIView()
        line2.frame = CGRect(x: textField.jxLeft, y: leftLabel2.jxBottom, width: width, height: 1)
        line2.backgroundColor = JXSeparatorColor
        leftContentView.addSubview(line2)
        
        
        //3
        let leftLabel3 = UILabel()
        leftLabel3.frame = CGRect(x: 24, y: line2.jxBottom , width: 65, height: 51)
        leftLabel3.text = "交易数量"
        leftLabel3.textColor = JXMainText50Color
        leftLabel3.font = UIFont.systemFont(ofSize: 13)
        leftLabel3.textAlignment = .left
        leftContentView.addSubview(leftLabel3)
        
        let rightLabel3 = UILabel()
        rightLabel3.frame = CGRect(x: leftLabel3.jxRight, y: leftLabel3.jxTop, width: kScreenWidth - 48 - leftLabel3.jxWidth, height: 51)
        rightLabel3.text = number
        rightLabel3.textColor = JXMainTextColor
        rightLabel3.font = UIFont.systemFont(ofSize: 14)
        rightLabel3.textAlignment = .right
        leftContentView.addSubview(rightLabel3)
        
        let line3 = UIView()
        line3.frame = CGRect(x: textField.jxLeft, y: leftLabel3.jxBottom, width: width, height: 1)
        line3.backgroundColor = JXSeparatorColor
        leftContentView.addSubview(line3)
        
        
        let button = UIButton()
        button.frame = CGRect(x: textField.jxLeft, y: line3.jxBottom + 30, width: width, height: 44)
        button.setTitle("下单", for: .normal)
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(confirm1), for: .touchUpInside)
        leftContentView.addSubview(button)
        
        
        button.layer.cornerRadius = 2
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowColor = JX10101aShadowColor.cgColor
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.backgroundColor = JXMainColor
        
        
        return contentView
    }
    @objc func confirm1() {
        print("confirm")
        guard let text = self.textField1.text, text.isEmpty == false else{
            return
        }
        self.closeStatus1()
        self.showMBProgressHUD()
        self.buyVM.buyNormal(tradeSaleId: self.buyEntity?.id ?? "", amount: Int(text) ?? 0, completion: { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            if isSuc {
                let vc = OrderDetailController()
                vc.id = self.buyVM.id
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                ViewManager.showNotice(msg)
            }
        })
    }
    @objc func closeStatus1() {
        self.statusBottomView1.dismiss()
    }
    
}
extension MerchantViewController : UITextFieldDelegate {
    @objc func keyboardWillShow(notify:Notification) {
        
        guard
            let userInfo = notify.userInfo,
            let rect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        UIView.animate(withDuration: animationDuration, animations: {
            self.statusBottomView1.frame.origin.y = kScreenHeight - self.statusBottomView1.frame.size.height - rect.height
        }) { (finish) in
            //
        }
    }
    @objc func keyboardWillHide(notify:Notification) {
        print("notify = ","notify")
        guard
            let userInfo = notify.userInfo,
            let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        UIView.animate(withDuration: animationDuration, animations: {
            
        }) { (finish) in
            
        }
    }
}
