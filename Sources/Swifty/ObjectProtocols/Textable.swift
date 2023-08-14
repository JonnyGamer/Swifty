//
//  Textable.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 8/7/23.
//

import SpriteKit

// Text
@objc protocol Textable: Nodable {
    var Text: OptionalString? { get set }
    var Font: OptionalFont? { get set }
    var Color: OptionalColor? { get set }
    var Vertical: OptionalVertical? { get set }
    var Horizontal: OptionalHorizontal? { get set }
    /// Access the SpriteKit SKLabelNode object, only use if you're a pro ;)
    var __text__: SKLabelNode { get }
}
extension Textable {
    /// The characters that will be displayed.
    var _text: String {
        get { Get(Text, "") }
        set { Set(&Text, "", newValue, __text__, \.text) }
    }
    /// The font name.
    var _font: FontList {
        get { Get(Font, .Helvetica) }
        set { Set(&Font, .Helvetica, newValue, __text__, \.fontName) }
    }
    /// The font color.
    var _color: Color {
        get { Get(Color, .black) }
        set { Set(&Color, .black, newValue, __text__, \.fontColor) { $0.nsColor } }
    }
    var _vertical: Vertical {
        get { Get(Vertical, .baseline) }
        set { Set(&Vertical, .baseline, newValue, __text__, \.verticalAlignmentMode) { $0.verticalAlignmentMode() } }
    }
    var _horizontal: Horizontal {
        get { Get(Horizontal, .center) }
        set { Set(&Horizontal, .center, newValue, __text__, \.horizontalAlignmentMode) { $0.horitzonalAlignmentMode() } }
    }
}
