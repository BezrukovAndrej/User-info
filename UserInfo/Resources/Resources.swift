import UIKit

enum Resources {
    
    enum NameFields: String, CaseIterable {
        case firstName = "Имя"
        case secondName = "Фамилия"
        case thirdName = "Отчество"
        case dateBirthday = "Дата рождения"
        case gender = "Пол"
    }
    
    enum Gender: String, CaseIterable {
        case noSpecified = "Не указано"
        case man = "Мужской"
        case woman = "Жунский"
    }
    
    enum Fonts {
        static func avenirNextRegular(_ size: CGFloat) -> UIFont? {
            UIFont(name: "Avenir Next", size: size)
        }
    }
}
