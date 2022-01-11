//
//  DSLView.swift
//  OnionMobileClientDSL
//
//  支持DSL的UIView控件
//
//  Created by XIANG KUILIN on 2022/1/11.
//

import UIKit
import YC_YogaKit

class DSLView: UIView {
    
    public var dataModel: OMCDData! // 数据模型
    fileprivate var attributeSet: OMCDAttributeSet! // DSL属性集

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 初始化元素
    /// - Parameters: set DSL属性集
    public func initElements(set: OMCDAttributeSet) {
        // 保存DSL属性集
        attributeSet = set
        
        // 根据DSL属性集生成视图
        setViewAttribute()
        flexboxLayout()
        bindAction()
        bindData()
    }
    
}

private extension DSLView {
    /// 设置视图属性
    private func setViewAttribute() {
        self.backgroundColor = attributeSet.viewStyle.backgroundColor
        self.alpha = CGFloat(attributeSet.viewStyle.alpha)
        self.layer.borderColor = attributeSet.viewStyle.borderColor.cgColor
        self.layer.borderWidth = CGFloat(attributeSet.viewStyle.borderWidth)
        self.layer.masksToBounds = CGFloat(attributeSet.viewStyle.cornerRadius) > 0 ? true:false
        self.layer.cornerRadius = CGFloat(attributeSet.viewStyle.cornerRadius)
    }
    
    /// 基于Flexbox进行布局
    private func flexboxLayout() {
        self.configureLayout { layout in
            layout.isEnabled = true
            layout.flexDirection = self.attributeSet.flexStyle.flexDirection
            layout.justifyContent = self.attributeSet.flexStyle.justifyContent
            layout.alignItems = self.attributeSet.flexStyle.alignItems
            layout.alignSelf = self.attributeSet.flexStyle.alignSelf
            layout.flexGrow = CGFloat(self.attributeSet.flexStyle.flexGrowFloat)
            layout.flexShrink = CGFloat(self.attributeSet.flexStyle.flexShrinkFloat)
            layout.flexBasis = self.attributeSet.flexStyle.flexBasisPercent
            layout.display = self.attributeSet.flexStyle.display
        }
        self.yoga.applyLayout(preservingOrigin: false)
    }
    
    /// 绑定交互事件
    private func bindAction() {
        // 点击事件
        if attributeSet.viewAction.action == "CLICK" {
            self.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(clickAction))
            self.addGestureRecognizer(tap)
        }
    }
    
    /// 绑定数据
    private func bindData() {
        dataModel = attributeSet.data
    }
}

private extension DSLView {
    // 点击跳转
    @objc
    private func clickAction() {
        let extra = attributeSet.viewAction.extra
        guard let url: String = extra["url"] as? String else {
            return
        }
        guard let theURL = URL(string: url) else {
            return
        }
        // 模拟跳转到Safari
        UIApplication.shared.open(theURL, options: [:], completionHandler: nil)
    }
}
