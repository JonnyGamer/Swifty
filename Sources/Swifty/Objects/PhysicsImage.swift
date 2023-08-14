//
//  PhysicsImage.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 8/7/23.
//

import SpriteKit

class SKSpriteNodePiece: SKSpriteNode {
    var pieces: Int = 0
}

// Image
@objc protocol PhysicsImagable: Boxable, Physical {
    var Pieces: OptionalInt? { get set }
    var __piece__: SKSpriteNodePiece { get }
}
extension PhysicsImagable {
    var pieces: Int {
        get { Get(Pieces, 0) }
        set { Set(&Pieces, 0, newValue, __piece__, \.pieces) }
    }
}

public class PhysicsImage: Image, PhysicsImagable {
    
    private enum CodingKeys: String, CodingKey {
        case WillFall, CanMove, Pinned, CanSpin, Friction, Drag, Bounciness, XVelocity, YVelocity, AngularVelocity, Pieces
    }
    
    // study this part after alexander
    override var type: Types { .PhysicsImage }
    var physics: SKPhysicsBody!
    public var __physics__: SKPhysicsBody { physics }
    
    var piece: SKSpriteNodePiece = SKSpriteNodePiece(color: .white, size: .zero)
    var __piece__: SKSpriteNodePiece { piece }
    
    var Pieces: OptionalInt?
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
        pieces = pieces
        node.physicsBody = __physics__
    }
    
    public override init(_ named: String) { // , containsParts: Bool = false
        super.init(named)
        // Check for transparencies ;o;
        physics = SKPhysicsBody.init(texture: __sprite__.texture!, size: CGSize.init(width: width, height: height))
        
//        if pieces != 1, !containsParts {
//            if __sprite__.hasTransparentPixels() {
//                let ps = separateParts(from: __sprite__)
//                print("Parts:", ps)
//                pieces = ps.count
//                if ps.count == 1 {
//                    __physics__ = SKPhysicsBody.init(texture: __sprite__.texture!, size: CGSize.init(width: width, height: height))
//                    print("Okay?")
//                } else {
//                    __physics__ = SKPhysicsBody()
//                    makeEverythingConnected(ps)
//                }
//            }
//        } else {
//            __physics__ = SKPhysicsBody.init(texture: __sprite__.texture!, size: CGSize.init(width: width, height: height))
//        }
//
        updateValues()
    }
    
    
    init(_ from: Image) {
        super.init()
//        width = from.width
//        height = from.height
//        color = from.color
//        colorPercentage = from.colorPercentage
        physics = SKPhysicsBody.init(texture: __sprite__.texture!, size: CGSize.init(width: from.width, height: from.height))
        updateValues()
    }
//
//
//    private func makeEverythingConnected(_ combine: [_Image]) {
//        //let combine = separateParts(from: __sprite__)
//        //let n = Node()
//        let n = self
//        currentScene.add(self)
//
//        var ps: [PhysicsImage] = []
//        for i in combine {
//            let p = PhysicsImage.init(i)
//            //n.add(p)
//            n.add(p)
//            p.__physics__.usesPreciseCollisionDetection = true
//            //p.__physics__.isDynamic = false
//            //__physics__.isDynamic = false
//            ps.append(p)
//            __physics__.transfer(p.__physics__)
//            Everything.removeNode(key: p.id)
//        }
//        //print("Parts:", ps.count)
//        for x in 0..<ps.count {
//            for y in 0..<ps.count {
//                if x == y { continue }
//                ps[x].joint(ps[y])
//            }
//        }
//        for i in ps {
//            i.deallocate()
//        }
//
//        //return n //PhysicsNode.init(n.__node__).then({ $0.__physicsBody__.usesPreciseCollisionDetection = true })
//        //return n
//    }
    
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
        Pieces = try container.decodeIfPresent(OptionalInt.self, forKey: .Pieces)
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
        try container.encodeIfPresent(Pieces, forKey: .Pieces)
        try super.encode(to: encoder)
    }
}



