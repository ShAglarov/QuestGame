//
//  Scene.swift
//  QuestGame
//
//  Created by Shamil Aglarov on 02.05.2024.
//

import Foundation
import UIKit

// Структура для представления сцены в игре
struct Scene {
    // Описание сцены, которое будет отображаться в UI
    let description: String
    
    // Изображение, связанное с данной сценой
    let image: UIImage?
    
    // Возможные варианты выбора, доступные игроку в данной сцене
    let choices: [Choice]
}
