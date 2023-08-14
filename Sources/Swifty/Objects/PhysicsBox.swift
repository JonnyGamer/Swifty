//
//  PhysicsBox.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 8/7/23.
//

import SpriteKit

public class PhysicsBox: Box, Physical {
    
    private enum CodingKeys: String, CodingKey {
        case WillFall, CanMove, Pinned, CanSpin, Friction, Drag, Bounciness, XVelocity, YVelocity, AngularVelocity
    }
    
    // study this part after alexander
    override var type: Types { .PhysicsBox }
    var physics: SKPhysicsBody!
    public var __physics__: SKPhysicsBody { physics }
    
    var WillFall: OptionalBool?
    var CanMove: OptionalBool?
    var Pinned: OptionalBool?
    var CanSpin: OptionalBool?
    var Friction: OptionalDouble?
    var Drag: OptionalDouble?
    var Bounciness: OptionalDouble?
    var XVelocity: OptionalDouble?
    var YVelocity: OptionalDouble?
    var AngularVelocity: OptionalDouble?
    
    public var willFall: Bool { get { _willFall } set { _willFall = newValue } }
    public var canMove: Bool { get { _canMove } set { _canMove = newValue } }
    public var pinned: Bool { get { _pinned } set { _pinned = newValue } }
    public var canSpin: Bool { get { _canSpin } set { _canSpin = newValue } }
    public var friction: Double { get { _friction } set { _friction = newValue } }
    public var drag: Double { get { _drag } set { _drag = newValue } }
    public var bounciness: Double { get { _bounciness } set { _bounciness = newValue } }
    public var xVelocity: Double { get { _xVelocity } set { _xVelocity = newValue } }
    public var yVelocity: Double { get { _yVelocity } set { _yVelocity = newValue } }
    public var angularVelocity: Double { get { _angularVelocity } set { _angularVelocity = newValue } }
    public func joint<SomePhysicsNode: PhysicsNode>(_ with: SomePhysicsNode) { _joint(with) }
    
    private func updateValues() {
        if physics == nil {
            physics = SKPhysicsBody.init(rectangleOf: CGSize.init(width: width, height: height))
        }
        willFall = willFall
        canMove = canMove
        pinned = pinned
        canSpin = canSpin
        friction = friction
        drag = drag
        bounciness = bounciness
        xVelocity = xVelocity
        yVelocity = yVelocity
        angularVelocity = angularVelocity
        node.physicsBody = __physics__
    }
    
    override init() {
        super.init()
        updateValues()
    }
    
    public override init(width: Double, height: Double) {
        super.init(width: width, height: height)
        updateValues()
    }
    
    required init(from decoder: Decoder) throws {
        // For special kinds of physics bodies for later, initialize them here lol
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        WillFall = try container.decodeIfPresent(OptionalBool.self, forKey: .WillFall)
        CanMove = try container.decodeIfPresent(OptionalBool.self, forKey: .CanMove)
        Pinned = try container.decodeIfPresent(OptionalBool.self, forKey: .Pinned)
        Friction = try container.decodeIfPresent(OptionalDouble.self, forKey: .Friction)
        Drag = try container.decodeIfPresent(OptionalDouble.self, forKey: .Drag)
        Bounciness = try container.decodeIfPresent(OptionalDouble.self, forKey: .Bounciness)
        XVelocity = try container.decodeIfPresent(OptionalDouble.self, forKey: .XVelocity)
        YVelocity = try container.decodeIfPresent(OptionalDouble.self, forKey: .YVelocity)
        AngularVelocity = try container.decodeIfPresent(OptionalDouble.self, forKey: .AngularVelocity)
        updateValues()
    }
    
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(WillFall, forKey: .WillFall)
        try container.encodeIfPresent(CanMove, forKey: .CanMove)
        try container.encodeIfPresent(Pinned, forKey: .Pinned)
        try container.encodeIfPresent(Friction, forKey: .Friction)
        try container.encodeIfPresent(Drag, forKey: .Drag)
        try container.encodeIfPresent(Bounciness, forKey: .Bounciness)
        try container.encodeIfPresent(XVelocity, forKey: .XVelocity)
        try container.encodeIfPresent(YVelocity, forKey: .YVelocity)
        try container.encodeIfPresent(AngularVelocity, forKey: .AngularVelocity)
        try super.encode(to: encoder)
    }
}
