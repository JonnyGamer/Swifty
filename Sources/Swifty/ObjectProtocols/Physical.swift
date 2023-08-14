//
//  Physical.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 8/3/23.
//

import SpriteKit

@objc protocol Physical {
    var WillFall: OptionalBool? { get set }
    var CanMove: OptionalBool? { get set }
    var Pinned: OptionalBool? { get set }
    var CanSpin: OptionalBool? { get set }
    var Friction: OptionalDouble? { get set }
    var Drag: OptionalDouble? { get set }
    var Bounciness: OptionalDouble? { get set }
    var XVelocity: OptionalDouble? { get set }
    var YVelocity: OptionalDouble? { get set }
    var AngularVelocity: OptionalDouble? { get set }
    var __physics__: SKPhysicsBody! { get }
}

extension Physical {
    var _willFall: Bool {
        get { Get(WillFall, true) }
        set { Set(&WillFall, true, newValue, __physics__, \.affectedByGravity) }
    }
    var _canMove: Bool {
        get { Get(CanMove, true) }
        set { Set(&CanMove, true, newValue, __physics__, \.isDynamic) }
    }
    var _pinned: Bool {
        get { Get(CanMove, false) }
        set { Set(&CanMove, false, newValue, __physics__, \.pinned) }
    }
    var _canSpin: Bool {
        get { Get(CanMove, true) }
        set { Set(&CanMove, true, newValue, __physics__, \.allowsRotation) }
    }
    var _friction: Double {
        get { Get(Friction, 0.0) }
        set { Set(&Friction, 0.0, newValue, __physics__, \.friction) }
    }
    var _drag: Double {
        get { Get(Drag, 0.0) }
        set {
            Set(&Drag, 0.0, newValue, __physics__, \.linearDamping)
            Set(&Drag, 0.0, newValue, __physics__, \.angularDamping)
        }
    }
    var _bounciness: Double {
        get { Get(Bounciness, 0.0) }
        set { Set(&Bounciness, 0.0, newValue, __physics__, \.restitution) }
    }
    var _xVelocity: Double {
        get { Get(XVelocity, 0.0) }
        set { Set(&XVelocity, 0.0, newValue, __physics__, \.velocity.dx) }
    }
    var _yVelocity: Double {
        get { Get(YVelocity, 0.0) }
        set { Set(&YVelocity, 0.0, newValue, __physics__, \.velocity.dx) }
    }
    var _angularVelocity: Double {
        get { Get(AngularVelocity, 0.0) }
        set { Set(&AngularVelocity, 0.0, newValue, __physics__, \.angularVelocity) { CGFloat($0.toRadians()) } }
    }
    
    func _joint<T: Physical>(_ with: T) {
        if __physics__.node?.isChildOf(trueScene) == false { fatalError("You need to add node 1 to the scene") }
        if with.__physics__.node?.isChildOf(trueScene) == false { fatalError("You need to add node 2 to the scene") }
        let fixedJoint = SKPhysicsJointFixed.joint(withBodyA: __physics__, bodyB: with.__physics__, anchor: .zero)
        trueScene.physicsWorld.add(fixedJoint)
    }
    var _isResting: Bool {
        get { __physics__.isResting }
    }
    
}
