//
//  SellCollectionController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/16.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

class SellCollectionController: JXCollectionViewController {
    
    var vm = SellVM()
    var payVM = PayVM()
    var noticeView : JXSelectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我要卖"
        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(sell))
        
        self.collectionView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        // Register cell classes
        self.collectionView?.register(UINib.init(nibName: "SellCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = CGSize(width: kScreenWidth - 48, height: 85)
        
        layout.sectionInset = UIEdgeInsets.init(top: 8, left: 24, bottom: 8, right: 24)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
     
        self.collectionView?.collectionViewLayout = layout
        
        self.collectionView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request(page: 1)
        })
//        self.collectionView?.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
//            self.page += 1
//            self.request(page: self.page)
//        })
        self.collectionView?.mj_header.beginRefreshing()
        
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
        switch segue.identifier {
        case "putUp":
            if let vc = segue.destination as? PutUpViewController, let entity = sender as? SellInfoEntity {
                vc.sellInfoEntity = entity
                vc.backBlock = {
                    self.collectionView?.mj_header.beginRefreshing()
                }
            }
        default:
            print("123456")
        }
    }
    @objc func sell() {
        
        self.vm.sellInfo { (_, msg, isSuc) in
            if isSuc {
                if self.vm.sellInfoEntity.list.count > 0 {
                    self.performSegue(withIdentifier: "putUp", sender: self.vm.sellInfoEntity)
                } else {
                    self.showNoticeView()
                }
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
    @objc func loginStatus(notify:Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true{
            self.collectionView?.mj_header.beginRefreshing()
        }
    }
    override func request(page: Int) {
        self.vm.sellList{ (_, msg, isSuc) in
            self.hideMBProgressHUD()
            self.collectionView?.mj_header.endRefreshing()
            //self.collectionView?.mj_footer.endRefreshing()
            self.collectionView?.reloadData()
        }
    }
    
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
            nameLabel.text = "您还未添加收款方式"
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
        
        let vc = PayListController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension SellCollectionController {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.vm.sellListEntity.listArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SellCell
        let entity = self.vm.sellListEntity.listArray[indexPath.item]
        cell.entity = entity
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
