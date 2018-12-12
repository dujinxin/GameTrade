//
//  AppDelegate.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/9/28.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

import ChatCamp
import UserNotifications

import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var settingVM = SettingVM()
    var noticeView : JXSelectView?

    var groupChannelId = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Fabric.with([Crashlytics.self])

        print(ConfigurationManager.manager.userEntity.baseUrl)
        
        setupChatCampSDK()
        
        initializeNotificationServices()
        CCPClient.addChannelDelegate(channelDelegate: self, identifier: AppDelegate.string())
        routeUser()
        
        
        
        let downloader = SDWebImageDownloader.shared()

        downloader.setValue(UIDevice.current.uuid, forHTTPHeaderField: "deviceId")
        downloader.setValue(UIDevice.current.modelName, forHTTPHeaderField: "device")
        downloader.setValue(UIDevice.current.systemName, forHTTPHeaderField: "os")
        downloader.setValue(Bundle.main.version, forHTTPHeaderField: "version")
        downloader.setValue(kVersion, forHTTPHeaderField: "appVersion")
        downloader.setValue(configuration_merchantID, forHTTPHeaderField: "mertId")
        
        
//        self.settingVM.version(2) { (_, msg, isSuc) in
//            if isSuc {
//                self.showNoticeView()
//            }
//        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        CCPClient.disconnect { _ in
            CCPClient.addConnectionDelegate(connectionDelegate: self, identifier: AppDelegate.string())
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if let userID = UserDefaults.standard.userID() {
            CCPClient.connect(uid: userID) { (_, _) in }
        }
//        self.settingVM.version(2) { (_, msg, isSuc) in
//            if isSuc {
//                self.showNoticeView()
//            }
//        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func initializeNotificationServices() -> Void {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization( options: authOptions, completionHandler: {_, _ in })
            
            // This is an asynchronous method to retrieve a Device Token
            // Callbacks are in AppDelegate.swift
            // Success = didRegisterForRemoteNotificationsWithDeviceToken
            // Fail = didFailToRegisterForRemoteNotificationsWithError
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            // Fallback on earlier versions
        }
        
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        UserDefaults.standard.setDeviceToken(deviceToken: token)
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Device token for push notifications: FAIL -- ")
        print(error)
    }
}

// MARK - Setup
extension AppDelegate {
    fileprivate func setupChatCampSDK() {
        //CCPClient.initApp(appId: "6346990561630613504")
        
        CCPClient.initApp(appId: kIM_AppID)
    }
    fileprivate func routeUser() {
        if let userID = UserManager.manager.userEntity.id {
            //登录聊天
            CCPClient.connect(uid: userID) { [unowned self] (user, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLoginStatus), object: false)
                    } else {
                        if let deviceToken = UserDefaults.standard.deviceToken() {
                            CCPClient.updateUserPushToken(token: deviceToken) { (_,_) in
                                print("update device token on the server.")
                            }
                        }
                        CCPClient.getTotalUnreadMessageCount { (num, param, error) in
                            
                            if let _ = error {
                                print(error?.localizedDescription)
                            } else {
                                print(num,param)
                                guard let tabVC = UIApplication.shared.keyWindow?.rootViewController as? TabBarViewController else { return }
                                if let n = num, n > 0 {
                                    tabVC.isUnreadMessagePoint(hidden: false)
                                } else {
                                    tabVC.isUnreadMessagePoint(hidden: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK:- CCPChannelDelegate
extension AppDelegate: CCPChannelDelegate {
    func channelDidReceiveMessage(channel: CCPBaseChannel, message: CCPMessage) {
        if CCPClient.getCurrentUser().getId() != message.getUser().getId() && channel.getId() != currentChannelId && channel.isGroupChannel() {
            
            guard let tabVC = UIApplication.shared.keyWindow?.rootViewController as? TabBarViewController else { return }
            tabVC.isUnreadMessagePoint(hidden: false)
            
//            let center = UNUserNotificationCenter.current()
//            center.delegate = self
//
//            let content = UNMutableNotificationContent()
//            content.title = message.getUser().getDisplayName() ?? ""
//            content.sound = UNNotificationSound.default()
//            content.userInfo = ["channelId": channel.getId()]
//            let messageType = message.getType()
//            if messageType == "attachment" {
//                content.body = "Attachment Received"
//            } else {
//                content.body = message.getText()
//            }
//
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.01, repeats: false)
//            let request = UNNotificationRequest(identifier: message.getId(), content: content, trigger: trigger)
//
//            center.add(request) { (error) in
//                if error != nil {
//                    print("error \(String(describing: error))")
//                }
//            }
        }
    }
    
    func channelDidChangeTypingStatus(channel: CCPBaseChannel) { }
    
    func channelDidUpdateReadStatus(channel: CCPBaseChannel) { }
    
    func channelDidUpdated(channel: CCPBaseChannel) { }
    
    func onTotalGroupChannelCount(count: Int, totalCountFilterParams: TotalCountFilterParams) { }
    
    func onGroupChannelParticipantJoined(groupChannel: CCPGroupChannel, participant: CCPUser) { }
    
    func onGroupChannelParticipantLeft(groupChannel: CCPGroupChannel, participant: CCPUser) { }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? [String: Any], let channelId = userInfo["channelId"] as? String {
            groupChannelId = channelId
            if !(response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? true) {
                let userID = CCPClient.getCurrentUser().getId()
                let username = CCPClient.getCurrentUser().getDisplayName()
                
                let sender = Sender(id: userID, displayName: username!)
                CCPGroupChannel.get(groupChannelId: self.groupChannelId) {(groupChannel, error) in
                    if let channel = groupChannel {
                        let chatViewController = ChatViewController(channel: channel, sender: sender)
                        //let homeTabBarController = UIViewController.homeTabBarNavigationController()
                        //WindowManager.shared.window.rootViewController = homeTabBarController
                        //homeTabBarController.pushViewController(chatViewController, animated: true)
                        
                        
//                        let storyboard = UIStoryboard(name: "Login", bundle: nil)
//                        let login = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
//                        let loginVC = UINavigationController.init(rootViewController: login)
//                        if self.selectedViewController is UINavigationController {
//                            let selectVC = self.selectedViewController as! UINavigationController
//                            let topVC = selectVC.topViewController
//                            if let modelVC = topVC?.navigationController?.visibleViewController {
//                                modelVC.dismiss(animated: false, completion: nil)
//                            }
//                            topVC?.navigationController?.popToRootViewController(animated: false)
//                            topVC!.navigationController?.present(loginVC, animated: true, completion: nil)
//                        }else{
//                            self.selectedViewController?.navigationController?.present(login, animated: true, completion: nil)
//                        }
                    }
                }
            }
        }
        
        completionHandler()
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge]) //required to show notification when in foreground
    }
}

extension AppDelegate: CCPConnectionDelegate {
    func connectionDidChange(isConnected: Bool) {
        CCPClient.removeConnectionDelegate(identifier: AppDelegate.string())
        if isConnected && !groupChannelId.isEmpty {
            DispatchQueue.main.async {
                let userID = CCPClient.getCurrentUser().getId()
                let username = CCPClient.getCurrentUser().getDisplayName()
                
                let sender = Sender(id: userID, displayName: username!)
                CCPGroupChannel.get(groupChannelId: self.groupChannelId) {(groupChannel, error) in
                    if let channel = groupChannel {
                        let chatViewController = ChatViewController(channel: channel, sender: sender)
                        let homeTabBarController = UIViewController.homeTabBarNavigationController()
                        //WindowManager.shared.window.rootViewController = homeTabBarController
                        //homeTabBarController.pushViewController(chatViewController, animated: true)
                    }
                }
            }
        }
    }
}
//MARK: version notice
extension AppDelegate {
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
            contentView.addSubview(backgroundView)
            
            let gradientLayer = CAGradientLayer.init()
            gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
            gradientLayer.locations = [0]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
            gradientLayer.cornerRadius = 5
            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            
            
            
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
