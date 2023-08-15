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
    var Radius: OptionalDouble? { get set }
}
extension Shapeable {
    var _color: Color {
        get { Get(Color, .white) }
        set {
            Set(&Color, .white, newValue, __shape__, \.fillColor) { $0.nsColor }
            Set(&Color, .white, newValue, __shape__, \.strokeColor) { $0.nsColor }
        }
    }
    var _radius: Double {
        get { Get(Radius, 0.0) }
        set { Set(&Radius, 0.0, newValue) }
    }
}


// Shapes
@objc protocol Polygonable: Shapeable {
    var __shape__: SKShapeNode { get }
    var Points: [CGPoint]? { get set }
    var Sides: OptionalInt? { get set }
    var Regular: OptionalBool? { get set }
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
    var _sides: Int {
        Get(Sides, _points.count)
    }
    var _regular: Bool {
        get { Get(Regular, false) }
        set { Set(&Regular, false, newValue) }
    }
}
