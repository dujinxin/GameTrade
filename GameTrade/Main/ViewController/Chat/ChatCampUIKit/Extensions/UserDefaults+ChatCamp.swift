//
//  UserDefaults+ChatCamp.swift
//  ChatCamp Demo
//
//  Created by Tanmay Khandelwal on 13/02/18.
//  Copyright © 2018 iFlyLabs Inc. All rights reserved.
//

import Foundation

extension UserDefaults {
    enum Keys: String {
        case userIDKey = "userIDKey"
        case usernameKey = "usernameKey"
        case deviceTokenKey = "deviceTokenKey"
    }
    
    public func userID() -> String? {
        return string(forKey: Keys.userIDKey.rawValue)
    }
    
    public func setUserID(userID: String?) {
        set(userID, forKey: Keys.userIDKey.rawValue)
    }
    
    public func username() -> String? {
        return string(forKey: Keys.usernameKey.rawValue)
    }
    
    public func setUsername(username: String?) {
        set(username, forKey: Keys.usernameKey.rawValue)
    }
    
    public func deviceToken() -> String? {
        return string(forKey: Keys.deviceTokenKey.rawValue)
    }
    
    public func setDeviceToken(deviceToken: String?) {
        set(deviceToken, forKey: Keys.deviceTokenKey.rawValue)
    }
}
