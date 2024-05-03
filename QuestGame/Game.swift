//
//  Game.swift
//  QuestGame
//
//  Created by Shamil Aglarov on 02.05.2024.
//

import Foundation

class Game {
    var currentScene: Scene
    var character: Character
    var scenes: [String: Scene]

    init(startScene: String, scenes: [String: Scene], character: Character) {
        self.currentScene = scenes[startScene]!
        self.character = character
        self.scenes = scenes
    }

    func start() {
        moveToScene(sceneName: currentScene.description)
    }

    func moveToScene(sceneName: String) {
        if let scene = scenes[sceneName] {
            currentScene = scene
            print("Перешли к сцене: \(scene.description)")
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
        print("Игра окончена. Ваши статистики: Здоровье - \(character.health), Сила - \(character.strength), Удача - \(character.luck), Инвентарь - \(character.inventory.joined(separator: ", "))")
    }
}
