//
//  PaperDetailController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/24.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import QuickLook

class PaperDetailController: JXTableViewController {
    
    let vm = PaperVM()
    
    var id : String?
    
    var url : URL?
    
    var process : String = "0/0"
    
    var navigationBar : UIView?
    var backgroundView : UIView?
    var titleView : UILabel?
    var leftItem : UIButton?
    
    lazy var bottomView: UIView = {
        let contentView = UIView()
        contentView.addSubview(self.checkButton)
        contentView.addSubview(self.infoButton)
        return contentView
    }()
    lazy var checkButton: UIButton = {
        let button = UIButton()

        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.setTitle("交易完整论文", for: UIControlState.normal)
        button.addTarget(self, action: #selector(clickAction(button:)), for: UIControlEvents.touchUpInside)
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 100, height: 44)
        gradientLayer.cornerRadius = 22
        button.layer.insertSublayer(gradientLayer, at: 0)
        
        return button
    }()
    lazy var infoButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(UIColor.rgbColor(rgbValue: 0x1296db), for: UIControlState.normal)
        button.setTitle("交易详情将被IPXE区块链记录，首次交易的永久智慧值！", for: UIControlState.normal)
        button.setImage(#imageLiteral(resourceName: "Shape"), for: .normal)
        return button
    }()
    lazy var tradeBottomView: JXSelectView = {
        let selectView = JXSelectView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 200), style: JXSelectViewStyle.custom)
        
        selectView.topBarView = {
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 260))
            view.backgroundColor = JX999999Color
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 59.5)
            label.backgroundColor = UIColor.white
            //label.center = view.center
            label.text = "确认交易"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = JX333333Color
            view.addSubview(label)
            //label.sizeToFit()
            
            let button = UIButton()
            button.frame = CGRect(x: 10, y: 8.5, width: 40, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            //button.setTitle("×", for: .normal)
            button.setImage(#imageLiteral(resourceName: "Close"), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.setTitleColor(JX333333Color, for: .normal)
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = .center
            button.addTarget(self, action: #selector(closeTrade), for: .touchUpInside)
            view.addSubview(button)
            
            return view
        }()
        selectView.isUseCustomTopBar = true
        //
        let width : CGFloat = kScreenWidth - 70

        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 260 - 42)
        contentView.backgroundColor = UIColor.white
        
        let backView = UIView()
        backView.frame = CGRect(x: 35, y: 0, width: width, height: 260)
        backView.backgroundColor = UIColor.white
        contentView.addSubview(backView)
        
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 35, y: 20, width: width, height: 15)
        titleLabel.text = "交易该论文完整版"
        titleLabel.textColor = UIColor.rgbColor(rgbValue: 0x3b4358)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        
        contentView.addSubview(titleLabel)
        
        let line1 = UIView()
        line1.frame = CGRect(x: 35, y: titleLabel.jxBottom + 20, width: width, height: 1)
        line1.backgroundColor = UIColor.groupTableViewBackground
        contentView.addSubview(line1)
        
        let reduceLabel = UILabel()
        reduceLabel.frame = CGRect(x: 80, y: line1.jxBottom + 15, width: width - 90, height: 12)
        reduceLabel.text = "你的资产将减少"
        reduceLabel.textColor = UIColor.rgbColor(rgbValue: 0x979ebf)
        reduceLabel.textAlignment = .center
        reduceLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(reduceLabel)
        
        let reduceNumLabel = UILabel()
        reduceNumLabel.frame = CGRect(x: 35, y: reduceLabel.jxBottom + 10, width: width, height: 20)
        reduceNumLabel.text = "\(self.vm.paperDetailEntity.paperEntity.tradePrice)"
        reduceNumLabel.textColor = UIColor.rgbColor(rgbValue: 0x3b4358)
        reduceNumLabel.font = UIFont.systemFont(ofSize: 20)
        reduceNumLabel.textAlignment = .center
        
        contentView.addSubview(reduceNumLabel)
        
        
//        let addLabel = UILabel()
//        addLabel.frame = CGRect(x: 80, y: reduceNumLabel.jxBottom + 10, width: width - 90, height: 12)
//        addLabel.text = "智慧值将永久"
//        addLabel.textColor = UIColor.rgbColor(rgbValue: 0x979EBF)
//        addLabel.textAlignment = .center
//        addLabel.font = UIFont.systemFont(ofSize: 12)
//        contentView.addSubview(addLabel)
//
//        let addNumLabel = UILabel()
//        addNumLabel.frame = CGRect(x: 35, y: addLabel.jxBottom + 10, width: width, height: 20)
//        addNumLabel.text = "+\(self.vm.paperDetailEntity.power)"
//        addNumLabel.textColor = UIColor.rgbColor(rgbValue: 0x3b4358)
//        addNumLabel.font = UIFont.systemFont(ofSize: 20)
//        addNumLabel.textAlignment = .center
//
//        contentView.addSubview(addNumLabel)
        
        
        let line2 = UIView()
        line2.frame = CGRect(x: 35, y: reduceNumLabel.jxBottom + 15, width: width, height: 1)
        line2.backgroundColor = UIColor.groupTableViewBackground
        contentView.addSubview(line2)
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: line2.jxBottom + 20, width: 114, height: 36)
        button.setTitle("确认", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(tradePaper), for: .touchUpInside)
        contentView.addSubview(button)
        button.center = CGPoint(x: reduceNumLabel.center.x, y: button.center.y)
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 114, height: 36)
        gradientLayer.cornerRadius = 18
        
        button.layer.insertSublayer(gradientLayer, at: 0)
        
        selectView.customView = contentView
        
        return selectView
    }()
    lazy var statusBottomView: JXSelectView = {
        let selectView = JXSelectView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 200), style: JXSelectViewStyle.custom)
        
        selectView.topBarView = {
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 260))
            view.backgroundColor = JX999999Color
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 59.5)
            label.backgroundColor = UIColor.white
            //label.center = view.center
            label.text = "交易成功"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = JX333333Color
            view.addSubview(label)
            //label.sizeToFit()
            
            let button = UIButton()
            button.frame = CGRect(x: 10, y: 8.5, width: 40, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            //button.setTitle("×", for: .normal)
            button.setImage(#imageLiteral(resourceName: "Close"), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.setTitleColor(JX333333Color, for: .normal)
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = .center
            button.addTarget(self, action: #selector(closeStatus), for: .touchUpInside)
            view.addSubview(button)
            
            return view
        }()
        selectView.isUseCustomTopBar = true
        //
        let width : CGFloat = kScreenWidth - 70
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 260)
        contentView.backgroundColor = UIColor.white
        
        let backView = UIView()
        backView.frame = CGRect(x: 35, y: 0, width: width, height: 260)
        backView.backgroundColor = UIColor.white
        contentView.addSubview(backView)
        
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 35, y: 20, width: width, height: 15)
        titleLabel.text = "可在 【我的】—【交易】查看"
        titleLabel.textColor = UIColor.rgbColor(rgbValue: 0x3b4358)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        
        contentView.addSubview(titleLabel)
        
        let line1 = UIView()
        line1.frame = CGRect(x: 35, y: titleLabel.jxBottom + 20, width: width, height: 1)
        line1.backgroundColor = UIColor.groupTableViewBackground
        contentView.addSubview(line1)
        
        let successImageView = UIImageView()
        successImageView.image = #imageLiteral(resourceName: "successIcon")
        successImageView.frame = CGRect(x: 0, y: line1.jxBottom + 15, width: 85, height: 85)
        contentView.addSubview(successImageView)
        successImageView.center = CGPoint(x: contentView.center.x, y: successImageView.jxCenterY)
        
        let line2 = UIView()
        line2.frame = CGRect(x: 35, y: successImageView.jxBottom + 15, width: width, height: 1)
        line2.backgroundColor = UIColor.groupTableViewBackground
        contentView.addSubview(line2)
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: line2.jxBottom + 20, width: 114, height: 36)
        button.setTitle("立即查看", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(showTradeDetail), for: .touchUpInside)
        contentView.addSubview(button)
        button.center = CGPoint(x: contentView.center.x, y: button.center.y)
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 114, height: 36)
        gradientLayer.cornerRadius = 18
        
        button.layer.insertSublayer(gradientLayer, at: 0)
        
        selectView.customView = contentView
        
        return selectView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .default
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.customNavigationBar.removeFromSuperview()
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "imgBack"), for: .normal)
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(5, 9, 5, 9)
        leftButton.addTarget(self, action: #selector(backTo), for: .touchUpInside)
        
        self.navigationBar = self.setClearNavigationBar(title: "论文详情", leftItem: leftButton)
        self.view.addSubview(navigationBar!)
        
        self.tableView?.backgroundColor = UIColor.white
        self.tableView?.contentInset = UIEdgeInsetsMake(kNavStatusHeight, 0, 0, 0)
        self.tableView?.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - (64 + 60 + kBottomMaginHeight))
        self.tableView?.separatorStyle = .none
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.register(UINib(nibName: "PaperDetailTopCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierTop")
        self.tableView?.register(UINib(nibName: "PaperDetailCommonCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierCommon")
        
        self.view.addSubview(self.bottomView)
        self.bottomView.frame = CGRect(x: 0, y: (self.tableView?.jxBottom)!, width: view.bounds.width, height: kScreenHeight - (self.tableView?.jxHeight)!)
        self.checkButton.frame = CGRect(x: 50, y: 20, width: kScreenWidth - 100, height: 44)
        self.infoButton.frame = CGRect(x: 5, y: self.checkButton.jxBottom + 20, width: kScreenWidth - 10, height: 20)
        
        self.requestData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    func setClearNavigationBar(title:String,leftItem:UIView,rightItem:UIView? = nil) -> UIView {
        
        let navigiationBar = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavStatusHeight))
        navigationBar?.backgroundColor = UIColor.clear
        
        self.backgroundView = UIView(frame: navigiationBar.bounds)
        self.backgroundView?.backgroundColor = UIColor.white
        
        self.titleView = UILabel(frame: CGRect(x: 80, y: kStatusBarHeight, width: kScreenWidth - 160, height: 44))
        titleView?.text = title
        titleView?.textColor = UIColor.black
        titleView?.textAlignment = .center
        titleView?.font = UIFont.systemFont(ofSize: 17)
        
        self.leftItem = leftItem as? UIButton
        self.leftItem?.frame = CGRect(x: 10, y: kStatusBarHeight + 7, width: 30, height: 30)
        self.leftItem?.setTitleColor(UIColor.black, for: .normal)
        self.leftItem?.setImage(UIImage(named: "imgBack")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.leftItem?.tintColor = UIColor.black
        
        navigiationBar.addSubview(self.backgroundView!)
        navigiationBar.addSubview(self.titleView!)
        
        navigiationBar.addSubview(self.leftItem!)
        if let right = rightItem {
            right.frame = CGRect(x: kScreenWidth - 10 - 30, y: kStatusBarHeight + 7, width: 30, height: 30)
            navigiationBar.addSubview(right)
        }
        return navigiationBar
        
    }
    @objc func backTo() {
        self.navigationController?.popViewController(animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            self.view.endEditing(true)
        }
        let yOffset = scrollView.contentOffset.y
        //print(yOffset)
        if yOffset <= 0 {
            //self.customNavigationBar.barTintColor = UIColor.orange
            //self.customNavigationBar.alpha = 0
            self.backgroundView?.alpha = 1
            self.titleView?.text = "论文详情"
            self.leftItem?.setImage(UIImage(named: "imgBack")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.leftItem?.tintColor = UIColor.black
            self.leftItem?.imageEdgeInsets = UIEdgeInsetsMake(5, 9, 5, 9)
        }else if yOffset >= kNavStatusHeight{
            //self.customNavigationBar.alpha = 1
            self.backgroundView?.alpha = 0
            self.titleView?.text = ""
            self.leftItem?.setImage(UIImage(named: "iconBackBlackbg"), for: .normal)
            self.leftItem?.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }else{
            //self.customNavigationBar.alpha = fabs(fabs(yOffset) - kNavStatusHeight) / kNavStatusHeight
            self.backgroundView?.alpha = fabs(fabs(yOffset) - kNavStatusHeight) / kNavStatusHeight
        }
    }
    override func requestData() {
        
        self.vm.paperDetails(self.id!) { (_, msg, isSuc) in
            if isSuc {
                self.tableView?.reloadData()
                if self.vm.paperDetailEntity.paperEntity.payed == 1 {
                    self.checkButton.setTitle("查看完整论文(\(self.vm.paperDetailEntity.paperEntity.thesisSize ?? "0.01")MB)", for: .normal)
                } else {
                    self.checkButton.setTitle("(\(self.vm.paperDetailEntity.paperEntity.tradePrice) IPE)交易完整论文", for: .normal)
                }
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
    @objc func clickAction(button: UIButton) {

        if self.vm.paperDetailEntity.paperEntity.payed == 1 {
            self.showMBProgressHUD()
            //下载
            self.vm.paperDownload(self.vm.paperDetailEntity.paperEntity.downloadUrl!, process: { (progress) in
                print(progress.completedUnitCount,"/",progress.totalUnitCount)
            }) { (isSuc, url) in
                print("download ",isSuc)
                self.hideMBProgressHUD()
  
                self.url = url
                
                let vc  = QLPreviewController.init()
                vc.navigationController?.navigationBar.tintColor = UIColor.black
                vc.delegate = self
                vc.dataSource = self
                self.present(vc, animated: true) {
                    
                }
            }
        } else {
            self.tradeBottomView.show()
        }
    }
    @objc func tradePaper() {
        self.closeTrade()
        self.showMBProgressHUD()
        //购买
        self.vm.paperTrade(self.id!) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            
            if isSuc {
                self.statusBottomView.show()
                self.requestData()
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
    @objc func closeTrade() {
        self.tradeBottomView.dismiss()
    }
    @objc func showTradeDetail() {
        self.closeStatus()
 
//        let vc = TradeDetailController()
//        //vc.id = self.vm.paperTradeEntity.tradeId ?? ""
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func closeStatus() {
        self.statusBottomView.dismiss()
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.vm.detailList.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIndetifier = (indexPath.row == 0) ? "reuseIdentifierTop" : "reuseIdentifierCommon"
 
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIndetifier, for: indexPath) as! PaperDetailTopCell
            cell.selectionStyle = .none
            
            cell.titleView.text = self.vm.paperDetailEntity.paperEntity.title
            cell.sourceView.text = self.vm.paperDetailEntity.paperEntity.source
            cell.tradeView.text = "交易量：\(self.vm.paperDetailEntity.paperEntity.tradeCount)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIndetifier, for: indexPath) as! PaperDetailCommonCell
            cell.selectionStyle = .none
            
            let entity = self.vm.detailList[indexPath.row - 1]
            cell.entity = entity
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if let entity = sender as? ArticleEntity, identifier == "articleDetail" {
            let vc = segue.destination as! ArticleDetailsController
            vc.articleEntity = entity
        }
    }
    
}
extension PaperDetailController : QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        //let item = urls[index] as QLPreviewItem
        guard let url = self.url else {
            return URL.init(string: "")! as QLPreviewItem
        }
        let item = url as QLPreviewItem
        return item
    }
}
