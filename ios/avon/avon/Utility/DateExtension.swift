//
//  DateExtension.swift
//  avon
//
//  Created by Jarret Terrio on 2019-11-23.
//  Copyright © 2019 Mackenzie Boudreau. All rights reserved.
//

import Foundation

extension Date {
    var millisecondsSince1970: Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
