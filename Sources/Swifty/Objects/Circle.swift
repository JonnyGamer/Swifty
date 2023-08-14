//
//  Shape.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 8/7/23.
//

import SpriteKit

// Circle
public class Circle: Node, Shapeable {
    
    override var type: Types { .Circle }
    var shape: SKShapeNode!// = SKSpriteNode(color: .white, size: .zero)
    override var node: SKNode { get { shape } set { shape = newValue as? SKShapeNode } }
    public var __shape__: SKShapeNode { shape }
    
    private enum CodingKeys: String, CodingKey {
        case Color
    }
    
    var Width: OptionalDouble?
    var Height: OptionalDouble?
    var Color: OptionalColor?
    
    public var color: Color { get { _color } set { _color = newValue } }
    
    private func updateValues() {
        color = color
    }
    
    public init(radius: CGFloat) {
        shape = SKShapeNode.init(circleOfRadius: radius)
        super.init()
        color = .white
        updateValues()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        Color = try container.decodeIfPresent(OptionalColor.self, forKey: .Color)
        updateValues()
    }
    
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(Color, forKey: .Color)
        try super.encode(to: encoder)
    }
}
