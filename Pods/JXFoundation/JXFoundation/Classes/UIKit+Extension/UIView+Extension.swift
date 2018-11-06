//
//  UIView+Extension.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/6/13.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

public extension UIView {
    
    /**
     * Shortcut for frame.origin.x.
     *
     * Sets frame.origin.x = left
     */
    public var jxLeft : CGFloat {
        get{
            return frame.origin.x
        }
    }
    
    /**
     * Shortcut for frame.origin.y
     *
     * Sets frame.origin.y = top
     */
    public var jxTop : CGFloat {
        get{
            return frame.origin.y
        }
    }
    
    /**
     * Shortcut for frame.origin.x + frame.size.width
     *
     * Sets frame.origin.x = right - frame.size.width
     */
    public var jxRight : CGFloat {
        get{
            return frame.origin.x + frame.size.width
        }
    }
    
    /**
     * Shortcut for frame.origin.y + frame.size.height
     *
     * Sets frame.origin.y = bottom - frame.size.height
     */
    public var jxBottom : CGFloat {
        get{
            return frame.origin.y + frame.size.height
        }
    }
    
    /**
     * Shortcut for frame.size.width
     *
     * Sets frame.size.width = width
     */
    public var jxWidth : CGFloat {
        get{
            return frame.size.width
        }
    }
    
    /**
     * Shortcut for frame.size.height
     *
     * Sets frame.size.height = height
     */
    public var jxHeight : CGFloat {
        get{
            return frame.size.height
        }
    }
    
    /**
     * Shortcut for center.x
     *
     * Sets center.x = centerX
     */
    public var jxCenter : CGPoint {
        get{
            return center
        }
    }
    /**
     * Shortcut for center.x
     *
     * Sets center.x = centerX
     */
    public var jxCenterX : CGFloat {
        get{
            return center.x
        }
    }
    
    /**
     * Shortcut for center.y
     *
     * Sets center.y = centerY
     */
    public var jxCenterY : CGFloat {
        get{
            return center.y
        }
    }
    /**
     * Shortcut for frame.origin
     */
    var jxOrigin : CGPoint {
        get{
            return frame.origin
        }
    }
    
    /**
     * Shortcut for frame.size
     */
    var jxSize : CGSize {
        get{
            return frame.size
        }
    }
    
}

public extension UIView {
    public func removeAllSubView() {
        
        for view in subviews {
            let v = view
            
            if v is UIImageView {
                let v = view as! UIImageView
                v.image = nil
            }
            
            v.removeFromSuperview()
            //v = nil
        }
    }
}
