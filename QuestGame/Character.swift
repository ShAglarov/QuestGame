//
//  Character.swift
//  QuestGame
//
//  Created by Shamil Aglarov on 02.05.2024.
//

import Foundation

// Протокол для делегирования события смерти
protocol DeadhDelegate: AnyObject {
    func dead()
}

// Структура персонажа игры
struct Character {
    // Свойство здоровья персонажа, с проверкой на смерть
    var health: Int {
        didSet {
            // Если здоровье опустится до 0 или ниже, вызываем метод dead() делегата
            if health <= 0 {
                delegate?.dead()
            }
        }
    }
    
    // Свойства силы, удачи и инвентаря персонажа
    var strength: Int
    var luck: Int
    var inventory: [String]
    
    // Делегат для обработки события смерти
    var delegate: DeadhDelegate?
    
    // Метод обновления здоровья персонажа на определенное значение
    mutating func updateHealth(by amount: Int) {
        health += amount
        // Убеждаемся, что здоровье не выходит за пределы от 0 до 100
        health = max(0, min(health, 100))
    }
    
    // Метод увеличения силы на определенное значение
    mutating func updateStrength(by amount: Int) {
        strength += amount
    }
    
    // Метод увеличения удачи на определенное значение
    mutating func updateLuck(by amount: Int) {
        luck += amount
    }
    
    // Метод добавления нового предмета в инвентарь персонажа
    mutating func addItem(_ item: String) {
        // Добавляем предмет только если его еще нет в инвентаре
        if !inventory.contains(item) {
            inventory.append(item)
        }
    }
    
    // Метод удаления предмета из инвентаря персонажа
    mutating func removeItem(_ item: String) {
        // Находим индекс предмета и удаляем его
        if let index = inventory.firstIndex(of: item) {
            inventory.remove(at: index)
        }
    }
    
    // Метод проверки наличия предмета в инвентаре персонажа
    func hasItem(_ item: String) -> Bool {
        return inventory.contains(item)
    }
    
    // Метод проведения боя с врагом, возвращает результат победы или поражения
    mutating func combat(enemyStrength: Int) -> Bool {
        // Рассчитываем результат боя на основе силы и удачи персонажа против силы врага
        let combatResult = (strength + luck) - enemyStrength
        if combatResult > 0 {
            return true // Победа
        } else {
            // При поражении уменьшаем здоровье на значение разницы
            updateHealth(by: combatResult)
            return false
        }
    }
}

