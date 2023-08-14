//
//  Imagable.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 8/7/23.
//

import SpriteKit

// Image
@objc protocol Imagable: Boxable {
    var Image: OptionalString? { get set }
    var ColorPercentage: OptionalDouble? { get set }
    var textureSize: CGSize { get set }
}
extension Imagable {
    var _image: String {
        get { Get(Image, "") }
        set { Set(&Image, "", newValue, __sprite__, \.texture) {
            let t = SKTexture.init(imageNamed: $0)
            t.filteringMode = .nearest
            self.textureSize = t.size()
            self._width = textureSize.width
            self._height = textureSize.height
            return t
        } }
    }
    var _colorPercentage: Double {
        get { Get(ColorPercentage, 0.0) }
        set { Set(&ColorPercentage, 0.0, newValue, __sprite__, \.colorBlendFactor) { $0 / 100 } }
    }
    var _width: Double {
        get { Get(Width, textureSize.width) }
        set { Set(&Width, textureSize.width, newValue, __sprite__, \.size.width) }
    }
    var _height: Double {
        get { Get(Height, textureSize.height) }
        set { Set(&Height, textureSize.height, newValue, __sprite__, \.size.height) }
    }
}

@objc protocol Stampable {
    var Stamp: OptionalNode? { get set }
}
