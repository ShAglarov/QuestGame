//
//  ViewController.swift
//  QuestGame
//
//  Created by Shamil Aglarov on 02.05.2024.
//

import UIKit

// Класс SceneViewController, управляющий сценой в квест-игре
class SceneViewController: UIViewController {
    // Свойства для сцены, персонажа и игры
    var scene: Scene!
    var character: Character!
    var game: Game!

    // Метод, вызываемый после загрузки вида в память
    override func viewDidLoad() {
        super.viewDidLoad()
        // Устанавливаем фоновое изображение для вида
        view.backgroundColor = UIColor(patternImage: UIImage(named: "laboratoriyquest")!)
        // Настраиваем заголовок навигации и его внешний вид
        navigationItem.title = "Квест"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.hidesBackButton = true
        // Обновляем пользовательский интерфейс
        updateUI()
    }
    
    // Метод для настройки сцены, игры и персонажа для контроллера вида
    func setScene(_ newScene: Scene, game: Game, character: Character) {
        // Обновляем свойства
        self.scene = newScene
        self.game = game
        self.character = character
        // Устанавливаем делегаты для завершения игры и изменения состояния персонажа
        self.game.gameOverDelegate = self
        self.character.delegate = self
        // Обновляем пользовательский интерфейс с новыми деталями сцены
        updateUI()
    }
    
    // Метод для обновления элементов пользовательского интерфейса
    private func updateUI() {
        // Удаляем все subview с основного вида
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        
        // Создаем метку для описания сцены
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0 // Позволяет расширять текст на несколько строк
        descriptionLabel.text = "\n" + scene.description + "\n"
        descriptionLabel.backgroundColor = .placeholderText
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 19)
        descriptionLabel.textColor = .white
        descriptionLabel.layer.cornerRadius = 10
        descriptionLabel.layer.masksToBounds = true
        descriptionLabel.textAlignment = .center
        
        // Добавляем метку с описанием на вид
        view.addSubview(descriptionLabel)
        
        // Устанавливаем ограничения для метки описания
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        // Создаем и настраиваем ImageView для сцены
        let sceneImageView = UIImageView()
        sceneImageView.translatesAutoresizingMaskIntoConstraints = false
        sceneImageView.contentMode = .scaleAspectFill // Сохраняет пропорции изображения
        sceneImageView.image = scene.image
        sceneImageView.layer.cornerRadius = 20 // Радиус скругления углов
        sceneImageView.layer.masksToBounds = true // Обрезает содержимое по границам
        
        // Добавляем ImageView на основной вид
        view.addSubview(sceneImageView)
        
        // Устанавливаем ограничения для сцены ImageView
        NSLayoutConstraint.activate([
            sceneImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            sceneImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            sceneImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            sceneImageView.heightAnchor.constraint(equalToConstant: 600) // Устанавливаем высоту изображения
        ])
        
        // Создаем метку для отображения количества жизней персонажа
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

        // Добавляем метку с количеством жизней на вид
        view.addSubview(healthLbl)
        
        // Устанавливаем ограничения для метки с количеством жизней
        NSLayoutConstraint.activate([
            healthLbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            healthLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // Создаем метку для отображения инвентаря персонажа
        let inventoryLbl = UILabel()
        inventoryLbl.translatesAutoresizingMaskIntoConstraints = false
        inventoryLbl.numberOfLines = 0 // Позволяет метке расширяться на несколько строк
        inventoryLbl.backgroundColor = .placeholderText
        inventoryLbl.font = UIFont.boldSystemFont(ofSize: 19)
        inventoryLbl.textColor = .white
        inventoryLbl.layer.cornerRadius = 10
        inventoryLbl.layer.masksToBounds = true
        inventoryLbl.textAlignment = .center

        // Создаем начальный текст для инвентаря
        let inventoryText = NSMutableAttributedString(string: "Инвентарь: ")

        // Проходимся по предметам в инвентаре персонажа и добавляем их изображения
        for itemName in character.inventory {
            if let inventoryImage = UIImage(named: itemName) {
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = inventoryImage
                imageAttachment.bounds = CGRect(x: 0, y: -5, width: 25, height: 25)

                // Добавляем изображение в текст инвентаря
                let imageString = NSAttributedString(attachment: imageAttachment)
                inventoryText.append(imageString)
                inventoryText.append(NSAttributedString(string: " ")) // Добавляем пробел после каждого изображения
            }
        }

        // Устанавливаем атрибутированный текст для метки инвентаря
        inventoryLbl.attributedText = inventoryText
        
        // Добавляем метку инвентаря на вид и устанавливаем ограничения
        view.addSubview(inventoryLbl)
        NSLayoutConstraint.activate([
            inventoryLbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -13),
            inventoryLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // Инициализируем начальное смещение для кнопок выбора
        var yOffset = 310
        
        // Проходимся по всем вариантам выбора сцены
        for (index, choice) in scene.choices.enumerated() {
            // Если требуемый предмет не найден в инвентаре персонажа, пропускаем этот выбор
            if let reqItem = choice.requiredItem, !character.hasItem(reqItem) {
                continue
            }

            // Создаем кнопку для варианта выбора
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

            // Устанавливаем прозрачность для кнопки
            choiceButton.alpha = 0.8 // Примерно 80% видимости

            // Создаем UIImageView для фона кнопки
            let imageView = UIImageView(frame: choiceButton.bounds)
            imageView.contentMode = .scaleAspectFill // Масштабирует содержимое для заполнения размера кнопки с сохранением пропорций
            imageView.clipsToBounds = true // Обрезаем изображение по границам UIImageView

            // Устанавливаем изображение фона кнопки
            if let image = UIImage(named: "buttonclick") {
                imageView.image = image
            }

            // Добавляем фоновое изображение на кнопку
            choiceButton.addSubview(imageView)
            choiceButton.sendSubviewToBack(imageView) // Помещаем изображение под текст кнопки

            // Обрезаем изображение в пределах кнопки
            choiceButton.clipsToBounds = true

            // Привязываем метод обработки выбора к кнопке
            choiceButton.addTarget(self, action: #selector(handleChoice(_:)), for: .touchUpInside)
            view.addSubview(choiceButton)

            // Увеличиваем смещение для следующей кнопки выбора
            yOffset += 110
        }
    }
    
    // Обрабатываем нажатие на вариант выбора
    @objc func handleChoice(_ sender: UIButton) {
        // Получаем выбор из массива по тегу кнопки
        let choice = scene.choices[sender.tag]
        // Применяем эффект выбора к персонажу
        choice.effect?(&character)

        // Обрабатываем выбор через объект игры
        game.processChoice(choice: choice)
        // Создаем новый контроллер сцены
        let nextVC = SceneViewController()
        // Настраиваем новый контроллер с текущей сценой игры
        nextVC.setScene(game.currentScene, game: game, character: character)
        // Переходим к новому контроллеру сцены
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // Показать предупреждение об окончании игры
    private func showAlertEndGame() {
        let alert = UIAlertController(title: "Поздравляем квест пройден", message: "Ваше приключение подошло к концу. Спасибо за игру!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }

    // Показать предупреждение о смерти персонажа
    private func showAlertDead() {
        let alert = UIAlertController(title: "Вы погибли", message: "Начните игру заново!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

// Расширение SceneViewController для работы с делегатами завершения игры и смерти персонажа
extension SceneViewController: GameOverDelegate, DeadhDelegate {
    // Реализуем метод завершения игры
    func gameOver() {
        showAlertEndGame()
    }

    // Реализуем метод смерти персонажа
    func dead() {
        showAlertDead()
    }
}
