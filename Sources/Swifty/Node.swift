//
//  Node.swift
//  Swifty
//
//  Created by Jonathan Pappas on 7/28/23.
//

import Foundation
import SpriteKit


@objc public protocol Nodable {
    var __node__: SKNode { get }
}
public extension Nodable {
    var x: Double {
        get { Double(__node__.position.x) }
        set { __node__.position.x = CGFloat(newValue) }
    }
    var y: Double {
        get { Double(__node__.position.y) }
        set { __node__.position.y = CGFloat(newValue) }
    }
    var z: Double {
        get { Double(__node__.zPosition) }
        set { __node__.zPosition = CGFloat(newValue) }
    }
    var angle: Double {
        get { Double(__node__.zRotation) * 180 / .pi }
        set { __node__.zRotation = CGFloat(newValue) * .pi / 180 }
    }
    var name: String {
        get { __node__.name ?? "" }
        set { __node__.name = newValue }
    }
    var alpha: Double {
        get { Double(__node__.alpha) }
        set { __node__.alpha = CGFloat(newValue) }
    }
    func add<T: Nodable>(_ child: T) {
        if child.__node__.parent != nil {
            print("Warning: Attempting to add a child which already has a parent.")
            return
        }
        __node__.addChild(child.__node__)
    }
}

// Node Object
public class Node: Nodable, Then {
    fileprivate var node: SKNode = SKNode()
    public var __node__: SKNode { return node }
    
    public init() {}
    fileprivate init(_ node: SKNode) { self.node = node }
    var copy: Node {
        Node.init(node.copied)
    }
}
public class PhysicsNode: Node, Physical {
    public var __physicsBody__: SKPhysicsBody = SKPhysicsBody()
    public override init() {
        super.init()
        addPhysics()
        __physicsBody__.contactTestBitMask = .max
        __physicsBody__.collisionBitMask = .max
        __physicsBody__.categoryBitMask = .max
        bounciness = 0
        friction = 0
        airFriction = 0
    }
    
    private init(_ node: SKNode,_ physics: SKPhysicsBody) { super.init(node); self.__physicsBody__ = physics }
    override var copy: PhysicsNode {
        PhysicsNode.init(node.copied, __physicsBody__.copied)
    }
}



// Text
@objc public protocol Textable: Nodable {
    var __text__: SKLabelNode { get }
}
public extension Textable {
    var text: String {
        get { __text__.text ?? "" }
        set { __text__.text = newValue }
    }
    var color: Color {
        get { (__text__.fontColor ?? .white).color() }
        set { __text__.fontColor = newValue.nsColor }
    }
    var font: String {
        get { __text__.fontName ?? "" }
        set { __text__.fontName = newValue }
    }
}
public class Text: Textable {
    private var node: SKLabelNode
    public var __node__: SKNode { return node }
    public var __text__: SKLabelNode { return node }
    public init(_ text: String...) {
        node = SKLabelNode.init(text: text.joined(separator: "\n"))
        node.fontName = "Helvetica"
        node.fontColor = .white
        if #available(macOS 10.13, *) {
            node.numberOfLines = -1
        }
    }
    
    private init(_ node: SKLabelNode) { self.node = node }
    var copy: Text {
        Text.init(node.copied)
    }
    
    func alignedTop() {
        node.verticalAlignmentMode = .top
    }
    func alignedBottom() {
        node.verticalAlignmentMode = .bottom
    }
    func alignedLeft() {
        node.horizontalAlignmentMode = .left
    }
    func alignedRight() {
        node.horizontalAlignmentMode = .right
    }
    func alignedCenterHorizontally() {
        node.horizontalAlignmentMode = .center
    }
    func alignedCenterVertically() {
        node.verticalAlignmentMode = .center
    }
}






@objc public protocol Rectanglable: Nodable {
    var __sprite__: SKSpriteNode { get }
}
public extension Rectanglable {
    var width: Double {
        get { Double(__sprite__.size.width) }
        set { __sprite__.size.width = CGFloat(newValue) }
    }
    var height: Double {
        get { Double(__sprite__.size.height) }
        set { __sprite__.size.height = CGFloat(newValue) }
    }
    var color: Color {
        get { __sprite__.color.color() }
        set { __sprite__.color = newValue.nsColor }
    }
}

// Box
public class Box: Rectanglable {
    fileprivate var node: SKSpriteNode
    public var __node__: SKNode { return node }
    public var __sprite__: SKSpriteNode { return node }
    public init(width: Int, height: Int) {
        self.node = SKSpriteNode.init(color: .white, size: CGSize.init(width: width, height: height))
    }
    
    fileprivate init(_ node: SKSpriteNode) { self.node = node }
    var copy: Box {
        Box.init(node.copied)
    }
}
public class PhysicsBox: Box, Physical {
    public var __physicsBody__: SKPhysicsBody = SKPhysicsBody()
    public override init(width: Int, height: Int) {
        super.init(width: width, height: height)
        self.__physicsBody__ = SKPhysicsBody.init(rectangleOf: CGSize.init(width: width, height: height))
        addPhysics()
        __physicsBody__.contactTestBitMask = .max
        __physicsBody__.collisionBitMask = .max
        __physicsBody__.categoryBitMask = .max
        bounciness = 0
        friction = 0
        airFriction = 0
    }
    private init(_ node: SKSpriteNode,_ physics: SKPhysicsBody) { super.init(node); self.__physicsBody__ = physics }
    override var copy: PhysicsBox {
        PhysicsBox.init(node.copied, __physicsBody__.copied)
    }
}


// Image
@objc public protocol Imagable: Rectanglable {
    var image: String { get set }
}
public class Image: Imagable {
    fileprivate var node: SKSpriteNode
    public var __node__: SKNode { return node }
    public var __sprite__: SKSpriteNode { return node }
    public init(named: String) {
        let n = SKSpriteNode.init(imageNamed: named)
        node = n
        _imageName_ = named
    }
    fileprivate var _imageName_ = ""
    public var image: String {
        get { _imageName_ }
        set {
            if newValue != _imageName_ {
                self.__sprite__.texture = SKTexture.init(imageNamed: newValue)
                _imageName_ = newValue
            }
        }
    }
    var colorPercentage: Int {
        get { Int(__sprite__.colorBlendFactor * 100) }
        set { __sprite__.colorBlendFactor = CGFloat(newValue) }
    }
    fileprivate init(_ node: SKSpriteNode,_ named: String) { self.node = node; self._imageName_ = named }
    var copy: Image {
        Image.init(node.copied, _imageName_)
    }
}
public class PhysicsImage: Image, Physical {
    public var __physicsBody__: SKPhysicsBody = SKPhysicsBody()
    public override init(named: String) {
        super.init(named: named)
        self.__physicsBody__ = SKPhysicsBody.init(rectangleOf: __sprite__.size)
        addPhysics()
        __physicsBody__.contactTestBitMask = .max
        __physicsBody__.collisionBitMask = .max
        __physicsBody__.categoryBitMask = .max
        bounciness = 0
        friction = 0
        airFriction = 0
    }
    private init(_ node: SKSpriteNode,_ physics: SKPhysicsBody,_ named: String) { super.init(node, named); self.__physicsBody__ = physics }
    override var copy: PhysicsImage {
        PhysicsImage.init(node.copied, __physicsBody__.copied, _imageName_)
    }
}
