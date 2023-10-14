//
//  Bindable.swift
//  NoBadWeather
//
//  Created by Vadim Blagodarny on 05.10.2023.
//

import Foundation

final class Bindable<T> {
    typealias Listener = (T) -> Void
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    private var listener: Listener?
    
    init(value: T) {
        self.value = value
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
}
