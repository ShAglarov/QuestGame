//
//  SceneDelegate.swift
//  QuestGame
//
//  Created by Shamil Aglarov on 02.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        self.window = window
        
        let character = Character(health: 100, strength: 10, luck: 5, inventory: [])
        let scenes = createScenes()
        let game = Game(startScene: Roads.start, scenes: scenes, character: character)
        
        let initialVC = SceneViewController()
        initialVC.scene = scenes[Roads.start]
        initialVC.character = character
        initialVC.game = game
        
        let navigationController = UINavigationController(rootViewController: initialVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func createScenes() -> [String: Scene] {
        var scenes = [String: Scene]()
        
        // Сцена: Начало приключения
        scenes[Roads.start] = Scene(
            description: "Вы находитесь у входа в секретную лабораторию. Куда пойдете?",
            choices: [
                Choice(text: "Войти в главный зал", destination: Roads.mainHall, requiredItem: nil, effect: nil),
                Choice(text: "Обойти лабораторию и искать другой вход", destination: Roads.trapped, requiredItem: nil, effect: nil),
                Choice(text: "Уйти и вызвать подкрепление", destination: "подкрепление", requiredItem: nil, effect: { $0.updateHealth(by: 20) })
            ])
        
        scenes["подкрепление"] = Scene(
            description: "Вам сообщают что подкрепление прибудет только через 3 часа, ждать очень долго поэтому вы должны решаеть что делать",
            choices: [
                Choice(text: "Войти в главный зал", destination: Roads.mainHall, requiredItem: nil, effect: nil),
                Choice(text: "Обойти лабораторию и искать другой вход", destination: Roads.trapped, requiredItem: nil, effect: nil),
            ])
        
        
        // Сцена: Главный зал
        scenes[Roads.mainHall] = Scene(
            description: "Вы в главном зале лаборатории, вас встречает охранник и вы представляетесь сотрудником лаборатории и идете дальше. (бЗзз...бЗзз...) Странный шум доносится из лаборатории.",
            choices: [
                Choice(text: "Исследовать источник шума в лаборатории", destination: Roads.laboratory, requiredItem: nil, effect: nil),
                Choice(text: "Пойти в комнату управления", destination: Roads.controlRoom, requiredItem: nil, effect: nil),
                Choice(text: "Искать запасной выход", destination: Roads.escapeRoute, requiredItem: nil, effect: nil)
            ])
        
        scenes["портал"] = Scene(
            description: "О, вы взглянули на часы и с удивлением обнаружили, что время как будто откатилось на час назад.",
            choices: [
                Choice(text: "Выйти из портала и осмотреться куда вы попали", destination: "вернулсявпортал", requiredItem: nil, effect: nil)
            ])
        
        // Сцена: Лаборатория
        scenes[Roads.laboratory] = Scene(
            description: "В лаборатории везде разбросаны химические реактивы. В углу виднеется нестабильно мерцающий экспериментальный аппарат.",
            choices: [
                Choice(text: "Попробовать отключить аппарат", destination: Roads.escapeRoute, requiredItem: "инструменты", effect: { $0.updateHealth(by: -10) }),
                Choice(text: "Вернуться в главный зал", destination: Roads.mainHall, requiredItem: nil, effect: nil)
            ])
        
        // Сцена: Комната управления
        scenes[Roads.controlRoom] = Scene(
            description: "Вы в комнате управления, полной технических панелей и мониторов. Есть возможность восстановить системы безопасности.",
            choices: [
                Choice(text: "Активировать системы безопасности", destination: Roads.escapeRoute, requiredItem: nil, effect: { $0.updateHealth(by: 5) }),
                Choice(text: "Попытаться найти информацию о лаборатории", destination: Roads.trapped, requiredItem: nil, effect: nil)
            ])
        
        // Сцена: В главном зале снова
        scenes["вернулсявпортал"] = Scene(
            description: "Вы вернулись в главный зал. Может быть, что-то упустили?",
            choices: [
                Choice(text: "Осмотреть заброшенное оборудование", destination: Roads.trapped, requiredItem: nil, effect: nil),
                Choice(text: "Проверить другие двери в зале", destination: Roads.laboratory, requiredItem: nil, effect: nil),
                Choice(text: "Исследовать комнату управления еще раз", destination: Roads.controlRoom, requiredItem: nil, effect: nil),
                Choice(text: "Попытаться открыть секретный проход", destination: Roads.escapeRoute, requiredItem: "ключвыход", effect: { $0.updateHealth(by: 10) })
            ])
        
        // Обновление сцены: Ловушка
        scenes[Roads.trapped] = Scene(
            description: "Вы активировали ловушку, и теперь в комнате начинается заполнение ядовитым газом.",
            choices: [
                Choice(text: "Использовать газовую маску", destination: Roads.escapeRoute, requiredItem: "газовая маска", effect: { $0.updateHealth(by: 20) }),
                Choice(text: "Искать альтернативный выход", destination: Roads.alternativeExit, requiredItem: nil, effect: { $0.updateHealth(by: -10) }),
                Choice(text: "Сдаться и ждать конца", destination: Roads.gameover, requiredItem: nil, effect: { $0.updateHealth(by: -100) })
            ])
        
        // Добавление новой сцены: Альтернативный выход
        scenes[Roads.alternativeExit] = Scene(
            description: "Вы ищете альтернативный выход. С каждой секундой дыхание становится тяжелее, но впереди вы замечаете слабо освещенный коридор.",
            choices: [
                Choice(text: "Попробовать пробраться через коридор", destination: Roads.narrowEscape, requiredItem: nil, effect: { $0.updateHealth(by: -5) }),
                Choice(text: "Вернуться и использовать газовую маску", destination: Roads.trapped, requiredItem: "газовая маска", effect: { $0.updateHealth(by: 15) }),
                Choice(text: "Продолжить искать другие выходы", destination: Roads.desperateSearch, requiredItem: nil, effect: { $0.updateHealth(by: -10) })
            ])
        
        // Сцена: Узкий побег
        scenes[Roads.narrowEscape] = Scene(
            description: "Пробираясь через узкий коридор, вы чудом избегаете обрушения стены. Вы находите небольшую дверь, которая ведет наружу.",
            choices: [
                Choice(text: "Использовать дверь для выхода", destination: Roads.escapeRoute, requiredItem: nil, effect: { $0.updateHealth(by: 20) }),
                Choice(text: "Исследовать коридор дальше", destination: Roads.desperateSearch, requiredItem: nil, effect: { $0.updateHealth(by: -15) })
            ])
        
        // Сцена: Отчаянный поиск
        scenes[Roads.desperateSearch] = Scene(
            description: "Отчаянно ища другие выходы, вы обнаруживаете закрытый вентиляционный люк. Возможно, его можно открыть.",
            choices: [
                Choice(text: "Попытаться открыть люк", destination: Roads.ventEscape, requiredItem: "инструменты", effect: nil),
                Choice(text: "Вернуться к поиску через коридор", destination: Roads.narrowEscape, requiredItem: nil, effect: { $0.updateHealth(by: -5) })
            ])
        
        // Сцена: Побег через вентиляцию
        scenes[Roads.ventEscape] = Scene(
            description: "Используя найденные инструменты, вы открываете вентиляционный люк и пробираетесь через узкие туннели. Это сложно, но вы чувствуете, что приближаетесь к свободе.",
            choices: [
                Choice(text: "Продолжить движение вперед", destination: Roads.freedom, requiredItem: nil, effect: { $0.updateHealth(by: 30) }),
                Choice(text: "Вернуться и попробовать другой путь", destination: Roads.desperateSearch, requiredItem: nil, effect: { $0.updateHealth(by: -10) })
            ])
        
        scenes[Roads.gameover] = Scene(
            description: "Вы медленно стали засыпать, и через пять минут уснули - навсегда",
            choices: [
                Choice(text: "Начать квест сначала", destination: Roads.start, requiredItem: nil, effect: { $0.updateHealth(by: -100) })
            ])
        
        // Добавление новой сцены: Комната с ключами
        scenes[Roads.controlRoom] = Scene(
            description: "Комната управления содержит не только технические панели, но и ящик с различными ключами и кодами.",
            choices: [
                Choice(text: "Взять ключ и вернуться в главный зал", destination: Roads.mainHall, requiredItem: nil, effect: { $0.addItem("ключвыход") }),
                Choice(text: "Искать коды доступа", destination: Roads.searchCode, requiredItem: nil, effect: { $0.addItem("код") }),
                Choice(text: "Вернуться в главный зал", destination: Roads.mainHall, requiredItem: nil, effect: nil)
            ])
        
        scenes[Roads.searchCode] = Scene(
            description: "В ходе поиска кодов доступа, вы обнаружили временной телепорт, который так же был разработан в этой секретной лаборатории, вы сфотографировали данный портал и решили?",
            choices: [
                Choice(text: "Войти в портал", destination: "портал", requiredItem: nil, effect: { $0.addItem("порталфото")}),
                Choice(text: "Вернуться назад", destination: Roads.controlRoom, requiredItem: nil, effect: { $0.addItem("порталфото") }),
            ])
        
        // Добавление финальной сцены: Выход из лаборатории
        scenes[Roads.escapeRoute] = Scene(
            description: "Вы видите перед собой 3 двери, слева, прямо, справа, в какую дверь бежать",
            choices: [
                Choice(text: "Влево", destination: "попыткаОткрытьДверь", requiredItem: nil, effect: { $0.updateHealth(by: 30) }),
                Choice(text: "Прямо", destination: "попыткаОткрытьДверь", requiredItem: nil, effect: { $0.updateLuck(by: 20) }),
                Choice(text: "Вправо", destination: "спалились2", requiredItem: nil, effect: { $0.updateStrength(by: 40) })
            ])
        
        scenes["спалились2"] = Scene(
            description: "Когда вы пытались открыть дверь, мимо проходящий охранник вас заметил, спросил куда вы направляетесь?",
            choices: [
                Choice(text: "Попытаться убежать от охраны", destination: "охранникстреляет", requiredItem: nil, effect: { $0.updateHealth(by: 30) }),
                Choice(text: "Уверенно подойти к охраннику и спросить где тут выход", destination: "охранник", requiredItem: nil, effect: { $0.updateHealth(by: 30) })
            ])
        
        // Добавление финальной сцены: Выход из лаборатории
        scenes["ключвыход"] = Scene(
            description: "Вы используете ключ от выхода, чтобы открыть тяжелую стальную дверь. За дверью оказывается свежий воздух и путь к свободе. Однако за вашим спасением следует еще одно испытание.",
            choices: [
                Choice(text: "Бежать как можно быстрее", destination: Roads.freedom, requiredItem: nil, effect: { $0.updateHealth(by: 30) }),
                Choice(text: "Осторожно осмотреть территорию", destination: Roads.caution, requiredItem: nil, effect: { $0.updateLuck(by: 20) }),
                Choice(text: "Вернуться и помочь оставшимся в лаборатории", destination: Roads.heroicReturn.randomElement(), requiredItem: nil, effect: { $0.updateStrength(by: 40) })
            ])
        
        scenes["спалились"] = Scene(
            description: "Пока вы искали коды доступа и вас замечает один охранник",
            choices: [
                Choice(text: "Попытаться убежать от охраны", destination: "охранникстреляет", requiredItem: nil, effect: { $0.updateHealth(by: 30) }),
                Choice(text: "Уверенно подойти к охраннику и спросить где тут выход", destination: "охранник", requiredItem: nil, effect: { $0.updateHealth(by: 30) })
            ])
        
        scenes["охранник"] = Scene(
            description: "Охранник посчитав что вы сотрудник, подсказывает вам дверь к выходу!, вы идете к двери",
            choices: [
                Choice(text: "Попробовать открыть дверь", destination: "попыткаОткрытьДверь", requiredItem: nil, effect: { $0.updateHealth(by: 30) }),
                Choice(text: "Вернуться назад", destination: Roads.start, requiredItem: nil, effect: { $0.updateHealth(by: 30) }),
            ])
        
        scenes["попыткаОткрытьДверь"] = Scene(
            description: "Охранник смотрит на вас задумчиво. Боже, дверь заперта, что же теперь делать?",
            choices: [
                Choice(text: "Открыть дверь используя ключ который вы нашли", destination: "послеОткрытияДвери2", requiredItem: "ключвыход", effect: { $0.updateHealth(by: 30) }),
                Choice(text: "Оставить дверь и вернуться назад", destination: "ошибка", requiredItem: nil, effect: { $0.updateHealth(by: 30) }),
            ])
        
        scenes["послеОткрытияДвери2"] = Scene(
            description: "Выйдя из лаборатории вы стали бежать не оглядываясь",
            choices: [
                Choice(text: "Подумать все ли вы взяли ссобой ?", destination: "забыли", requiredItem: nil, effect: { $0.updateHealth(by: 30) }),
                Choice(text: "Вы вздохнули спокойно - Ну вот - Все опасности позади", destination: Roads.freedom, requiredItem: "порталфото", effect: { $0.updateHealth(by: 30) })
                
            ])
        
        scenes["забыли"] = Scene(
            description: "Вы хотите вернуться снова в лабораторию?",
            choices: [
                Choice(text: "Все же вам кажется что, что-то вы забыли, вы решаете снова вернуться в лабораторию", destination: Roads.start, requiredItem: nil, effect: { $0.updateHealth(by: 30) }),
            ])
        
        scenes["ошибка"] = Scene(
            description: "Охранник посчитал ваши действия подозрительными и понимает что вы не тот за кого себя принимаете",
            choices: [
                Choice(text: "Попытаться убежать", destination: "охранникстреляет", requiredItem: nil, effect: { $0.updateHealth(by: 30) }),
            ])
        
        scenes["охранникстреляет"] = Scene(
            description: "Охранник достает свой ливарвер и стреляет в вас, попадая вам прямо в сердце. Вы погибаете!",
            choices: [
                Choice(text: "Начать квест сначала", destination: Roads.start, requiredItem: nil, effect: { $0.updateHealth(by: 30) }),
            ])
        
        // Сцена: Свобода
        scenes[Roads.freedom] = Scene(
            description: "Вы быстро покидаете территорию лаборатории, унося с собой доказательства произошедших экспериментов. Вас ждет новое расследование и возможно, новые опасности.",
            choices: [
                Choice(text: "Вернуться и спасти всех подопытных в лаборатории?", destination: Roads.heroicReturn.randomElement(), requiredItem: nil, effect: nil),
                Choice(text: "Закончить приключение", destination: nil, requiredItem: nil, effect: nil)
            ])
        
        // Сцена: Осторожность
        scenes[Roads.caution] = Scene(
            description: "Ваша осторожность спасает вас от засады, устроенной охраной лаборатории. Вы умело избегаете конфронтации и безопасно добираетесь до города.",
            choices: [
                Choice(text: "Закончить приключение", destination: nil, requiredItem: nil, effect: nil)
            ])
        
        // Сцена: Героическое возвращение
        scenes[Roads.heroicReturn[0]] = Scene(
            description: "Возвращаясь, вы помогаете всем подопытным пациентам в лаборатории выбраться из заточения. Ваш героизм не остается незамеченным, и вы получаете благодарность и награды за свои действия.",
            choices: [
                Choice(text: "Закончить приключение", destination: nil, requiredItem: nil, effect: nil)
            ])
        scenes[Roads.heroicReturn[1]] = Scene(
            description: "Когда вы возвращались назад, охрана заметила вас и открыла по вам огонь, вы погибли",
            choices: [
                Choice(text: "Начать квест заново", destination: Roads.start, requiredItem: nil, effect: nil)
            ])
        
        return scenes
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
    
    
}

