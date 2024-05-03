//
//  Choice.swift
//  QuestGame
//
//  Created by Shamil Aglarov on 02.05.2024.
//

import Foundation

struct Choice {
    let text: String
    let destination: String?
    let requiredItem: String?
    let effect: ((inout Character) -> Void)?
}
