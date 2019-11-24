//
//  Timeout.swift
//  avon
//
//  Created by Jarret Terrio on 2019-11-23.
//  Copyright © 2019 Mackenzie Boudreau. All rights reserved.
//

import Foundation

public class Timeout {
    
    public typealias ComplectionBlock = () -> Void
    
    public static func setInterval(_ interval: TimeInterval,
                                   block: @escaping ComplectionBlock) -> Timer {
        return Timer.scheduledTimer(timeInterval: interval,
                                    target: BlockOperation(block: block),
                                    selector: #selector(Operation.main),
                                    userInfo: nil, repeats: true)
    }
    
}
