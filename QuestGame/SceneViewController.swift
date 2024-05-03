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
        view.backgroundColor = .systemMint
        navigationItem.title = "Игра"
        navigationItem.hidesBackButton = true
        updateUI()
    }
    
    func setScene(_ newScene: Scene, game: Game, character: Character) {
        self.scene = newScene
        self.game = game
        self.character = character
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
        sceneImageView.image = UIImage(named: "images")
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

        // Кнопки выбора
        var yOffset = 290
        
        for (index, choice) in scene.choices.enumerated() {
            if let reqItem = choice.requiredItem, !character.hasItem(reqItem) {
                continue
            }
            let choiceButton = UIButton(type: .system)
            choiceButton.frame = CGRect(x: 20, y: yOffset, width: Int(view.bounds.width - 40), height: 100)
            choiceButton.setTitle(choice.text, for: .normal)
            choiceButton.backgroundColor = .lightText
            choiceButton.setTitleColor(.black, for: .normal)
            choiceButton.layer.borderWidth = 2
            choiceButton.layer.borderColor = UIColor.systemBlue.cgColor
            choiceButton.titleLabel?.numberOfLines = 0 // Убираем ограничение на количество строк
            choiceButton.titleLabel?.lineBreakMode = .byWordWrapping // Перенос по словам
            choiceButton.layer.cornerRadius = 10
            choiceButton.tag = index
            choiceButton.addTarget(self, action: #selector(handleChoice(_:)), for: .touchUpInside)
            view.addSubview(choiceButton)
            yOffset += 110
        }
    }

    @objc func handleChoice(_ sender: UIButton) {
        let choice = scene.choices[sender.tag]
        choice.effect?(&character)  // Применяем эффект выбора к персонажу

        if let nextScene = game.scenes[choice.destination ?? ""] {
            let nextVC = SceneViewController()
            nextVC.setScene(nextScene, game: game, character: character)  // Настраиваем новый контроллер
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            showAlertEndGame()
        }
    }

    private func showAlertEndGame() {
        let alert = UIAlertController(title: "Игра окончена", message: "Ваше приключение подошло к концу. Спасибо за игру!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
