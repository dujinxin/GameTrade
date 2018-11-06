//
//  EthUnit.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/23.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation
import BigInt

// Online Converter: https://etherconverter.online

/*
 以太币的最小单位为wei，1个eth相当于10的18次方wei。通常，大家也使用Gwei作为展示单位。比较常用的就是eth，Gwei和wei。
 
 单位                       wei值                    Wei
 wei                       1                        1 wei
 Kwei (babbage)            1e3 wei                  1,000
 Mwei (lovelace)           1e6 wei                  1,000,000
 Gwei (shannon)            1e9 wei                  1,000,000,000
 microether (szabo)        1e12 wei                 1,000,000,000,000
 milliether (finney)       1e15 wei                 1,000,000,000,000,000
 ether                     1e18 wei                 1,000,000,000,000,000,000
 
 */
struct EthUnit {
    
    typealias Wei = BigInt
    typealias GWei = BigInt
    typealias Ether = Decimal
    
    static let weiUnit = pow(Decimal.init(10), 0)
    static let KweiUnit = pow(Decimal.init(10), 3)
    static let MweiUnit = pow(Decimal.init(10), 6)
    static let GweiUnit = pow(Decimal.init(10), 9)
    static let microetherUnit = pow(Decimal.init(10), 12)
    static let millietherUnit = pow(Decimal.init(10), 15)
    static let etherUnit = pow(Decimal.init(10), 18)
    
    /// ether to Wei
    ///
    /// - Parameter ether: Decimal value
    /// - Returns: BigInt
    static func etherToWei(ether:Ether) -> Wei {
        let weiDecimal = ether * EthUnit.etherUnit
        guard let wei = Wei.init(weiDecimal.description) else {
            fatalError("Decimal.CalculationError")
        }
        return wei
    }
    /// ether to Gwei
    ///
    /// - Parameter ether: Decimal value
    /// - Returns: BigInt
    static func etherToGwei(ether:Ether) -> GWei {
        let GweiDecimal = ether * EthUnit.etherUnit / EthUnit.GweiUnit
        guard let gwei = Wei.init(GweiDecimal.description) else {
            fatalError("Decimal.CalculationError")
        }
        return gwei
    }
    /// Wei to ether
    ///
    /// - Parameter wei: BigInt
    /// - Returns: Decimal value
    static func weiToEther(wei:Wei) -> Ether {
        guard let weiDecimal = Decimal.init(string: wei.description) else {
            fatalError("Decimal.CalculationError")
        }
        let etherDecimal = weiDecimal / EthUnit.etherUnit
        return etherDecimal
    }
    //plain, 四舍五入; down, 只舍不入; up, 只入不舍; bankers 四舍六入, 中间值时, 取最近的,保持保留最后一位为偶数
    /// 处理小数位数
    ///
    /// - Parameters:
    ///   - decimal: 要处理的decimal
    ///   - scale: 保留几位小数
    /// - Returns: 处理之后的decimal
    static func decimalNumberHandler(_ decimal: Decimal, scale: Int16 = 6) -> NSDecimalNumber {
        let num = NSDecimalNumber.init(decimal: decimal)
        let handler = NSDecimalNumberHandler.init(roundingMode: .down, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let res = num.rounding(accordingToBehavior: handler)
        return res
    }
}
