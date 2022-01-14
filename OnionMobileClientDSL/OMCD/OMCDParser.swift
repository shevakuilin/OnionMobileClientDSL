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
import YC_YogaKit

/// 布局信息解析
///
/// 视图信息解析
///
/// 响应事件解析
///
/// 负责DSL的识别、解释和执行


// - MARK: DSL属性集
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
    var flexGrowFloat: CGFloat
    var flexShrinkFloat: CGFloat
    /// CompactValue
    var flexBasisPercent: YGValue
    var display: YGDisplay
}

/// 视图属性
/// 与视图 UI 样式相关的属性，如背景色、透明度、圆角等
public struct OMCDViewStyle {
    var backgroundColor: UIColor
    var alpha: CGFloat
    var cornerRadius: CGFloat
    var borderColor: UIColor
    var borderWidth: CGFloat
    var textColor: UIColor
    var textAlignment: NSTextAlignment
    var font: UIFont
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

// - MARK: DSL解析器
class OMCDParser: NSObject {
    /// 解析DSL
    /// - parameters: canvas DSL描述语句，JSON数据格式
    public class func parsing(canvas: String) -> OMCDAttributeSet  {
        let dsl: [String: AnyObject] = convert(json: canvas)
        let flexStyle = dsl["flexStyle"] as? [String: Any]
        let viewStyle = dsl["viewStyle"] as? [String: Any]
        let data = dsl["data"] as? [String: Any]
        let viewAction = dsl["viewAction"] as? [String: Any]
        let condition = dsl["condition"] as? [String: Any]
        let container = dsl["container"] as? [String: Any]
        let attributeSet = OMCDAttributeSet(flexStyle: recognize(flexStyle: flexStyle)!,
                                            viewStyle: recognize(viewStyle: viewStyle)!,
                                            data: recognize(data: data)!,
                                            viewAction: recognize(viewAction: viewAction)!,
                                            condition: recognize(condition: condition)!,
                                            container: recognize(container: container)!)
        return attributeSet
    }
}

// - MARK: 转换DSL描述语句
private extension OMCDParser {
    /// 转换JSON->Dictionary
    /// - Parameters: json 原始JSON结构DLS描述语句
    /// - Return: 转换后的Dictionary
    private class func convert(json: String) -> [String: AnyObject] {
        guard let result: [String: AnyObject] = convertStringToDictionary(text: json) else {
            return [:]
        }
        return result
    }
    
    private class func convertStringToDictionary(text: String) -> [String: AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]
                return json
            } catch {}
        }
        return nil
    }
    
    /// 转换字符串为YGFlexDirection
    /// - Parameters: string 原始字符串
    /// - Return: 转换后的YGFlexDirection属性
    private class func convertFlexDirection(string: String?) -> YGFlexDirection {
        var flexDirection: YGFlexDirection = .column
        if string == "DirectionColumn" {
            flexDirection = .column
        } else if string == "DirectionColumnReverse" {
            flexDirection = .columnReverse
        } else if string == "DirectionRow" {
            flexDirection = .row
        } else if string == "DirectionRowReverse" {
            flexDirection = .rowReverse
        }
        return flexDirection
    }
    
    /// 转换字符串为YGJustify
    /// - Parameters: string 原始字符串
    /// - Return: 转换后的YGJustify属性
    private class func convertJustifyContent(string: String?) -> YGJustify {
        var justifyContent: YGJustify = .flexStart
        if string == "JustifyFlexStart" {
            justifyContent = .flexStart
        } else if string == "JustifyCenter" {
            justifyContent = .center
        } else if string == "JustifyFlexEnd" {
            justifyContent = .flexEnd
        } else if string == "JustifySpaceBetween" {
            justifyContent = .spaceBetween
        } else if string == "JustifySpaceAround" {
            justifyContent = .spaceAround
        } else if string == "JustifySpaceEvenly" {
            justifyContent = .spaceEvenly
        }
        return justifyContent
    }
    
    /// 转换字符串为YGAlign
    /// - Parameters: string 原始字符串
    /// - Return: 转换后的YGAlign属性
    private class func convertAlign(string: String?) -> YGAlign {
        var align: YGAlign = .auto
        if string == "AlignAuto" {
            align = .auto
        } else if string == "AlignFlexStart" {
            align = .flexStart
        } else if string == "AlignCenter" {
            align = .center
        } else if string == "AlignFlexEnd" {
            align = .flexEnd
        } else if string == "AlignStretch" {
            align = .stretch
        } else if string == "AlignBaseline" {
            align = .baseline
        } else if string == "AlignSpaceBetween" {
            align = .spaceBetween
        } else if string == "AlignSpaceAround" {
            align = .spaceAround
        }
        return align
    }
    
    /// 转换字符串为YGDisplay
    /// - Parameters: string 原始字符串
    /// - Return: 转换后的YGDisplay属性
    private class func convertDisplay(string: String?) -> YGDisplay {
        var display: YGDisplay = .flex
        if string == "DisplayFlex" {
            display = .flex
        } else if string == "DisplayNone" {
            display = .none
        }
        return display
    }
}

// - MARK: 识别DSL描述语句
private extension OMCDParser {
    /// 识别flexStyle
    /// - parameters: flexStyle原始DSL描述语句
    private class func recognize(flexStyle: [String : Any]?) -> OMCDFlexStyle? {
        guard let flex = flexStyle else {
            return nil
        }
        let flexStyle = OMCDFlexStyle(flexDirection: convertFlexDirection(string: flex["flexDirection"] as? String),
                                      justifyContent: convertJustifyContent(string: flex["justifyContent"] as? String),
                                      alignItems: convertAlign(string: flex["alignItems"] as? String),
                                      alignSelf: convertAlign(string: flex["alignSelf"] as? String),
                                      flexGrowFloat: flex["flexGrowFloat"] as? CGFloat ?? 0,
                                      flexShrinkFloat: flex["flexShrinkFloat"] as? CGFloat ?? 0,
                                      flexBasisPercent: YGValue(value: flex["flexBasisPercent"] as? Float ?? 0, unit: .auto),
                                      display: convertDisplay(string: flex["display"] as? String))
        return flexStyle
    }
    
    /// 识别viewStyle
    /// - parameters: viewStyle原始DSL描述语句
    private class func recognize(viewStyle: [String : Any]?) -> OMCDViewStyle? {
        guard let view = viewStyle else {
            return nil
        }
        let viewStyle = OMCDViewStyle(backgroundColor: kRGBColorFromHexString(view["backgroundColor"] as? String ?? ""),
                                      alpha: view["alpha"] as? CGFloat ?? 0,
                                      cornerRadius: view["cornerRadius"] as? CGFloat ?? 0,
                                      borderColor: kRGBColorFromHexString(view["borderColor"] as? String ?? ""),
                                      borderWidth: view["borderWidth"] as? CGFloat ?? 0,
                                      textColor: kRGBColorFromHexString(view["textColor"] as? String ?? ""),
                                      textAlignment: .center,
                                      font: .systemFont(ofSize: 15))
        return viewStyle
    }
    
    /// 识别data
    /// - parameters: data原始DSL描述语句
    private class func recognize(data: [String : Any]?) -> OMCDData? {
        guard let styleData = data else {
            return nil
        }
        let data = OMCDData(data: styleData["data"] as? [String : AnyObject] ?? [:],
                            bindTarget: styleData["bindTarget"] as? String ?? "")
        return data
    }
    
    /// 识别viewAction
    /// - parameters: viewAction原始DSL描述语句
    private class func recognize(viewAction: [String : Any]?) -> OMCDViewAction? {
        guard let action = viewAction else {
            return nil
        }
        let viewAction = OMCDViewAction(action: action["action"] as? String ?? "",
                                        extra: action["extra"] as? [String : AnyObject] ?? [:])
        return viewAction
    }
    
    /// 识别condition
    /// - parameters: condition原始DSL描述语句
    private class func recognize(condition: [String : Any]?) -> OMCDCondition? {
        let condition = OMCDCondition(operation: "",
                                      left: 0,
                                      right: 0,
                                      value: "",
                                      subCondition: 0)
        return condition
    }
    
    /// 识别container
    /// - parameters: container原始DSL描述语句
    private class func recognize(container: [String : Any]?) -> OMCDContainer? {
        guard let theContainer = container else {
            return nil
        }
        let container = OMCDContainer(children: theContainer["children"] as? [String : Any] ?? [:],
                                      flexStyle: recognize(flexStyle: theContainer["flexStyle"]  as? [String : Any] ?? [:]) ?? OMCDFlexStyle(flexDirection: .column, justifyContent: .flexStart, alignItems: .flexStart, alignSelf: .auto, flexGrowFloat: 0, flexShrinkFloat: 0, flexBasisPercent: 0, display: .none),
                                      layoutHeight: theContainer["layoutHeight"] as? [String : Any] ?? [:],
                                      layoutWidth: theContainer["layoutWidth"] as? [String : Any] ?? [:],
                                      type: theContainer["type"] as? String ?? "")
        return container
    }
}
