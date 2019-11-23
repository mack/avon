//
//  SettingsController.swift
//  avon
//
//  Created by Mackenzie Boudreau on 2019-11-22.
//  Copyright © 2019 Mackenzie Boudreau. All rights reserved.
//

import UIKit
import PullUpController

class SettingsController: PullUpController {

    public var portraitSize: CGSize = .zero
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.layer.cornerRadius = 10
        self.view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        let titleView = UILabel(frame: CGRect(x: 35, y: 20, width: UIScreen.main.bounds.width, height: 100))
        titleView.font = UIFont.boldSystemFont(ofSize: 32.0)
        titleView.text = "Commands"
        self.view.addSubview(titleView)
        
        portraitSize = CGSize(width: UIScreen.main.bounds.width - 16, height: UIScreen.main.bounds.height - 100)
    }
    
    override var pullUpControllerPreferredSize: CGSize {
        return portraitSize
    }
    
    override var pullUpControllerBounceOffset: CGFloat {
        return 40.0
    }
}

