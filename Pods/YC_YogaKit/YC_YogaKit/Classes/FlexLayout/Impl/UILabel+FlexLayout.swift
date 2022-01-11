//
//  UILabel+FlexLayout.swift
//  XYReader
//
//  Created by Simon.Hu on 2020/5/23.
//  Copyright © 2020 FlexLayout All rights reserved.
//

import UIKit

/// UILabel用于自动布局使用
extension UILabel {
    public var flex_text: String? {
        set {
            self.text = newValue
            self.flex.markDirty()
        }
        
        get {
            return self.text
        }
    }
    
    public var flex_attributedText: NSAttributedString? {
        set {
            self.attributedText = newValue
            self.flex.markDirty()
        }
        
        get {
            return self.attributedText
        }
    }
}
