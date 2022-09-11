//
//  UnoData.swift
//  Uno Tracker
//
//  Created by Isham Jassat on 21/08/2022.
//

import UIKit

struct Player {
    let name: String
    let score: Int
    let winStreak: Int
    let dateCreated: TimeInterval
    let wins: Int
    let loses: Int
    let lastWin: TimeInterval
}
struct Rule {
    let ruleID: String
    let ruleDescription: String
    let ruleCreated: TimeInterval
}
