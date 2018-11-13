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

    var groupChannelId = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Fabric.with([Crashlytics.self])
        
        setupChatCampSDK()
        
        setupAppearances()
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
        
        CCPClient.initApp(appId: "6456046490195324928")
    }
    
    fileprivate func setupAppearances() {
        UINavigationBar.appearance().tintColor = UIColor(red: 63/255, green: 81/255, blue: 180/255, alpha: 1.0)
    }
    
    fileprivate func routeUser() {
        if let userID = UserDefaults.standard.userID() {
            CCPClient.connect(uid: userID) { (user, error) in
                DispatchQueue.main.async {
                    if error == nil {
                        if let deviceToken = UserDefaults.standard.deviceToken() {
                            CCPClient.updateUserPushToken(token: deviceToken) { (_,_) in
                                print("update device token on the server.")
                            }
                        }
                        //WindowManager.shared.prepareWindow(isLoggedIn: true)
                    } else {
                        //WindowManager.shared.prepareWindow(isLoggedIn: false)
                    }
                }
            }
        } else {
            //WindowManager.shared.prepareWindow(isLoggedIn: false)
        }
    }
}

// MARK:- CCPChannelDelegate
extension AppDelegate: CCPChannelDelegate {
    func channelDidReceiveMessage(channel: CCPBaseChannel, message: CCPMessage) {
        if CCPClient.getCurrentUser().getId() != message.getUser().getId() && channel.getId() != currentChannelId && channel.isGroupChannel() {
            
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            
            let content = UNMutableNotificationContent()
            content.title = message.getUser().getDisplayName() ?? ""
            content.sound = UNNotificationSound.default()
            content.userInfo = ["channelId": channel.getId()]
            let messageType = message.getType()
            if messageType == "attachment" {
                content.body = "Attachment Received"
            } else {
                content.body = message.getText()
            }
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.01, repeats: false)
            let request = UNNotificationRequest(identifier: message.getId(), content: content, trigger: trigger)
            
            center.add(request) { (error) in
                if error != nil {
                    print("error \(String(describing: error))")
                }
            }
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
