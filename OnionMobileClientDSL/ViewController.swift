//
//  ViewController.swift
//  OnionMobileClientDSL
//
//  Created by XIANG KUILIN on 2021/12/27.
//

import UIKit

class ViewController: UIViewController {
    private let dslView = DSLView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 获取Mock DSL数据，解析器解析为属性集
        let set: OMCDAttributeSet = OMCDParser.parsing(canvas: getJson())
        set.flexStyle.flexBasisPercent
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
}

