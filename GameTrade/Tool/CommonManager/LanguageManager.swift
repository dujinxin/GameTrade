
//
//  LanguageManager.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/7/18.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import Foundation

class LanguageManager {
    static let manager = LanguageManager()
    
    private init() {
        
    }
    
    func localizedString(_ string : String) -> String {
        guard string.isEmpty == false else{
            return ""
        }
        let s = Bundle.main.localizedString(forKey: string, value: nil, table: nil)
        //let s = NSLocalizedString(string, comment: "")
        return s
    }
    static func localizedString(_ string : String) -> String {
        return self.manager.localizedString(string)
    }
}
		
