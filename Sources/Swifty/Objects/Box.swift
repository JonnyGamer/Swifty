//
//  Box.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 8/3/23.
//

import SpriteKit

public class Box: Node, Boxable {
    
    override var type: Types { .Box }
    var sprite: SKSpriteNode = SKSpriteNode(color: .white, size: .zero)
    override var node: SKNode { get { sprite } set { sprite = newValue as! SKSpriteNode } }
    public var __sprite__: SKSpriteNode { sprite }
    
    private enum CodingKeys: String, CodingKey {
        case Width, Height, Color
    }
    
    var Width: OptionalDouble?
    var Height: OptionalDouble?
    var Color: OptionalColor?
    
    public var width: Double { get { _width } set { _width = newValue } }
    public var height: Double { get { _height } set { _height = newValue } }
    public var color: Color { get { _color } set { _color = newValue } }
    
    private func updateValues() {
        width = width
        height = height
        color = color
    }
    
    override init() {
        super.init()
        updateValues()
    }
    public init(width: Double, height: Double) {
        super.init()
        self.width = width
        self.height = height
        updateValues()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        Width = try container.decodeIfPresent(OptionalDouble.self, forKey: .Width)
        Height = try container.decodeIfPresent(OptionalDouble.self, forKey: .Height)
        Color = try container.decodeIfPresent(OptionalColor.self, forKey: .Color)
        updateValues()
    }
    
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(Width, forKey: .Width)
        try container.encodeIfPresent(Height, forKey: .Height)
        try container.encodeIfPresent(Color, forKey: .Color)
        try super.encode(to: encoder)
    }
    
}

//class PhysicsBox: Box, Physical {
//    var __physicsBody__: SKPhysicsBody// = SKPhysicsBody()
//    override init(width: Int, height: Int) {
//        self.__physicsBody__ = SKPhysicsBody.init(rectangleOf: CGSize.init(width: width, height: height))
//        super.init(width: width, height: height)
//        addPhysics()
//        __physicsBody__.contactTestBitMask = .max
//        __physicsBody__.collisionBitMask = .max
//        __physicsBody__.categoryBitMask = .max
//        bounciness = 0
//        friction = 0
//        airFriction = 0
//    }
//    private init(_ node: SKSpriteNode,_ physics: SKPhysicsBody) {
//        self.__physicsBody__ = physics
//        super.init(node)
//    }
//    override var copy: PhysicsBox {
//        PhysicsBox.init(node.copied, __physicsBody__.copied)
//    }
//}
//
