//
//  UIColor+Utility.swift
//  ExpenseTracker
//
//  Created by Rahul Tamrakar on 15/03/17.
//  Copyright © 2017 Rahul Tamrakar. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red:   CGFloat(drand48()),
                       green: CGFloat(drand48()),
                       blue:  CGFloat(drand48()),
                       alpha: 1.0)
    }
    
    class func color(withData data:Data) -> UIColor {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! UIColor
    }
    
    func encode() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
    /*
     How to use above methods
     var myColor = UIColor.green
     // Encoding the color to data
     let myColorData = myColor.encode() // This can be saved into coredata/UserDefaulrs
     let newColor = UIColor.color(withData: myColorData) // Converting back to UIColor from Data
    */
    
}
