//
//  Character.swift
//  QuestGame
//
//  Created by Shamil Aglarov on 02.05.2024.
//

import Foundation

protocol DeadhDelegate: AnyObject {
    func dead()
}

struct Character {
    var health: Int {
        didSet {
            if health <= 0 {
                delegate?.dead()
            }
        }
    }
    var strength: Int
    var luck: Int
    var inventory: [String]
    var delegate: DeadhDelegate?
    
    mutating func updateHealth(by amount: Int) {
        health += amount
        health = max(0, min(health, 100))
    }
    
    mutating func updateStrength(by amount: Int) {
        strength += amount
    }
    
    mutating func updateLuck(by amount: Int) {
        luck += amount
    }
    
    mutating func addItem(_ item: String) {
        if !inventory.contains(item) {
            inventory.append(item)
        }
    }
    
    mutating func removeItem(_ item: String) {
        if let index = inventory.firstIndex(of: item) {
            inventory.remove(at: index)
        }
    }
    
    func hasItem(_ item: String) -> Bool {
        return inventory.contains(item)
    }
    
    mutating func combat(enemyStrength: Int) -> Bool {
        let combatResult = (strength + luck) - enemyStrength
        if combatResult > 0 {
            return true // Победа
        } else {
            updateHealth(by: combatResult) // Потеря здоровья при поражении
            return false
        }
    }
}

