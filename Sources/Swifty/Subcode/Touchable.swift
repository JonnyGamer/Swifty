//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 8/15/23.
//

import SpriteKit

@objc protocol Touchable {
    var touchBegan: () -> () { get set }
    var touchEnded: () -> () { get set }
    var touchCancelled: () -> () { get set }
}


extension Sequence where Element == SKNode {
    func touched(_ touchFunc: (Touchable) -> ()) {
        for i in self {
            if let t = i as? Touchable {
                touchFunc(t)
            }
        }
    }
}
