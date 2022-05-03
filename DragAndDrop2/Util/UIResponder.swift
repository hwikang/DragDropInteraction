//
//  UIResponder.swift
//  DragAndDrop2
//
//  Created by Hwi kang on 2022/05/03.
//

import UIKit
extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
