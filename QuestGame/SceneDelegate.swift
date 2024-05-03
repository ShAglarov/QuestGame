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
            image: UIImage(named: "lab"),
            choices: [
                Choice(text: "Войти в главный зал", destination: Roads.mainHall, requiredItem: nil, effect: nil),
                Choice(text: "Обойти лабораторию и искать другой вход", destination: Roads.trapped, requiredItem: nil, effect: { $0.updateHealth(by: -6) }),
                Choice(text: "Уйти и вызвать подкрепление", destination: "подкрепление", requiredItem: nil, effect: { $0.updateHealth(by: -6) })
            ])
        
        scenes["подкрепление"] = Scene(
            description: "Вам сообщают что подкрепление прибудет только через 3 часа, ждать очень долго поэтому вы должны решаеть что делать", image: UIImage(named: "reinforcement"),
            choices: [
                Choice(text: "Войти в главный зал", destination: Roads.mainHall, requiredItem: nil, effect: { $0.updateHealth(by: -6) }),
                Choice(text: "Обойти лабораторию и искать другой вход", destination: Roads.trapped, requiredItem: nil, effect: { $0.updateHealth(by: -6) }),
            ])
        
        
        // Сцена: Главный зал
        scenes[Roads.mainHall] = Scene(
            description: "Вы в главном зале лаборатории, вас встречает охранник и вы представляетесь сотрудником лаборатории и идете дальше. (бЗзз...бЗзз...) Странный шум доносится из лаборатории.",
            image: UIImage(named: "secretLab"),
            choices: [
                Choice(text: "Исследовать источник шума в лаборатории", destination: Roads.laboratory, requiredItem: nil, effect: { $0.updateHealth(by: -6) }),
                Choice(text: "Пойти в комнату управления", destination: Roads.controlRoom, requiredItem: nil, effect: { $0.updateHealth(by: -6) }),
                Choice(text: "Искать запасной выход", destination: Roads.escapeRoute, requiredItem: nil, effect: { $0.updateHealth(by: -6) })
            ])
        
        scenes["портал"] = Scene(
            description: "О, вы взглянули на часы и с удивлением обнаружили, что время как будто откатилось на час назад.", image: UIImage(named: "timeportalon"),
            choices: [
                Choice(text: "Выйти из портала и осмотреться куда вы попали", destination: "вернулсявпортал", requiredItem: nil, effect: { $0.updateHealth(by: -6) })
            ])
        
        // Сцена: Лаборатория
        scenes[Roads.laboratory] = Scene(
            description: "В лаборатории везде разбросаны химические реактивы. В углу виднеется нестабильно мерцающий экспериментальный аппарат.", image: UIImage(named: "randomcolorlab"),
            choices: [
                Choice(text: "Попробовать отключить аппарат", destination: Roads.escapeRoute, requiredItem: "инструменты", effect: { $0.updateHealth(by: -10) }),
                Choice(text: "Вернуться в главный зал", destination: Roads.mainHall, requiredItem: nil, effect: { $0.updateHealth(by: -6) })
            ])
        
        // Сцена: Комната управления
        scenes[Roads.controlRoom] = Scene(
            description: "Вы в комнате управления, полной технических панелей и мониторов. Есть возможность восстановить системы безопасности.", image: UIImage(named: "monitorroom"),
            choices: [
                Choice(text: "Активировать системы безопасности", destination: Roads.escapeRoute, requiredItem: nil, effect: { $0.updateHealth(by: -5) }),
                Choice(text: "Попытаться найти информацию о лаборатории", destination: Roads.trapped, requiredItem: nil, effect: { $0.updateHealth(by: -6) })
            ])
        
        // Сцена: В главном зале снова
        scenes["вернулсявпортал"] = Scene(
            description: "Вы вернулись в главный зал. Может быть, что-то упустили?", 
            image: UIImage(named: "returnmainroom"),
            choices: [
                Choice(text: "Осмотреть заброшенное оборудование", destination: Roads.trapped, requiredItem: nil, effect: { $0.updateHealth(by: -6) }),
                Choice(text: "Проверить другие двери в зале", destination: Roads.laboratory, requiredItem: nil, effect: { $0.updateHealth(by: -6) }),
                Choice(text: "Исследовать комнату управления еще раз", destination: Roads.controlRoom, requiredItem: nil, effect: { $0.updateHealth(by: -6) }),
                Choice(text: "Попытаться открыть секретный проход", destination: Roads.escapeRoute, requiredItem: "keyout", effect: { $0.updateHealth(by: -10) })
            ])
        
        // Обновление сцены: Ловушка
        scenes[Roads.trapped] = Scene(
            description: "Вы активировали ловушку, и теперь в комнате начинается заполнение ядовитым газом.", 
            image: UIImage(named: "gazactiv"),
            choices: [
                Choice(text: "Использовать газовую маску", destination: Roads.escapeRoute, requiredItem: "газовая маска", effect: { $0.updateHealth(by: -6) }),
                Choice(text: "Искать альтернативный выход", destination: Roads.alternativeExit, requiredItem: nil, effect: { $0.updateHealth(by: -10) }),
                Choice(text: "Сдаться и ждать конца", destination: Roads.gameover, requiredItem: nil,
                       effect: { $0.updateHealth(by: -100) })
            ])
        
        // Добавление новой сцены: Альтернативный выход
        scenes[Roads.alternativeExit] = Scene(
            description: "Вы ищете альтернативный выход. С каждой секундой дыхание становится тяжелее, но впереди вы замечаете слабо освещенный коридор.", 
            image: UIImage(named: "alternativroom"),
            choices: [
                Choice(text: "Попробовать пробраться через коридор", destination: Roads.narrowEscape, requiredItem: nil, effect: { $0.updateHealth(by: -5) }),
                Choice(text: "Вернуться и использовать газовую маску", destination: Roads.trapped, requiredItem: "газовая маска", effect: { $0.updateHealth(by: 15) }),
                Choice(text: "Продолжить искать другие выходы", destination: Roads.desperateSearch, requiredItem: nil, effect: { $0.updateHealth(by: -10) })
            ])
        
        // Сцена: Узкий побег
        scenes[Roads.narrowEscape] = Scene(
            description: "Пробираясь через узкий коридор, вы чудом избегаете обрушения стены. Вы находите небольшую дверь, которая ведет наружу.", 
            image: UIImage(named: "dangerroom"),
            choices: [
                Choice(text: "Использовать дверь для выхода", destination: Roads.escapeRoute, requiredItem: nil, effect: { $0.updateHealth(by: 20) }),
                Choice(text: "Исследовать коридор дальше", destination: Roads.desperateSearch, requiredItem: nil, effect: { $0.updateHealth(by: -15) })
            ])
        
        // Сцена: Отчаянный поиск
        scenes[Roads.desperateSearch] = Scene(
            description: "Отчаянно ища другие выходы, вы обнаруживаете закрытый вентиляционный люк. Возможно, его можно открыть.", 
            image: UIImage(named: "closedventluc"),
            choices: [
                Choice(text: "Попытаться открыть люк", destination: Roads.ventEscape, requiredItem: "инструменты", effect: { $0.updateHealth(by: -6) }),
                Choice(text: "Вернуться к поиску через коридор", destination: Roads.narrowEscape, requiredItem: nil, effect: { $0.updateHealth(by: -5) })
            ])
        
        // Сцена: Побег через вентиляцию
        scenes[Roads.ventEscape] = Scene(
            description: "Используя найденные инструменты, вы открываете вентиляционный люк и пробираетесь через узкие туннели. Это сложно, но вы чувствуете, что приближаетесь к свободе.", 
            image: UIImage(named: "goluc"),
            choices: [
                Choice(text: "Продолжить движение вперед", destination: Roads.freedom, requiredItem: nil, effect: { $0.updateHealth(by: -5) }),
                Choice(text: "Вернуться и попробовать другой путь", destination: Roads.desperateSearch, requiredItem: nil, effect: { $0.updateHealth(by: -10) })
            ])
        
        scenes[Roads.gameover] = Scene(
            description: "Вы медленно стали засыпать, и через пять минут уснули - навсегда", 
            image: UIImage(named: "kilgaz"),
            choices: [
                Choice(text: "Начать квест сначала", destination: Roads.start, requiredItem: nil, effect: { $0.updateHealth(by: -100) })
            ])
        
        // Добавление новой сцены: Комната с ключами
        scenes[Roads.controlRoom] = Scene(
            description: "Комната управления содержит не только технические панели, но и ящик с различными ключами и кодами.", 
            image: UIImage(named: "randomkey"),
            choices: [
                Choice(text: "Взять ключ и вернуться в главный зал", destination: Roads.mainHall, requiredItem: nil, effect: { $0.addItem("keyout") }),
                Choice(text: "Искать коды доступа", destination: Roads.searchCode, requiredItem: nil, effect: nil),
                Choice(text: "Вернуться в главный зал", destination: Roads.mainHall, requiredItem: nil, effect: { $0.updateHealth(by: -6) })
            ])
        
        scenes[Roads.searchCode] = Scene(
            description: "В ходе поиска кодов доступа, вы обнаружили временной телепорт, который так же был разработан в этой секретной лаборатории, вы сфотографировали данный портал и решили?",
            image: UIImage(named: "teleportportal"),
            choices: [
                Choice(text: "Войти в портал", destination: "портал", requiredItem: nil, effect: { $0.addItem("photodoc")}),
                Choice(text: "Вернуться назад", destination: Roads.controlRoom, requiredItem: nil, effect: { $0.addItem("photodoc") }),
            ])
        
        // Добавление финальной сцены: Выход из лаборатории
        scenes[Roads.escapeRoute] = Scene(
            description: "Вы видите перед собой 3 двери, слева, прямо, справа, в какую дверь бежать", 
            image: UIImage(named: "freedoor"),
            choices: [
                Choice(text: "Влево", destination: "попыткаОткрытьДверь", requiredItem: nil, effect: { $0.updateHealth(by: -10) }),
                Choice(text: "Прямо", destination: "попыткаОткрытьДверь", requiredItem: nil, effect: { $0.updateHealth(by: -6) }),
                Choice(text: "Вправо", destination: "спалились2", requiredItem: nil, effect: { $0.updateStrength(by: 40) })
            ])
        
        scenes["спалились2"] = Scene(
            description: "Когда вы пытались открыть дверь, мимо проходящий охранник вас заметил, спросил куда вы направляетесь?",
            image: UIImage(named: "securityseeyou"),
            choices: [
                Choice(text: "Попытаться убежать от охраны", destination: "охранникстреляет", requiredItem: nil, effect: { $0.updateHealth(by: Int.random(in: -100...0)) }),
                Choice(text: "Уверенно подойти к охраннику и спросить где тут выход", destination: "охранник", requiredItem: nil, effect: { $0.updateHealth(by: -10) })
            ])
        
        // Добавление финальной сцены: Выход из лаборатории
        scenes["keyout"] = Scene(
            description: "Вы используете ключ от выхода, чтобы открыть тяжелую стальную дверь. За дверью оказывается свежий воздух и путь к свободе. Однако за вашим спасением следует еще одно испытание.",
            image: UIImage(named: "keyopendoor"),
            choices: [
                Choice(text: "Бежать как можно быстрее", destination: Roads.freedom, requiredItem: nil, effect: { $0.updateHealth(by: -45) }),
                Choice(text: "Осторожно осмотреть территорию", destination: Roads.caution, requiredItem: nil, effect: { $0.updateHealth(by: -6) }),
                Choice(text: "Вернуться и помочь оставшимся в лаборатории", destination: Roads.heroicReturn.randomElement(), requiredItem: nil, effect: { $0.updateHealth(by: -6) })
            ])
        
        scenes["спалились"] = Scene(
            description: "Пока вы искали коды доступа и вас замечает один охранник", 
            image: UIImage(named: "seeyousecurity"),
            choices: [
                Choice(text: "Попытаться убежать от охраны", destination: "охранникстреляет", requiredItem: nil, effect: { $0.updateHealth(by: -30) }),
                Choice(text: "Уверенно подойти к охраннику и спросить где тут выход", destination: "охранник", requiredItem: nil, effect: { $0.updateHealth(by: -6) })
            ])
        
        scenes["охранник"] = Scene(
            description: "Охранник посчитав что вы сотрудник, подсказывает вам дверь к выходу!, вы идете к двери", image: UIImage(named: "securitygotoexit"),
            choices: [
                Choice(text: "Попробовать открыть дверь", destination: "попыткаОткрытьДверь", requiredItem: nil, effect: { $0.updateHealth(by: -6) }),
                Choice(text: "Вернуться назад", destination: Roads.start, requiredItem: nil, effect: { $0.updateHealth(by: -10) }),
            ])
        
        scenes["попыткаОткрытьДверь"] = Scene(
            description: "Охранник смотрит на вас задумчиво. Боже, дверь заперта, что же теперь делать?",
            image: UIImage(named: "securityquestion"),
            choices: [
                Choice(text: "Открыть дверь используя ключ который вы нашли", destination: "послеОткрытияДвери2", requiredItem: "keyout", effect: { $0.updateHealth(by: -10) }),
                Choice(text: "Оставить дверь и вернуться назад", destination: "ошибка", requiredItem: nil, effect: { $0.updateHealth(by: -10) }),
            ])
        
        scenes["послеОткрытияДвери2"] = Scene(
            description: "Выйдя из лаборатории вы стали бежать не оглядываясь", 
            image: UIImage(named: "gorunwithlab"),
            choices: [
                Choice(text: "Подумать все ли вы взяли ссобой ?", destination: "забыли", requiredItem: nil, effect: { $0.updateHealth(by: -10) }),
                Choice(text: "Вы вздохнули спокойно - Ну вот - Все опасности позади", destination: Roads.freedom, requiredItem: "photodoc", effect: { $0.updateHealth(by: -10) })
                
            ])
        
        scenes["забыли"] = Scene(
            description: "Вы хотите вернуться снова в лабораторию?",
            image: UIImage(named: "returnlab"),
            choices: [
                Choice(text: "Все же вам кажется что, что-то вы забыли, вы решаете снова вернуться в лабораторию", destination: Roads.start, requiredItem: nil, effect: { $0.updateHealth(by: -10) }),
            ])
        
        scenes["ошибка"] = Scene(
            description: "Охранник посчитал ваши действия подозрительными и понимает что вы не тот за кого себя принимаете", 
            image: UIImage(named: "searchsecurityyou"),
            choices: [
                Choice(text: "Попытаться убежать", destination: "охранникстреляет", requiredItem: nil, effect: { $0.updateHealth(by: -10) }),
            ])
        
        scenes["охранникстреляет"] = Scene(
            description: "Охранник достает свой ливарвер и стреляет в вас!",
            image: UIImage(named: "securitysearch"),
            choices: [
                Choice(text: "Спрятаться в углу", destination: Roads.escapeRoute, requiredItem: nil, effect: nil),
                Choice(text: "Зайти в одну из комнат", destination: Roads.rooms.randomElement()!, requiredItem: nil, effect: nil)
            ])
        
        // Сцена: Свобода
        scenes[Roads.freedom] = Scene(
            description: "Вы быстро покидаете территорию лаборатории, унося с собой доказательства произошедших экспериментов. Вас ждет новое расследование и возможно, новые опасности.", 
            image: UIImage(named: "outlab"),
            choices: [
                Choice(text: "Вернуться и спасти всех подопытных в лаборатории?", destination: Roads.heroicReturn.randomElement(), requiredItem: nil, effect: { $0.updateHealth(by: -6) }),
                Choice(text: "Закончить приключение", destination: nil, requiredItem: nil, effect: { $0.updateHealth(by: -6) })
            ])
        
        // Сцена: Осторожность
        scenes[Roads.caution] = Scene(
            description: "Ваша осторожность спасает вас от засады, устроенной охраной лаборатории. Вы умело избегаете конфронтации и безопасно добираетесь до города.", 
            image: UIImage(named: "incity"),
            choices: [
                Choice(text: "Закончить приключение", destination: nil, requiredItem: nil, effect: { $0.updateHealth(by: -6) })
            ])
        
        // Сцена: Героическое возвращение
        scenes[Roads.heroicReturn[0]] = Scene(
            description: "Возвращаясь, вы помогаете всем подопытным пациентам в лаборатории выбраться из заточения. Ваш героизм не остается незамеченным, и вы получаете благодарность и награды за свои действия.", 
            image: UIImage(named: "helpchild"),
            choices: [
                Choice(text: "Закончить приключение", destination: nil, requiredItem: nil, effect: { $0.updateHealth(by: -6) })
            ])
        scenes[Roads.heroicReturn[1]] = Scene(
            description: "Когда вы возвращались назад, охрана заметила вас и открыла по вам огонь, вы погибли", 
            image: UIImage(named: "sequritykillyou"),
            choices: [
                Choice(text: "Начать квест заново", destination: Roads.start, requiredItem: nil, effect: { $0.updateHealth(by: 100) })
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

