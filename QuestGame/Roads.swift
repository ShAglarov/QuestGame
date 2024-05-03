//
//  Roads.swift
//  QuestGame
//
//  Created by Shamil Aglarov on 02.05.2024.
//

import Foundation

// Определяем ключевые места сценария как статические константы
struct Roads {
    static let start = "start"
    static let mainHall = "mainHall"
    static let trapped = "trapped"
    static let laboratory = "laboratory"
    static let controlRoom = "controlRoom"
    static let escapeRoute = "escapeRoute"
    static let caution = "caution"
    static let heroicReturn = ["heroicReturn","fail"]
    static let freedom = "freedom"
    static let gameover = "gameover"
    static let alternativeExit = "alternativeExit"
    static let narrowEscape = "narrowEscape"
    static let desperateSearch = "desperateSearch"
    static let deepIntoTheLab = "deepIntoTheLab"
    static let ventEscape = "ventEscape"
    static let searchCode = "searchCode"
    
    static let rooms: [String] = [start, mainHall, trapped,
                            laboratory, controlRoom, escapeRoute,
                               caution, heroicReturn.randomElement()!, freedom,
                              gameover, alternativeExit, narrowEscape,
                       desperateSearch, deepIntoTheLab, ventEscape, searchCode]
}
