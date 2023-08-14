//
//  Text.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 8/4/23.
//

import SpriteKit

/// Create a node that displays text
public class Text: Node, Textable {
    
    override var type: Types { .Text }
    private var _text: SKLabelNode = SKLabelNode(text: "")
    override var node: SKNode { get { _text } set { _text = newValue as! SKLabelNode } }
    public var __text__: SKLabelNode { _text }
    
    /// Initialize the text with a list of strings i.e. `Text("Line 1", "Line 2")`
    public init(_ text: String...) {
        super.init()
        self.text = text.joined(separator: "\n")
        self._text.numberOfLines = -1
        updateValues()
    }
    
    public var text: String { get { _text } set { _text = newValue } }
    public var font: FontList { get { _font } set { _font = newValue } }
    public var color: Color { get { _color } set { _color = newValue } }
    public var vertical: Vertical { get { _vertical } set { _vertical = newValue } }
    public var horizontal: Horizontal { get { _horizontal } set { _horizontal = newValue } }
    
    private func updateValues() {
        text = text
        font = font
        color = color
        vertical = vertical
        horizontal = horizontal
    }
    
    private enum CodingKeys: String, CodingKey {
        case Text, Font, Color, Vertical, Horizontal
    }
    
    var Text: OptionalString?
    var Font: OptionalFont?
    var Color: OptionalColor?
    var Vertical: OptionalVertical?
    var Horizontal: OptionalHorizontal?
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        Text = try container.decodeIfPresent(OptionalString.self, forKey: .Text)
        Font = try container.decodeIfPresent(OptionalFont.self, forKey: .Font)
        Color = try container.decodeIfPresent(OptionalColor.self, forKey: .Color)
        Vertical = try container.decodeIfPresent(OptionalVertical.self, forKey: .Vertical)
        Horizontal = try container.decodeIfPresent(OptionalHorizontal.self, forKey: .Horizontal)
        updateValues()
    }
    
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(Text, forKey: .Text)
        try container.encodeIfPresent(Font, forKey: .Font)
        try container.encodeIfPresent(Color, forKey: .Color)
        try container.encodeIfPresent(Vertical, forKey: .Vertical)
        try container.encodeIfPresent(Horizontal, forKey: .Horizontal)
        try super.encode(to: encoder)
    }

    
    /// Turn a text node into a big connected physics body!
//    /// Waring: It get's very bouncy with longer text
//    var copyWithPhysicsConnected: Node {
//        return stamp.makeEverythingConnected()
//    }
//    /// Split a text node into a bunch of character physics bodies!
//    var copyWithPhysicsDisconnected: Node {
//        return stamp.makeEverythingDisconnected()
//    }
}

