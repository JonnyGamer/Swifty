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
    func touchBegan() {
        for i in self {
            if let t = i as? Touchable {
                t.touchBegan()
            }
        }
    }
    func touchEnded() {
        for i in self {
            if let t = i as? Touchable {
                t.touchEnded()
            }
        }
    }
    func touchCancelled() {
        for i in self {
            if let t = i as? Touchable {
                t.touchCancelled()
            }
        }
    }
}
