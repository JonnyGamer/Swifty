//
//  Physics.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 5/5/23.
//

import Foundation
import SpriteKit

@objc public protocol Physical: Nodable {
    var __physicsBody__: SKPhysicsBody { get }
}
public extension Physical {
    func addPhysics() {
        self.__node__.physicsBody = self.__physicsBody__
    }
    func removePhysics() {
        self.__node__.physicsBody = nil
        self.__physicsBody__.velocity = .zero
    }
    var willFall: Bool {
        get { self.__physicsBody__.affectedByGravity }
        set { self.__physicsBody__.affectedByGravity = newValue }
    }
    var canMove: Bool {
        get { self.__physicsBody__.isDynamic }
        set { self.__physicsBody__.isDynamic = newValue }
    }
    var pinned: Bool {
        get { self.__physicsBody__.pinned }
        set { self.__physicsBody__.pinned = newValue }
    }
    var canSpin: Bool {
        get { self.__physicsBody__.allowsRotation }
        set { self.__physicsBody__.allowsRotation = newValue }
    }
    var friction: Double {
        get { Double(self.__physicsBody__.friction) }
        set { self.__physicsBody__.friction = CGFloat(newValue) }
    }
    var airFriction: Double {
        get { Double(self.__physicsBody__.linearDamping) }
        set {
            self.__physicsBody__.linearDamping = CGFloat(newValue)
            self.__physicsBody__.angularDamping = CGFloat(newValue)
        }
    }
    var bounciness: Double {
        get { Double(self.__physicsBody__.restitution) }
        set { self.__physicsBody__.restitution = CGFloat(newValue) }
    }
    var xVelocity: Double {
        get { Double(self.__physicsBody__.velocity.dx) }
        set { self.__physicsBody__.velocity.dx = CGFloat(newValue) }
    }
    var yVelocity: Double {
        get { Double(self.__physicsBody__.velocity.dy) }
        set { self.__physicsBody__.velocity.dy = CGFloat(newValue) }
    }
    func isContacting<T: Nodable>(_ this: [T]) -> Bool {
        return __physicsBody__.allContactedBodies().contains(where: { i in this.contains(where: { $0.__node__ === i.node }) })
    }
    func isContacting<T: Nodable>(_ this: T) -> Bool {
        return __physicsBody__.allContactedBodies().contains(where: { $0.node === this.__node__ })
    }
    func isContacting(somethingNamed: String) -> Bool {
        return __physicsBody__.allContactedBodies().contains(where: { $0.node?.name == somethingNamed })
    }
}





