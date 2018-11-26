//
//  NewBuyController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/4.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import JXFoundation

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

class NewBuyController: JXCollectionViewController {
    
    
    var vm = BuyVM()
    var type = 0
    
    var textField : UITextField!
    
    var headViewHeight : CGFloat = 126
    
    lazy var headView: UIView = {
        let headView = UIView(frame: CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: headViewHeight))
        return headView
    }()
    
    var topBar : JXBarView!
    var horizontalView : JXHorizontalView?
    
    
    
    lazy var statusBottomView: JXSelectView = {
        let selectView = JXSelectView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 200), style: JXSelectViewStyle.custom)
        selectView.backgroundColor = JXOrangeColor
        selectView.isBackViewUserInteractionEnabled = false
        
        return selectView
    }()
    
    var payName = "支付宝"
    var payType = 1
    var amount: Int = 0
    var buttonArray = Array<UIButton>()
    
    
    lazy var keyboard: JXKeyboardToolBar = {
        let bar = JXKeyboardToolBar(frame: CGRect())
        bar.showBlock = { (view, value) in
            print(view,value)
        }
        bar.closeBlock = {
            //self.textField.text = ""
        }
        bar.tintColor = JXTextColor
        bar.toolBar.barTintColor = JXBackColor
        bar.backgroundColor = JXBackColor
        return bar
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "我要买"

        //self.view.insertSubview(self.headView, belowSubview: self.customNavigationBar)
        self.view.addSubview(self.headView)
        
        let topView = UIView(frame: CGRect(x: 24, y: 8, width: kScreenWidth - 48, height: 67))
        topView.backgroundColor = JXBackColor
        topView.layer.cornerRadius = 4
        topView.layer.shadowOpacity = 1
        topView.layer.shadowRadius = 33
        topView.layer.shadowOffset = CGSize(width: 0, height: 10)
        topView.layer.shadowColor = JX22222cShadowColor.cgColor
        headView.addSubview(topView)
        
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x393948).cgColor,UIColor.rgbColor(rgbValue: 0x3c3c4b).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 48, height: 67)
        
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        
        let textFieldBgView = UIView(frame: CGRect(x: 16, y: 18, width: topView.jxWidth - 16 * 2 - 12 - 88, height: 32))
        textFieldBgView.backgroundColor = UIColor.rgbColor(rgbValue: 0x2f2f3c)
        topView.addSubview(textFieldBgView)
        
        self.textField = UITextField(frame: CGRect(x: 16, y: 0, width: textFieldBgView.jxWidth - 16 * 2 , height: 32))
        textField.backgroundColor = UIColor.rgbColor(rgbValue: 0x2f2f3c)
        textField.delegate = self
        textField.placeholder = "输入购买金额"
        textField.keyboardType = .numberPad
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.textColor = JXFfffffColor
        textField.attributedPlaceholder = NSAttributedString(string: "输入购买金额", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:JXPlaceHolerColor])
        textFieldBgView.addSubview(textField)
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: topView.jxWidth - 16 - 88, y: 18, width: 88, height: 32)
        button.setTitle("快捷购买", for: .normal)
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = JXOrangeColor
        button.layer.cornerRadius = 2
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowColor = JX10101aShadowColor.cgColor
        button.addTarget(self, action: #selector(buy), for: .touchUpInside)
        
        topView.addSubview(button)
        
        self.keyboard.views = [textField]
        self.view.addSubview(self.keyboard)
        
        topBar = JXBarView.init(frame: CGRect.init(x: 0, y: 83, width: view.bounds.width , height: 44), titles: ["全部","支付宝","微信","银行卡"])
        topBar.delegate = self
        
        let att = JXAttribute()
        att.normalColor = JX999999Color
        att.selectedColor = JXOrangeColor
        att.normalColor = JX999999Color
        att.font = UIFont.systemFont(ofSize: 14)
        topBar.attribute = att
        
        //topBar.backgroundColor = JXOrangeColor
        topBar.bottomLineSize = CGSize(width: 45, height: 3)
        topBar.bottomLineView.backgroundColor = JXOrangeColor
        topBar.isBottomLineEnabled = true
        
        headView.addSubview(topBar!)
        
        self.collectionView?.frame = CGRect.init(x: 0, y: kNavStatusHeight + headViewHeight, width: view.bounds.width, height: UIScreen.main.bounds.height - kNavStatusHeight - headViewHeight)
        self.collectionView?.register(UINib.init(nibName: "MerchantCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(UINib.init(nibName: "HomeReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIndentifierHeader)
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = CGSize.init(width: kScreenWidth, height: 168)
        //layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView?.collectionViewLayout = layout
        
        
        self.collectionView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request(page: 1)
        })
        self.collectionView?.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.page += 1
            self.request(page: self.page)
        })
        self.collectionView?.mj_header.beginRefreshing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textField.text = ""
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    override func request(page: Int) {
        self.vm.buyList(payType: self.type, pageSize: 10, pageNo: page) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            self.collectionView?.mj_header.endRefreshing()
            self.collectionView?.mj_footer.endRefreshing()
            self.collectionView?.reloadData()
        }
    }
    @objc func buy() {
        
        guard let text = self.textField.text, text.isEmpty == false else{
            ViewManager.showNotice("请先输入购买数量")
            return
        }
        guard let num = Int(text), num > 10 else{
            ViewManager.showNotice("暂无该挂单金额，请重新输入")
            return
        }
        self.textField.resignFirstResponder()
        
        self.showMBProgressHUD()
        self.vm.getQuickPayType(amount: num, completion: { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            if isSuc{
                self.amount = num
                self.statusBottomView.customView = self.customViewInit(number: text)
                self.statusBottomView.show()
            } else {
                ViewManager.showNotice("暂无该挂单金额，请重新输入")
            }
        })
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    //MARK: SelectView - normal
    
    var buyEntity : BuyEntity!
    
    var normalTextField: UITextField!
    var normalNumLabel: UILabel!
    var normalValueLabel: UILabel!
    
    lazy var statusBottomView1: JXSelectView = {
        let selectView = JXSelectView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 200), style: JXSelectViewStyle.custom)
        selectView.backgroundColor = JXOrangeColor
        selectView.isBackViewUserInteractionEnabled = false
        
        self.setKeyBoardObserver()
        return selectView
    }()
    private func setKeyBoardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func customViewInit1(number: String, address: String, gas: String, remark: String) -> UIView {
        
        let width : CGFloat = kScreenWidth - 48
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 442)
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 442 + kBottomMaginHeight)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        let leftContentView = UIView()
        leftContentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 442 + kBottomMaginHeight)
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
        
        self.normalTextField = {
            let textField = UITextField(frame: CGRect(x: 24, y: topBarView.jxBottom + 20, width: width , height: 48))
            textField.backgroundColor = UIColor.rgbColor(rgbValue: 0x2f2f3c)
            textField.layer.cornerRadius = 2
            textField.delegate = self
            textField.placeholder = "输入购买金额"
            textField.text = number
            textField.keyboardType = .numberPad
            textField.font = UIFont.systemFont(ofSize: 14)
            textField.textColor = JXFfffffColor
            textField.attributedPlaceholder = NSAttributedString(string: "输入购买金额", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:JXPlaceHolerColor])
            
            
            textField.leftViewMode = .always
            textField.leftView = {
                let nameLabel = UILabel()
                nameLabel.frame = CGRect(x: 24, y: 20, width: 24, height: 30)
                return nameLabel
            }()
            
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
            return textField
        }()
        leftContentView.addSubview(self.normalTextField)
        
        //1
        let leftLabel1 = UILabel()
        leftLabel1.frame = CGRect(x: 24, y: self.normalTextField.jxBottom + 16, width: 65, height: 51)
        leftLabel1.text = "交易数量"
        leftLabel1.textColor = JXText50Color
        leftLabel1.font = UIFont.systemFont(ofSize: 13)
        leftLabel1.textAlignment = .left
        leftContentView.addSubview(leftLabel1)
        
        self.normalNumLabel = {
            let rightLabel1 = UILabel()
            rightLabel1.frame = CGRect(x: leftLabel1.jxRight, y: leftLabel1.jxTop, width: kScreenWidth - 48 - leftLabel1.jxWidth, height: 51)
            rightLabel1.text = number + " \(configuration_coinName)"
            rightLabel1.textColor = JXTextColor
            rightLabel1.font = UIFont.systemFont(ofSize: 14)
            rightLabel1.textAlignment = .right
            
            return rightLabel1
        }()
        
        leftContentView.addSubview(normalNumLabel)
        
        let line1 = UIView()
        line1.frame = CGRect(x: leftLabel1.jxLeft, y: leftLabel1.jxBottom, width: width, height: 1)
        line1.backgroundColor = JXSeparatorColor
        leftContentView.addSubview(line1)
        
        //2
        let leftLabel2 = UILabel()
        leftLabel2.frame = CGRect(x: 24, y: line1.jxBottom, width: 65, height: 51)
        leftLabel2.text = "交易单价"
        leftLabel2.textColor = JXText50Color
        leftLabel2.font = UIFont.systemFont(ofSize: 13)
        leftLabel2.textAlignment = .left
        leftContentView.addSubview(leftLabel2)
        
        let rightLabel2 = UILabel()
        rightLabel2.frame = CGRect(x: leftLabel2.jxRight, y: leftLabel2.jxTop, width: kScreenWidth - 48 - leftLabel2.jxWidth, height: 51)
        rightLabel2.text = "\(configuration_coinPrice) \(configuration_valueType)"
        rightLabel2.textColor = JXTextColor
        rightLabel2.font = UIFont.systemFont(ofSize: 14)
        rightLabel2.textAlignment = .right
        leftContentView.addSubview(rightLabel2)
        
        let line2 = UIView()
        line2.frame = CGRect(x: leftLabel1.jxLeft, y: leftLabel2.jxBottom, width: width, height: 1)
        line2.backgroundColor = JXSeparatorColor
        leftContentView.addSubview(line2)
        
        
        //3
        let leftLabel3 = UILabel()
        leftLabel3.frame = CGRect(x: 24, y: line2.jxBottom , width: 65, height: 51)
        leftLabel3.text = "交易金额"
        leftLabel3.textColor = JXText50Color
        leftLabel3.font = UIFont.systemFont(ofSize: 13)
        leftLabel3.textAlignment = .left
        leftContentView.addSubview(leftLabel3)
        
        self.normalValueLabel = {
            let rightLabel3 = UILabel()
            rightLabel3.frame = CGRect(x: leftLabel3.jxRight, y: leftLabel3.jxTop, width: kScreenWidth - 48 - leftLabel3.jxWidth, height: 51)
            if let num = Double(number) {
                rightLabel3.text = "\(num * configuration_coinPrice) \(configuration_valueType)"
            } else {
                rightLabel3.text = "\(0) \(configuration_valueType)"
            }
            rightLabel3.textColor = JXRedColor
            rightLabel3.font = UIFont.systemFont(ofSize: 14)
            rightLabel3.textAlignment = .right
            
            return rightLabel3
        }()
        leftContentView.addSubview(normalValueLabel)
        
        let line3 = UIView()
        line3.frame = CGRect(x: leftLabel1.jxLeft, y: leftLabel3.jxBottom, width: width, height: 1)
        line3.backgroundColor = JXSeparatorColor
        leftContentView.addSubview(line3)
        
        
        
        //4
        let leftLabel4 = UILabel()
        leftLabel4.frame = CGRect(x: 24, y: line3.jxBottom, width: 65, height: 51)
        leftLabel4.text = "支付方式"
        leftLabel4.textColor = JXText50Color
        leftLabel4.font = UIFont.systemFont(ofSize: 13)
        leftLabel4.textAlignment = .left
        leftContentView.addSubview(leftLabel4)
        
        let rightLabel4 = UILabel()
        rightLabel4.frame = CGRect(x: leftLabel4.jxRight, y: leftLabel4.jxTop, width: kScreenWidth - 48 - leftLabel4.jxWidth, height: 51)
        if self.buyEntity.payType == 1 {
            rightLabel4.text = "支付宝"
        } else if self.buyEntity.payType == 2 {
            rightLabel4.text = "微信"
        } else if self.buyEntity.payType == 3 {
            rightLabel4.text = "银行卡"
        }
        rightLabel4.textColor = JXTextColor
        rightLabel4.font = UIFont.systemFont(ofSize: 14)
        rightLabel4.textAlignment = .right
        leftContentView.addSubview(rightLabel4)
        
        
        let line4 = UIView()
        line4.frame = CGRect(x: leftLabel1.jxLeft, y: leftLabel4.jxBottom, width: width, height: 1)
        line4.backgroundColor = JXSeparatorColor
        leftContentView.addSubview(line4)
        
        
        let button = UIButton()
        button.frame = CGRect(x: leftLabel1.jxLeft, y: line4.jxBottom + 30, width: width, height: 44)
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
        button.backgroundColor = JXOrangeColor
        
        return contentView
    }
    @objc func confirm1() {
        print("confirm")
        guard let text = self.normalTextField.text, text.isEmpty == false else{
            return
        }
        self.closeStatus1()
        self.showMBProgressHUD()
        self.vm.buyNormal(tradeSaleId: self.buyEntity?.id ?? "", amount: Int(text) ?? 0, completion: { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            if isSuc {
                let vc = OrderDetailController()
                vc.id = self.vm.id
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
//MARK: SelectView - quick buy
extension NewBuyController {
    
    func customViewInit(number: String) -> UIView {
        
        let width : CGFloat = kScreenWidth - 48
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 362)
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 362 + kBottomMaginHeight)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        let leftContentView = UIView()
        leftContentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 362 + kBottomMaginHeight)
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
            button.addTarget(self, action: #selector(closeStatus), for: .touchUpInside)
            view.addSubview(button)
            
            return view
        }()
        leftContentView.addSubview(topBarView)
        
        
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 24, y: topBarView.jxBottom + 20, width: width, height: 30)
        
        if let num = Double(number) {
            nameLabel.text = "\(num * configuration_coinPrice) \(configuration_valueType)"
        }
        nameLabel.textColor = JXTextColor
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        nameLabel.textAlignment = .center
        
        leftContentView.addSubview(nameLabel)
        
        //3
        let leftLabel3 = UILabel()
        leftLabel3.frame = CGRect(x: 24, y: nameLabel.jxBottom + 31, width: 65, height: 51)
        leftLabel3.text = "交易数量"
        leftLabel3.textColor = JXText50Color
        leftLabel3.font = UIFont.systemFont(ofSize: 13)
        leftLabel3.textAlignment = .left
        leftContentView.addSubview(leftLabel3)
        
        let rightLabel3 = UILabel()
        rightLabel3.frame = CGRect(x: leftLabel3.jxRight, y: leftLabel3.jxTop, width: kScreenWidth - 48 - leftLabel3.jxWidth, height: 51)
        rightLabel3.text = number + " \(configuration_coinName)"
        rightLabel3.textColor = JXRedColor
        rightLabel3.font = UIFont.systemFont(ofSize: 14)
        rightLabel3.textAlignment = .right
        leftContentView.addSubview(rightLabel3)
        
        let line3 = UIView()
        line3.frame = CGRect(x: nameLabel.jxLeft, y: leftLabel3.jxBottom, width: width, height: 1)
        line3.backgroundColor = JXSeparatorColor
        leftContentView.addSubview(line3)
        
        
        //4
        let leftLabel4 = UILabel()
        leftLabel4.frame = CGRect(x: 24, y: line3.jxBottom, width: 65, height: 51)
        leftLabel4.text = "支付方式"
        leftLabel4.textColor = JXText50Color
        leftLabel4.font = UIFont.systemFont(ofSize: 13)
        leftLabel4.textAlignment = .left
        leftContentView.addSubview(leftLabel4)
        
        
        let view = UIView(frame: CGRect(x: 24, y: leftLabel4.jxBottom , width: width, height: 32))
        leftContentView.addSubview(view)
        
        self.buttonArray.removeAll()
        
        let buttonSpace: CGFloat = 24
        let buttonWidth = (width - buttonSpace * 2) / 3
        let buttonHeight: CGFloat = 32
        
        for i in 0..<self.vm.buyPayTypeEntity.listArray.count{
            let type = self.vm.buyPayTypeEntity.listArray[i]
            
            let button = UIButton()
            button.frame = CGRect(x: (buttonWidth + buttonSpace) * CGFloat(i), y: 0, width: buttonWidth, height: buttonHeight)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.addTarget(self, action: #selector(payClick(button:)), for: .touchUpInside)
            button.contentHorizontalAlignment = .center
            button.layer.cornerRadius = 2
            button.layer.borderWidth = 1
            
            view.addSubview(button)
            
            button.tag = type
            
            if type == 1 {
                button.setTitle("支付宝", for: .normal)
            } else if type == 2 {
                button.setTitle("微信", for: .normal)
            } else {
                button.setTitle("银行卡", for: .normal)
            }
            button.setTitleColor(JXPlaceHolerColor, for: .normal)
            button.setTitleColor(JXOrangeColor, for: .selected)
            if i == 0 {
                button.isSelected = true
                button.layer.borderColor = JXOrangeColor.cgColor
                
                self.payName = button.currentTitle ?? ""
                self.payType = type
            } else {
                button.layer.borderColor = JXPlaceHolerColor.cgColor
            }
            buttonArray.append(button)
        }
       
        let button = UIButton()
        button.frame = CGRect(x: nameLabel.jxLeft, y: view.jxBottom + 30, width: width, height: 44)
        button.setTitle("下单", for: .normal)
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        leftContentView.addSubview(button)
        
        
        button.layer.cornerRadius = 2
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowColor = JX10101aShadowColor.cgColor
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.backgroundColor = JXOrangeColor
        
        
        
        return contentView
    }
    @objc func confirm() {

        self.closeStatus()
        self.showMBProgressHUD()
        self.vm.buyQuick(payType: self.payType, amount: self.amount, completion: { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            if isSuc {
                self.textField.text = ""
                self.amount = 0
                
                let vc = OrderDetailController()
                vc.id = self.vm.id
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                ViewManager.showNotice(msg)
            }
        })
    }
    @objc func closeStatus() {
        self.statusBottomView.dismiss()
    }
    @objc func payClick(button: UIButton) {
        
        self.buttonArray.forEach { (btn) in
            if button.tag == btn.tag {
                btn.isSelected = true
                btn.layer.borderColor = JXOrangeColor.cgColor
                self.payName = btn.currentTitle ?? ""
                self.payType = btn.tag
            } else {
                btn.isSelected = false
                btn.layer.borderColor = JXPlaceHolerColor.cgColor
            }
        }
    }
}
//MARK:JXBarViewDelegate
extension NewBuyController : JXBarViewDelegate {
    
    func jxBarView(barView: JXBarView, didClick index: Int) {
        self.type = index
        self.collectionView?.mj_header.beginRefreshing()
    }
}
//MARK:UIKeyboardNotification
extension NewBuyController {
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
//MARK:UITextFieldDelegate
extension NewBuyController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @objc func textChange(notify: NSNotification) {
        
        if
            notify.object is UITextField,
            let textField = notify.object as? UITextField,
            textField == self.normalTextField {
            
            
            if
                let num = textField.text,
                let numDouble = Double(num){
                
                self.normalNumLabel.text = num
                self.normalValueLabel.text = "-\(configuration_coinPrice * numDouble) \(configuration_valueType)"
            } else {
                self.normalNumLabel.text = "0"
                self.normalValueLabel.text = "-\(configuration_coinPrice * 0) \(configuration_valueType)"
            }
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //删除键
        if string == "" {
            return true
        }
        //手续费的代扣由后台来扣
        if
            textField == self.normalTextField,
            let num = textField.text,
            let numDouble = Int(num + string), numDouble > self.buyEntity.limitMax{
            
            return false
            
        } else {
            return true
        }
    }
    
}
//MARK:UICollectionViewDataSource & UICollectionViewDelegate
extension NewBuyController {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vm.buyListEntity.listArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MerchantCell
        let entity = self.vm.buyListEntity.listArray[indexPath.item]
        cell.entity = entity
        cell.merchantBlock = {
            self.view.endEditing(true)
            
            let vc = MerchantViewController()
            vc.id = entity.agentId
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.buyBlock = {
            self.view.endEditing(true)
            
            self.buyEntity = entity
            self.statusBottomView1.customView = self.customViewInit1(number: "\(entity.limitMax)", address: "address", gas: "gas", remark: "无")
            self.statusBottomView1.show()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            
        }
    }
}
