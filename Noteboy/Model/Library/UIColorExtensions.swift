//
//  UIColorExtensions.swift
//  Noteboy
//
//  Created by Lubarda, Miso on 13/11/2016.
//  Copyright © 2016 Noteboy. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let redFloat    = Float(red) / 255
        let greenFloat  = Float(red) / 255
        let blueFloat   = Float(blue) / 255
        self.init(colorLiteralRed: redFloat, green: greenFloat, blue: blueFloat, alpha: 1)
    }

    convenience init(hex: Int) {
        let redFloat    = Float((hex >> 16) & 0xFF) / 255
        let greenFloat  = Float((hex >> 8) & 0xFF)  / 255
        let blueFloat   = Float(hex & 0xFF)         / 255
        self.init(colorLiteralRed: redFloat, green: greenFloat, blue: blueFloat, alpha: 1)
    }
}
