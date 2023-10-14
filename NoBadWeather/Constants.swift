//
//  Constants.swift
//  NoBadWeather
//
//  Created by Vadim Blagodarny on 08.10.2023.
//

import Foundation
import UIKit

enum Constants {
    enum UISize {
        static let standardOffset: CGFloat = 16.0
        static let temperatureLabelFontScale = 5.0
        static let globalCornerRadius = 8.0
    }
    
    enum Strings {
        static let tempPrefix = "от "
        static let tempMiddle = " ℃ до "
        static let tempSuffix = " ℃"
        static let errorAlertTitle = "Ошибка"
        static let errorAlertOk = "Ок"
        static let locationSearchTitle = "Смотреть погоду где мы будем?"
        static let locationSearchNext = "Далее"
        static let locationSearchCancel = "Отмена"
        static let customCellDateFormat = "EEEE\ndd MMM, HH:mm"
    }
    
    enum Images {
        static let locationSearchButtonImage = UIImage(systemName: "magnifyingglass")
        static let locationCurrentButtonImage = UIImage(systemName: "location")
    }
    
    enum Colors {
        static let temperatureLabelBGColor = UIColor(white: 0, alpha: 0.1)
    }
    
    enum Id {
        static let cellId = "CellId"
    }
    
    enum Other {
        static let coderError = "init(coder:) has not been implemented"
        static let numberOfLines = -1
        static let errorCLnetwork = "Ошибка сети. VPN также может препятствовать корректной работе"
        static let errorCLnotfound = "Местоположение не найдено"
    }
}
