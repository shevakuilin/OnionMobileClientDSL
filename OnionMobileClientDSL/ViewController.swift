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
//        OMCDParser.parsing(canvas: <#T##[String : Any]#>)
        
        OMCDParser.parsing(canvas: "")
    }
}

