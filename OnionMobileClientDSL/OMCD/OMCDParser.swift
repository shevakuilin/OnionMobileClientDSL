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
import yoga

/// 布局信息解析
///
/// 视图信息解析
///
/// 响应事件解析
///
/// 负责DSL的识别、解释和执行


/// DSL属性集
///
/// 属性集包含六种属性：布局属性，视图属性，数据属性，交互属性，条件属性，容器属性
///

/// 布局属性
/// 决定视图树结构，规划视图布局位置的相关属性
public struct OMCDFlexStyle {
    var flexDirection: YGFlexDirection
    var justifyContent: YGJustify
    var alignItems: YGAlign
    var alignSelf: YGAlign
    /// YGFloatOptional
    var flexGrowFloat: Any
    var flexShrinkFloat: Any
    /// CompactValue
    var flexBasisPercent: Any
    var display: YGDisplay
}

/// 视图属性
/// 与视图 UI 样式相关的属性，如背景色、透明度、圆角等
public struct OMCDViewStyle {
    var backgroundColor: UIColor = .white
    var alpha: Float
    var cornerRadius: Float
    var borderColor: UIColor = .white
    var borderWidth: Float
    var textColor: UIColor = .black
    var textAlignment: NSTextAlignment = .left
    var font: UIFont = .systemFont(ofSize: 17)
}

/// 数据属性
/// 表达节点与数据绑定关系的属性，在不同的视图控件中有所区别
public struct OMCDData {
    var data: [String : AnyObject]
    var bindTarget: String
}

/// 交互属性
/// action 指明该交互要完成的动作，extra 携带交互需要的信息和数据。如，描述了一个 CLICK 事件，触发后，将从 extra 中取出 URL 信息，并进行跳转。
public struct OMCDViewAction {
    var action: String
    var extra: [String : AnyObject]
}

/// 条件属性
/// 可支持or（逻辑或）、and（逻辑与）、not（逻辑非）、notEmpty（非空）、empty（空）、valueOf（取 bool 值）
public struct OMCDCondition {
    /// 操作符
    var operation: String
    /// 左操作符
    var left: Any
    /// 右操作符
    var right: Any
    /// 一元操作数
    var value: String
    /// 子条件
    var subCondition: Any
}

/// 容器属性
/// container 对应于 App 端支持了 Flexbox 布局系统的容器控件。container 使用属性 children 来描述容器内嵌套的子视图，children 是一个数组，可以包含任意多个控件节点
/// 我们将控件的宽高定义为一个复合属性，我们使用了更简洁的字符串类型的 layoutHeight、layoutWidth 来描述高和宽
public struct OMCDContainer {
    var children: Any
    var flexStyle: OMCDFlexStyle
    var layoutHeight: [String : Any]
    var layoutWidth: [String : Any]
    var type: String
}

/// 属性集
public struct OMCDAttributeSet {
    var flexStyle: OMCDFlexStyle
    var viewStyle: OMCDViewStyle
    var data: OMCDData
    var viewAction: OMCDViewAction
    var condition: OMCDCondition
    var container: OMCDContainer
}

/// DSL解析器
class OMCDParser: NSObject {
    /// 解析DSL
    /// - parameters: canvas DSL描述语句
    public class func parsing(canvas: [String: Any]) -> OMCDAttributeSet  {
        let attributeSet = OMCDAttributeSet(flexStyle: recognize(flexStyle: [:]),
                                            viewStyle: recognize(viewStyle: [:]),
                                            data: recognize(data: [:]),
                                            viewAction: recognize(viewAction: [:]),
                                            condition: recognize(condition: [:]),
                                            container: recognize(container: [:]))
        return attributeSet
    }
}

private extension OMCDParser {
    /// 识别flexStyle
    /// - parameters: flexStyle原始DSL描述语句
    private class func recognize(flexStyle: [String : Any]) -> OMCDFlexStyle {
        let flexStyle = OMCDFlexStyle(flexDirection: .column,
                                      justifyContent: .center,
                                      alignItems: .auto,
                                      alignSelf: .baseline,
                                      flexGrowFloat: 0,
                                      flexShrinkFloat: 0,
                                      flexBasisPercent: 0,
                                      display: .flex)
        return flexStyle
    }
    
    /// 识别viewStyle
    /// - parameters: viewStyle原始DSL描述语句
    private class func recognize(viewStyle: [String : Any]) -> OMCDViewStyle {
        let viewStyle = OMCDViewStyle(backgroundColor: .systemPink,
                                      alpha: 1.0,
                                      cornerRadius: 0,
                                      borderColor: .white,
                                      borderWidth: 0,
                                      textColor: .orange,
                                      textAlignment: .center,
                                      font: .systemFont(ofSize: 15))
        return viewStyle
    }
    
    /// 识别data
    /// - parameters: data原始DSL描述语句
    private class func recognize(data: [String : Any]) -> OMCDData {
        let data = OMCDData(data: [:],
                            bindTarget: "")
        return data
    }
    
    /// 识别viewAction
    /// - parameters: viewAction原始DSL描述语句
    private class func recognize(viewAction: [String : Any]) -> OMCDViewAction {
        let viewAction = OMCDViewAction(action: "",
                                        extra: [:])
        return viewAction
    }
    
    /// 识别condition
    /// - parameters: condition原始DSL描述语句
    private class func recognize(condition: [String : Any]) -> OMCDCondition {
        let condition = OMCDCondition(operation: "",
                                      left: 0,
                                      right: 0,
                                      value: "",
                                      subCondition: 0)
        return condition
    }
    
    /// 识别container
    /// - parameters: container原始DSL描述语句
    private class func recognize(container: [String : Any]) -> OMCDContainer {
        let container = OMCDContainer(children: 0,
                                      flexStyle: recognize(flexStyle: [:]),
                                      layoutHeight: [:],
                                      layoutWidth: [:],
                                      type: "container")
        return container
    }
}
