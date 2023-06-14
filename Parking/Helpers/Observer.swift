//
//  Observer.swift
//  Parking
//
//  Created by Didar Bakhitzhanov on 14.06.2023.
//

import Foundation

class Observer<T> {
    typealias Listener = (T) -> ()
    
    private var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(value: T) {
        self.value = value
    }
    
    private var observerBlock: ((T?) -> Void)?
    
    func bind(listener: @escaping Listener) {
        self.listener = listener
        listener(value)
    }
}
