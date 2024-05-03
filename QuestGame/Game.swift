//
//  Game.swift
//  QuestGame
//
//  Created by Shamil Aglarov on 02.05.2024.
//

import Foundation

protocol GameOverDelegate: AnyObject {
    func gameOver()
}

class Game {
    var currentScene: Scene
    var character: Character
    var scenes: [String: Scene]
    
    var gameOverDelegate: GameOverDelegate?
    var deadDelegate: DeadhDelegate?
    
    init(startScene: String, scenes: [String: Scene], character: Character) {
        self.currentScene = scenes[startScene]!
        self.character = character
        self.scenes = scenes
    }
    
    private func moveToScene(sceneName: String) {
        if let scene = scenes[sceneName] {
            currentScene = scene
            print("Перешли к сцене: \(scene.description)")
            print("Количество жизней: \(character.health)")
            print("Инвертарь: \(character.inventory.joined(separator: ", "))")
        } else {
            print("Сцена не найдена. Проверьте название сцены.")
        }
    }
    
    func processChoice(choice: Choice) {
        choice.effect?(&character)
        if let nextSceneName = scenes[choice.destination ?? ""] {
            moveToScene(sceneName: choice.destination ?? "")
        } else {
            endGame()
        }
    }
    
    func endGame() {
        gameOverDelegate?.gameOver()
    }
}
