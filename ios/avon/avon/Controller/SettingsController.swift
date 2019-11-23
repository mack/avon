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
        self.view.backgroundColor = .blue
        
        
        portraitSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 50)        
    }
    
    override var pullUpControllerPreferredSize: CGSize {
        return portraitSize
    }
}

