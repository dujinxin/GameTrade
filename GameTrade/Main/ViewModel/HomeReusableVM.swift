//
//  HomeReusableVM.swift
//  Star
//
//  Created by 杜进新 on 2018/7/15.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class HomeReusableVM: BaseViewModel {
    
    var diamondArray = Array<DiamondEntity>()
    var power : Int = 0
    var ipe : Double = 0
    
    var frameArray = [CGRect]()
    
    init(entity: HomeEntity) {
//        self.diamondArray = entity.diamondArray
//        self.power = entity.power
//        self.ipe = entity.ipe
//
//
        super.init()
        
        let array = self.diamondArray.prefix(8)
        self.randomRect(number: array.count)
    }
    
    //由于同一个视图在动画过程中不响应点击事件，这里的做法是给父视图添加点击事件，而给子视图添加动画
    /// 水晶随机分布在一个固定矩形区域,水晶带有上下移动的动画
    ///
    /// - Parameter array: 水晶数组
    func randomRect(number:Int) {
        if number <= 0 {
            self.frameArray = []
            return
        }
        //self.frameArray.removeAll()
        var array = Array<CGRect>()
        
        let imageHeight : CGFloat = 52 * 167 / 156
        let labelHeight : CGFloat = 20
        //水晶+数字 宽高
        let crystalViewWidth : CGFloat = 52
        let crystalViewHeight = imageHeight + 20
        
        //动画区域
        let animateWidth :CGFloat = 0
        let animateHeight :CGFloat = 5 + 5 //上下各5
        
        //margin
        let marginLeft : CGFloat  = 30
        let marginRight : CGFloat = 30
        let marginTop : CGFloat = 0
        let marginBottom : CGFloat = 0
        
        //content区域
        let contentWidth : CGFloat = kScreenWidth
        let contentHeight : CGFloat = kScreenHeight - kTabBarHeight - 120 - kStatusBarHeight - 84
        
        //origin可随机区域 width = contentView.width - crystalView.width - animateWidth - marginLeft - marginRight
        let origin_x = contentWidth - crystalViewWidth - animateWidth - marginLeft - marginRight
        //origin可随机区域 width = contentView.height - crystalView.height - animateHeight - marginTop - marginBottom
        let origin_y = contentHeight - crystalViewHeight - animateHeight - marginTop - marginBottom
        
        for i in 0..<number {
            
            var frame = CGRect()
            
            var isIntersects = true
            repeat{
                
                let x = arc4random_uniform(UInt32(origin_x))
                let y = arc4random_uniform(UInt32(origin_y))
                frame = CGRect(x: CGFloat(x) + marginLeft , y: CGFloat(y) + marginTop, width: crystalViewWidth, height: crystalViewHeight)
                if i == 0 {
                    //print("第一个视图一定没有交集")
                    isIntersects = false
                } else {
                    isIntersects = false
                    for rect in array {
                        //与已存在的子视图没有交集，方可添加
                        if rect.intersects(frame) == true {
                            //print("有交集")
                            isIntersects = true
                            break
                        }
                    }
                }
                
            }while(isIntersects)
            //print("没有交集")
            array.append(frame)
        }
        self.frameArray = array
    }
}
