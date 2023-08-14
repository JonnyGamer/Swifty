//
//  Circlable.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 8/7/23.
//

import SpriteKit

// Shapes
@objc protocol Shapeable: Nodable {
    var __shape__: SKShapeNode { get }
    var Color: OptionalColor? { get set }
}
extension Shapeable {
    var _color: Color {
        get { Get(Color, .white) }
        set {
            Set(&Color, .white, newValue, __shape__, \.fillColor) { $0.nsColor }
            Set(&Color, .white, newValue, __shape__, \.strokeColor) { $0.nsColor }
        }
    }
}


// Shapes
@objc protocol Polygonable: Shapeable {
    var __shape__: SKShapeNode { get }
    var Points: [CGPoint]? { get set }
}
extension Polygonable {
    var _points: [CGPoint] {
        get { Points ?? [] }
        set {
            print("Warning: Cannot set new points for shape yet")
//            Set(&Color, .white, newValue, __shape__, \.fillColor) { $0.nsColor }
//            Set(&Color, .white, newValue, __shape__, \.strokeColor) { $0.nsColor }
        }
    }
}
