//
//  UIViewController+KeyboardHide.swift
//  ExpenseTracker
//
//  Created by Rahul Tamrakar on 12/03/17.
//  Copyright © 2017 Rahul Tamrakar. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
