//
//  ViewController.swift
//  avon
//
//  Created by Mackenzie Boudreau on 2019-11-22.
//  Copyright © 2019 Mackenzie Boudreau. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addPullUpController(SettingsController(), initialStickyPointOffset: 50, animated: true)
    }
}

