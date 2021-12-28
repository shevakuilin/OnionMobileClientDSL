//
//  OMCDParser.swift
//  OnionMobileClientDSL
//
//  DSL解析器
//
//  Created by XIANG KUILIN on 2021/12/27.
//

import Foundation
import UIKit

/// 布局信息解析
///
/// 视图信息解析
///
/// 响应事件解析
///
/// 负责DSL的识别、解释和执行

//struct CMCDLayoutParser {
//    var top: Float
//    var bottom: Float
//    var left: Float
//    var right: Float
//    var width: Float
//    var height: Float
//}
//
//struct CMCDViewParser {
//    var backgroundColor : UIColor
//    var textColor: UIColor
//    var textAlignment: NSTextAlignment
//    var layer: CALayer
//}
//
//struct CMCDActionParser {
//    var clickAction: Selector
//}


/// DSL属性集
///
/// 属性集包含六种属性：布局属性，视图属性，数据属性，交互属性，条件属性，容器属性
///

/// 布局属性
/// 决定视图树结构，规划视图布局位置的相关属性
struct OMCDFlexStyle {
    var flexDirection: Any
    var justifyContent: Any
    var alignItems: Any
    var alignSelf: Any
    var flexGrowFloat: Any
    var flexShrinkFloat: Any
    var flexBasisPercent: Any
}

/// 视图属性
/// 与视图 UI 样式相关的属性，如背景色、透明度、圆角等
struct OMCDViewStyle {
    var backgroundColor: UIColor
    var alpha: Float
    var cornerRadius: Float
    var strokeColor: UIColor
    var strokeWidth: Float
}

/// 数据属性
/// 表达节点与数据绑定关系的属性，在不同的视图控件中有所区别
struct OMCDData {
    var data: Any
    var bindTarget: Any
}

/// 交互属性
/// action 指明该交互要完成的动作，extra 携带交互需要的信息和数据。如，描述了一个 CLICK 事件，触发后，将从 extra 中取出 URL 信息，并进行跳转。
struct OMCDViewAction {
    var action: Any
    var extra: Any
}

/// 条件属性
/// 可支持or（逻辑或）、and（逻辑与）、not（逻辑非）、notEmpty（非空）、empty（空）、valueOf（取 bool 值）
struct OMCDCondition {
    /// 操作符
    var operation: Any
    /// 左操作符
    var left: Any
    /// 右操作符
    var right: Any
    /// 一元操作数
    var value: Any
    /// 子条件
    var subCondition: Any
}

/// 容器属性
/// container 对应于 App 端支持了 Flexbox 布局系统的容器控件。container 使用属性 children 来描述容器内嵌套的子视图，children 是一个数组，可以包含任意多个控件节点
/// 我们将控件的宽高定义为一个复合属性，我们使用了更简洁的字符串类型的 layoutHeight、layoutWidth 来描述高和宽
struct OMCDContainer {
    var children: Any
    var flexStyle: OMCDFlexStyle
    var layoutHeight: Any
    var layoutWidth: Any
    var type: String
}

class OMCDParser: NSObject {
    /// 解析DSL
    /// - parameters: canvas DSL描述语句
    public class func parsing(canvas: [String: Any]) {
        
    }
}
