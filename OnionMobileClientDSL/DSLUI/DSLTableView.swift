//
//  DSLTableView.swift
//  OnionMobileClientDSL
//
//  Created by XIANG KUILIN on 2022/1/18.
//

import UIKit
import YC_YogaKit

class DSLTableView: UIView, UITableViewDelegate {
    
    public var dataModel: OMCDData! // 数据模型
    fileprivate var attributeSet: OMCDAttributeSet! // DSL属性集
    private var tableView: UITableView!

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
        bindData()
    }
}

private extension DSLTableView {
    /// 设置视图属性
    private func setViewAttribute() {
        self.backgroundColor = .clear
        
        tableView = UITableView()
        tableView.backgroundColor = attributeSet.viewStyle.backgroundColor
        tableView.alpha = CGFloat(attributeSet.viewStyle.alpha)
        tableView.layer.borderColor = attributeSet.viewStyle.borderColor.cgColor
        tableView.layer.borderWidth = CGFloat(attributeSet.viewStyle.borderWidth)
        tableView.layer.masksToBounds = CGFloat(attributeSet.viewStyle.cornerRadius) > 0 ? true:false
        tableView.layer.cornerRadius = CGFloat(attributeSet.viewStyle.cornerRadius)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 45
        self.addSubview(tableView)
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
            layout.height = YGValue(self.attributeSet.container.layoutHeight["value"] as! CGFloat)
            layout.width = YGValue(self.attributeSet.container.layoutWidth["value"] as! CGFloat)
        }
        
        tableView.configureLayout { layout in
            layout.isEnabled = true
            layout.flexDirection = self.attributeSet.flexStyle.flexDirection
            layout.justifyContent = self.attributeSet.flexStyle.justifyContent
            layout.alignItems = self.attributeSet.flexStyle.alignItems
            layout.alignSelf = self.attributeSet.flexStyle.alignSelf
            layout.flexGrow = CGFloat(self.attributeSet.flexStyle.flexGrowFloat)
            layout.flexShrink = CGFloat(self.attributeSet.flexStyle.flexShrinkFloat)
            layout.flexBasis = self.attributeSet.flexStyle.flexBasisPercent
            layout.display = self.attributeSet.flexStyle.display
            layout.height = YGValue(self.attributeSet.container.layoutHeight["value"] as! CGFloat)
            layout.width = YGValue(self.attributeSet.container.layoutWidth["value"] as! CGFloat)
        }
        self.yoga.applyLayout(preservingOrigin: false)
    }
    
    /// 绑定数据
    private func bindData() {
        dataModel = attributeSet.data
        
    }
}

extension DSLTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "测试数据\(indexPath.row + 1)"
        
        return cell
    }
}

extension DSLTableView: UITabBarDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let theURL = URL(string: "https://zhuanlan.zhihu.com") else {
            return
        }
        // 模拟跳转到Safari
        UIApplication.shared.open(theURL, options: [:], completionHandler: nil)
    }
}
