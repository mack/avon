//
//  Lerp.swift
//  avon
//
//  Created by Jarret Terrio on 2019-11-23.
//  Copyright © 2019 Mackenzie Boudreau. All rights reserved.
//

import Foundation
import UIKit

public class Lerp {
    public static func lerp(_ v0: CGFloat, _ v1: CGFloat, _ t: CGFloat) -> CGFloat {
        return v0 * (1 - t) + v1 * t
    }
}
