//
//  Game.swift
//  QuestGame
//
//  Created by Shamil Aglarov on 02.05.2024.
//

import Foundation

// Протокол делегата, сообщающего об окончании игры
protocol GameOverDelegate: AnyObject {
    // Метод, который вызывается, когда игра завершена
    func gameOver()
}

// Класс, представляющий игру, в которой персонаж перемещается по различным сценам
class Game {
    // Текущая сцена, в которой находится персонаж
    var currentScene: Scene
    
    // Персонаж, управляемый игроком
    var character: Character
    
    // Все доступные сцены, организованные по их идентификаторам
    var scenes: [String: Scene]
    
    // Делегат, уведомляющий об окончании игры
    var gameOverDelegate: GameOverDelegate?
    
    // Делегат, уведомляющий о гибели персонажа
    var deadDelegate: DeadhDelegate?
    
    // Инициализатор игры, устанавливающий начальную сцену, все доступные сцены и персонажа
    init(startScene: String, scenes: [String: Scene], character: Character) {
        // Устанавливаем начальную сцену на основе идентификатора
        self.currentScene = scenes[startScene]!
        // Присваиваем переданного персонажа
        self.character = character
        // Присваиваем переданные сцены
        self.scenes = scenes
    }
    
    // Метод, позволяющий перемещаться к определенной сцене по ее имени
    private func moveToScene(sceneName: String) {
        // Пытаемся найти сцену по ее имени в словаре доступных сцен
        if let scene = scenes[sceneName] {
            // Устанавливаем текущую сцену
            currentScene = scene
            // Выводим информацию о текущей сцене в консоль
            print("Перешли к сцене: \(scene.description)")
            print("Количество жизней: \(character.health)")
            print("Инвентарь: \(character.inventory.joined(separator: ", "))")
        } else {
            // Если сцена не найдена, выводим сообщение об ошибке
            print("Сцена не найдена. Проверьте название сцены.")
        }
    }
    
    // Метод, обрабатывающий выбор игрока
    func processChoice(choice: Choice) {
        // Применяем эффект выбора к персонажу, если эффект определен
        choice.effect?(&character)
        // Если есть название следующей сцены, пытаемся перейти к ней
        if let nextSceneName = scenes[choice.destination ?? ""] {
            moveToScene(sceneName: choice.destination ?? "")
        } else {
            // Иначе завершаем игру
            endGame()
        }
    }
    
    // Метод завершения игры, уведомляющий делегата об окончании
    func endGame() {
        gameOverDelegate?.gameOver()
    }
}

