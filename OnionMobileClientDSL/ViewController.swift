//
//  ViewController.swift
//  OnionMobileClientDSL
//
//  Created by XIANG KUILIN on 2021/12/27.
//

import UIKit

class ViewController: UIViewController {
    var count: Int = 0
    private let dslView = DSLView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 获取Mock DSL数据，解析器解析为属性集
        let set: OMCDAttributeSet = OMCDParser.parsing(canvas: getJson())
        
        self.dslView.initElements(set: set)
        self.view.addSubview(self.dslView)
        
        // 递归遍历子视图
        recurseSubviews(children: set.container.children)
    }
}

private extension ViewController {
    private func getJson() -> String {
        if let path = Bundle.main.path(forResource: "MockDSL", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let convertedString = String(data: data, encoding: String.Encoding.utf8) ?? ""
                return convertedString
              } catch {
                return ""
              }
        }
        return ""
    }
    
    private func recurseSubviews(children: [[String: AnyObject]]) {
        guard children.count > 0 && count < children.count else {
            return
        }
        let set: OMCDAttributeSet = OMCDParser.parsing(canvas: children[count])
        
        let dslSubview = DSLView()
        dslSubview.initElements(set: set)
        dslView.addSubview(dslSubview)
        
        count += 1
        
        recurseSubviews(children: children)
    }
}

