//
//  String+Extension.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/21.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

extension String {
    func addPrefix0x() -> String {
        if self.hasPrefix("0x") {
            return self
        } else {
            return "0x" + self
        }
    }
    func removePrefix0x() -> String {
        if self.hasPrefix("0x") {
            let str = String(self.suffix(from: self.index(self.startIndex, offsetBy: 2)))
            return str
        } else {
            return self
        }
    }
}
