//
//  Command.swift
//  avon
//
//  Created by Mackenzie Boudreau on 2019-11-23.
//  Copyright © 2019 Mackenzie Boudreau. All rights reserved.
//

import Foundation

struct Command {
    var name = ""
    var active = false
    var fn: ((Any) -> Void)?
}
