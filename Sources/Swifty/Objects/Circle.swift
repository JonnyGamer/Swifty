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
    var shape: SKShapeNode = SKShapeNode()
    override var node: SKNode { get { shape } set { shape = newValue as! SKShapeNode } }
    public var __shape__: SKShapeNode { shape }
    
    private enum CodingKeys: String, CodingKey {
        case Color, Radius
    }
    
    var Width: OptionalDouble?
    var Height: OptionalDouble?
    var Color: OptionalColor?
    var Radius: OptionalDouble?
    
    public var color: Color { get { _color } set { _color = newValue } }
    
    private func updateValues() {
        color = color
    }
    
    public init(radius: CGFloat) {
        shape.path = SKShapeNode.init(circleOfRadius: radius).path
        super.init()
        color = .white
        updateValues()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        Radius = try container.decodeIfPresent(OptionalDouble.self, forKey: .Radius)
        shape.path = SKShapeNode.init(circleOfRadius: Radius?.value ?? 0.0).path
        Color = try container.decodeIfPresent(OptionalColor.self, forKey: .Color)
        
        try super.init(from: decoder)
        
        updateValues()
    }
    
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(Color, forKey: .Color)
        try container.encodeIfPresent(Radius, forKey: .Radius)
        try super.encode(to: encoder)
    }
}
