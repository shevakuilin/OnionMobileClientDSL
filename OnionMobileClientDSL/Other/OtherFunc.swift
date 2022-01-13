//
//  OtherFunc.swift
//  OnionMobileClientDSL
//
//  Created by XIANG KUILIN on 2022/1/13.
//

import Foundation
import UIKit

//16进制颜色  kRGBColorFromHexString("#F6F7F9")
func kRGBColorFromHexString(_ colorStr:String) -> UIColor {
    
    var color = UIColor.red
    var cStr : String = colorStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
    
    if cStr.hasPrefix("#") {
        let index = cStr.index(after: cStr.startIndex)
        cStr = cStr.substring(from: index)
    }
    if cStr.count != 6 && cStr.count != 8 {
        return UIColor.black
    }
    
    //是否是带透明度的8位16进制
    var isAlphaValue:Bool = false
    var baseRGBIndex:Int = 0
    if cStr.count == 8 {
        isAlphaValue = true
        baseRGBIndex = 2
    }
    
    let rRange = cStr.index(cStr.startIndex, offsetBy: baseRGBIndex) ..< cStr.index(cStr.startIndex, offsetBy: baseRGBIndex+2)
    let rStr = cStr.substring(with: rRange)
    
    let gRange = cStr.index(cStr.startIndex, offsetBy: baseRGBIndex+2) ..< cStr.index(cStr.startIndex, offsetBy: baseRGBIndex+4)
    let gStr = cStr.substring(with: gRange)
    
    let bIndex = cStr.index(cStr.endIndex, offsetBy: -2)
    let bStr = cStr.substring(from: bIndex)
    
    
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string: rStr).scanHexInt32(&r)
    Scanner(string: gStr).scanHexInt32(&g)
    Scanner(string: bStr).scanHexInt32(&b)
    
    //透明度提取支持
    var a:CUnsignedInt = 0
    var alpha:CGFloat = 1.0
    if isAlphaValue {
        //透明度
        let aRange = cStr.startIndex ..< cStr.index(cStr.startIndex, offsetBy: baseRGBIndex)
        let aStr = cStr.substring(with: aRange)
        Scanner(string: aStr).scanHexInt32(&a)
        alpha = CGFloat(a) / 255.0
    }
    
    color = UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(alpha))
    
    return color
}
