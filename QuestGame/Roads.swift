//
//  Roads.swift
//  QuestGame
//
//  Created by Shamil Aglarov on 02.05.2024.
//

import Foundation

struct Roads {
    // Стартовое место сценария
    static let start = "start"
    // Главный зал
    static let mainHall = "mainHall"
    // Ловушка
    static let trapped = "trapped"
    // Лаборатория
    static let laboratory = "laboratory"
    // Комната управления
    static let controlRoom = "controlRoom"
    // Путь к спасению
    static let escapeRoute = "escapeRoute"
    // Предупреждение
    static let caution = "caution"
    // Возвращение героя (случайное значение)
    static let heroicReturn = ["heroicReturn", "fail"]
    // Свобода
    static let freedom = "freedom"
    // Конец игры
    static let gameover = "gameover"
    // Альтернативный выход
    static let alternativeExit = "alternativeExit"
    // Узкое спасение
    static let narrowEscape = "narrowEscape"
    // Отчаянный поиск
    static let desperateSearch = "desperateSearch"
    // Глубже в лабораторию
    static let deepIntoTheLab = "deepIntoTheLab"
    // Спасение через вентиляцию
    static let ventEscape = "ventEscape"
    // Поиск кода
    static let searchCode = "searchCode"
    
    // Массив с комнатами для использования в игре
    static let rooms: [String] = [
        start, mainHall, trapped, laboratory, controlRoom, escapeRoute,
        caution, heroicReturn.randomElement()!, freedom, gameover, alternativeExit,
        narrowEscape, desperateSearch, deepIntoTheLab, ventEscape, searchCode
    ]
}
