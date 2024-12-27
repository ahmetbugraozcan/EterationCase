//
//  UINavigationController+Extension.swift
//  eterationcase
//
//  Created by Ahmet Buğra Özcan on 27.12.2024.
//

import UIKit

extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
