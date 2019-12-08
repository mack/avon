//
//  Global.swift
//  avon
//
//  Created by Mackenzie Boudreau on 2019-11-25.
//  Copyright © 2019 Mackenzie Boudreau. All rights reserved.
//

import Foundation

var Commands = [
    Command(name: "Call", active: false, fn: nil),
    Command(name: "Text", active: true, fn: nil),
    Command(name: "Reminder", active: false, fn: nil),
    Command(name: "Speed Warnings", active: true, fn: nil),
    Command(name: "Current Time", active: true, fn: nil),
]

var Extensions = [
    Extension(name: "Discord", description: "", price: 0.99),
    Extension(name: "Slack", description: "", price: 0.99),
    Extension(name: "Dangerous Areas", description: "", price: 0),
    Extension(name: "Traffic Detector", description: "", price: 0),
    Extension(name: "Upcoming crosswalk", description: "", price: 0),
    Extension(name: "Email Notifier", description: "", price: 0),
]
