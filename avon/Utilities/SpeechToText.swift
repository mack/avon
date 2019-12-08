//
//  SpeechToText.swift
//  avon
//
//  Created by Mackenzie Boudreau on 2019-11-25.
//  Copyright © 2019 Mackenzie Boudreau. All rights reserved.
//

import Foundation

// activators are words that trigger the voice assistant
// to listen to commands
//let activators = ["yvonne", "elimon" ,"even", "ivan", "van", "avon", "ava", "devon"]

private let activators: [String: Bool] = [
    "yvonne": true,
    "elimon": true,
    "even": true,
    "ivan": true,
    "van": true,
    "avon": true,
    "ava": true,
    "devon": true,
 ]

// checkActivator will determine if a word is an activator word
func checkActivator(_ word: String) -> Bool {
    if let activated = activators[word] {
        return activated
    }
    return false
}


private let replacements: [String: String] = [
    "jared": "jarret",
    "jarred": "jarret",
    "jaredd": "jarret",
    "jarredd": "jarret"
]

func checkReplace(_ word: String) -> String {
    if let replace = replacements[word] {
        return replace
    }
    return word
}
