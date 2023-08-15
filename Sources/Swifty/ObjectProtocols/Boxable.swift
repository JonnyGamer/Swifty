//
//  Boxable.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 8/3/23.
//

import SpriteKit

@objc protocol Boxable {
    var Width: OptionalDouble? { get set }
    var Height: OptionalDouble? { get set }
    var Color: OptionalColor? { get set }
    var __sprite__: SKSpriteNode { get }
}

extension Boxable {
    var _width: Double {
        get { Get(Width, 0.0) }
        set { Set(&Width, 0.0, newValue, __sprite__, \.size.width) }
    }
    var _height: Double {
        get { Get(Height, 0.0) }
        set { Set(&Height, 0.0, newValue, __sprite__, \.size.height) }
    }
    var _color: Color {
        get { Get(Color, .white) }
        set { Set(&Color, .white, newValue, __sprite__, \.color) { $0.nsColor } }
    }
    
    public func keepInside(width: Double, height: Double) {
        let Wmultiplier = width / self._width
        let Hmultiplier = height / self._height
        
        let checkIfTOoTall = self._width * Hmultiplier
        
        if checkIfTOoTall > width {
            self._width *= Wmultiplier
            self._height *= Wmultiplier
        } else {
            self._width *= Hmultiplier
            self._height *= Hmultiplier
        }
    }
}
