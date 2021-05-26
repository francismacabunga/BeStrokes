//
//  Box.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 5/23/21.
//

import Foundation

final class Box<T> {
    
    // Write comment
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    
    

}
