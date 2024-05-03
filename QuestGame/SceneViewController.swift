//
//  ViewController.swift
//  QuestGame
//
//  Created by Shamil Aglarov on 02.05.2024.
//

import UIKit

class SceneViewController: UIViewController {
    var scene: Scene!
    var character: Character!
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "laboratoriyquest")!)
        navigationItem.title = "Квест"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.hidesBackButton = true
        updateUI()
    }
    
    func setScene(_ newScene: Scene, game: Game, character: Character) {
        self.scene = newScene
        self.game = game
        self.character = character
        self.game.gameOverDelegate = self
        self.character.delegate = self
        updateUI()  // Обновляем UI при установке новой сцены
    }
    
    private func updateUI() {
        // Удаляем все текущие subviews
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        
        // Описание сцены
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0 // Позволяет метке расширяться на несколько строк
        descriptionLabel.text = "\n" + scene.description + "\n"
        descriptionLabel.backgroundColor = .placeholderText
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 19)
        descriptionLabel.textColor = .white
        descriptionLabel.layer.cornerRadius = 10
        descriptionLabel.layer.masksToBounds = true
        descriptionLabel.textAlignment = .center
        
        // Добавление метки на view
        view.addSubview(descriptionLabel)
        
        // Настройка ограничений для метки
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        // Создание и настройка UIImageView
        let sceneImageView = UIImageView()
        sceneImageView.translatesAutoresizingMaskIntoConstraints = false
        sceneImageView.contentMode = .scaleAspectFill // Режим отображения содержимого
        sceneImageView.image = scene.image
        sceneImageView.layer.cornerRadius = 20 // Радиус скругления углов
        sceneImageView.layer.masksToBounds = true // Ограничение содержимого границами UIImageView
        
        // Добавление изображения на view
        view.addSubview(sceneImageView)
        
        // Настройка ограничений для изображения
        NSLayoutConstraint.activate([
            sceneImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            sceneImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            sceneImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            sceneImageView.heightAnchor.constraint(equalToConstant: 600) // Высота изображения
        ])
        
        let healthLbl = UILabel()
        healthLbl.translatesAutoresizingMaskIntoConstraints = false
        healthLbl.numberOfLines = 0 // Позволяет метке расширяться на несколько строк
        healthLbl.text = "Количество жизней: \(character.health)"
        healthLbl.backgroundColor = .placeholderText
        healthLbl.font = UIFont.boldSystemFont(ofSize: 19)
        healthLbl.textColor = .white
        healthLbl.layer.cornerRadius = 10
        healthLbl.layer.masksToBounds = true
        healthLbl.textAlignment = .center
        
        // Добавление метки на view
        view.addSubview(healthLbl)
        
        // Настройка ограничений для метки
        NSLayoutConstraint.activate([
            healthLbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            healthLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
           // healthLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        // Create and configure the label
                let inventoryLbl = UILabel()
                inventoryLbl.translatesAutoresizingMaskIntoConstraints = false
                inventoryLbl.numberOfLines = 0 // Allows the label to expand onto multiple lines
                inventoryLbl.backgroundColor = .placeholderText
                inventoryLbl.font = UIFont.boldSystemFont(ofSize: 19)
                inventoryLbl.textColor = .white
                inventoryLbl.layer.cornerRadius = 10
                inventoryLbl.layer.masksToBounds = true
                inventoryLbl.textAlignment = .center

                // Start with the label text
                let inventoryText = NSMutableAttributedString(string: "Инвентарь: ")

                // Assuming character.inventory is accessible and contains image names
                for itemName in character.inventory {
                    if let inventoryImage = UIImage(named: itemName) {
                        let imageAttachment = NSTextAttachment()
                        imageAttachment.image = inventoryImage

                        imageAttachment.bounds = CGRect(x: 0, y: -5, width: 25, height: 25)

                        // Append image to the text
                        let imageString = NSAttributedString(attachment: imageAttachment)
                        inventoryText.append(imageString)
                        inventoryText.append(NSAttributedString(string: " ")) // Add a space after each image
                    }
                }

                // Set the attributed text
                inventoryLbl.attributedText = inventoryText
                
                // Add the label to the view and set constraints
                view.addSubview(inventoryLbl)
        
        // Настройка ограничений для метки
        NSLayoutConstraint.activate([
            inventoryLbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -13),
            inventoryLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
           // healthLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        // Кнопки выбора
        var yOffset = 310
        
        for (index, choice) in scene.choices.enumerated() {
            if let reqItem = choice.requiredItem, !character.hasItem(reqItem) {
                continue
            }
            let choiceButton = UIButton(type: .system)
            choiceButton.frame = CGRect(x: 20, y: yOffset, width: Int(view.bounds.width - 40), height: 100)
            choiceButton.setTitle(choice.text, for: .normal)
            choiceButton.setTitleColor(.white, for: .normal)
            choiceButton.layer.borderWidth = 1
            choiceButton.layer.borderColor = UIColor.systemYellow.cgColor
            choiceButton.layer.cornerRadius = 50 // Для овальной формы
            choiceButton.titleLabel?.numberOfLines = 0
            choiceButton.titleLabel?.lineBreakMode = .byWordWrapping
            choiceButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            choiceButton.tag = index
            
            // Установка прозрачности
            choiceButton.alpha = 0.8  // Примерно 80% видимости
            
            // Создание UIImageView для фона кнопки
            let imageView = UIImageView(frame: choiceButton.bounds)
            imageView.contentMode = .scaleAspectFill // Масштабирует содержимое для заполнения размера view с сохранением пропорций, возможно обрезка
            imageView.clipsToBounds = true // Обрезаем изображение по границам UIImageView
            
            if let image = UIImage(named: "buttonclick") {
                imageView.image = image
            }
            
            choiceButton.addSubview(imageView)
            choiceButton.sendSubviewToBack(imageView) // Поместим изображение под текст кнопки
            
            // Установка clipToBounds после добавления imageView на кнопку
            choiceButton.clipsToBounds = true
            
            choiceButton.addTarget(self, action: #selector(handleChoice(_:)), for: .touchUpInside)
            view.addSubview(choiceButton)
            yOffset += 110
        }
    }
    
    @objc func handleChoice(_ sender: UIButton) {
        let choice = scene.choices[sender.tag]
        choice.effect?(&character)  // Применяем эффект выбора к персонажу
        
        game.processChoice(choice: choice)
        let nextVC = SceneViewController()
        // Настраиваем новый контроллер с текущей сценой игры
        nextVC.setScene(game.currentScene, game: game, character: character)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func showAlertEndGame() {
        let alert = UIAlertController(title: "Поздравляем квест пройден", message: "Ваше приключение подошло к концу. Спасибо за игру!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
    private func showAlertDead() {
        let alert = UIAlertController(title: "Вы погибли", message: "Начните игру заново!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

extension SceneViewController: GameOverDelegate, DeadhDelegate {
    func gameOver() {
        showAlertEndGame()
    }
    
    func dead() {
        showAlertDead()
    }
}
