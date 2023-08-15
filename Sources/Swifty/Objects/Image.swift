//
//  Image.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 8/7/23.
//

import SpriteKit

//extension SKSpriteNode {
//    var image: Image {
//        return Image(origin: self)
//    }
//}

/// Create a node that displays text
public class Image: Box, Imagable {
    
    override var type: Types { .Image }
    
    /// Initialize the text with a list of strings i.e. `Text("Line 1", "Line 2")`
    public init(_ named: String) {
        super.init()
        image = named
        textureSize = __sprite__.texture?.size() ?? .zero
        updateValues()
    }
    
    init(_ from: SKTexture) {
        super.init()
        __sprite__.texture = from
        textureSize = from.size()
        updateValues()
    }
    override init() {
        super.init()
        updateValues()
    }
    
    public var image: String { get { _image } set { _image = newValue } }
    public var colorPercentage: Double { get { _colorPercentage } set { _colorPercentage = newValue } }
    public override var width: Double { get { __width } set { __width = newValue } }
    public override var height: Double { get { __height } set { __height = newValue } }
    
    private func updateValues() {
        let w = Width
        let h = Height
        image = image
        colorPercentage = colorPercentage
        width = w?.value ?? width
        height = h?.value ?? height
    }
    
    private enum CodingKeys: String, CodingKey {
        case Image, ColorPercentage, Width, Height
    }
    
    var Image: OptionalString?
    var ColorPercentage: OptionalDouble?
    var textureSize: CGSize = .zero
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        Image = try container.decodeIfPresent(OptionalString.self, forKey: .Image)
        ColorPercentage = try container.decodeIfPresent(OptionalDouble.self, forKey: .ColorPercentage)
        Width = try container.decodeIfPresent(OptionalDouble.self, forKey: .Width)
        Height = try container.decodeIfPresent(OptionalDouble.self, forKey: .Height)
        updateValues()
    }
    
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(Image, forKey: .Image)
        try container.encodeIfPresent(ColorPercentage, forKey: .ColorPercentage)
        try super.encode(to: encoder)
    }

}


class _Image: Image {
    
    override var type: Types { .Image }
    
    override var image: String {
        get { "@custom" }
        set {  }
    }
    
    override init(_ from: SKTexture) {
        super.init(from)
        Everything.removeNode(key: id)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
}








//class Image: Imagable {
//    fileprivate var node: SKSpriteNode
//    var __node__: SKNode { return node }
//    var __sprite__: SKSpriteNode { return node }
//    init(named: String) {
//        let n = SKSpriteNode.init(imageNamed: named)
//        node = n
//        _imageName_ = named
//    }
//    fileprivate init(clone: Image) {
//        node = clone.__sprite__
//        _imageName_ = clone._imageName_
//    }
//    fileprivate init(origin: SKSpriteNode) {
//        node = origin
//        _imageName_ = "__custom__"
//    }
//    fileprivate var _imageName_ = ""
//    var image: String {
//        get { _imageName_ }
//        set {
//            if newValue != _imageName_ {
//                self.__sprite__.texture = SKTexture.init(imageNamed: newValue)
//                _imageName_ = newValue
//            }
//        }
//    }
//    var colorPercentage: Double {
//        get { Double(__sprite__.colorBlendFactor * 100) }
//        set { __sprite__.colorBlendFactor = CGFloat(newValue)/100 }
//    }
//    fileprivate init(_ node: SKSpriteNode,_ named: String) { self.node = node; self._imageName_ = named }
//    var copy: Image {
//        Image.init(node.copied, _imageName_)
//    }
////    var copyWithPhysics: PhysicsImage {
////        PhysicsNode.init(node.copied)
////    }
//
//    func makeEverythingConnected() -> Node {
//        let combine = separateParts(from: __sprite__)
//        let n = Node()
//        currentScene.add(n)
//        var ps: [PhysicsImage] = []
//        for i in combine {
//            let p = PhysicsImage.init(i)
//            n.add(p)
//            p.__physicsBody__.usesPreciseCollisionDetection = true
//            ps.append(p)
//        }
//        //print("Parts:", ps.count)
//        for x in 0..<ps.count {
//            for y in 0..<ps.count {
//                if x == y { continue }
//                ps[x].joint(ps[y])
//            }
//        }
//        return n //PhysicsNode.init(n.__node__).then({ $0.__physicsBody__.usesPreciseCollisionDetection = true })
//        //return n
//    }
//    func makeEverythingDisconnected() -> Node {
//        let woah2 = separateParts(from: __sprite__)
//        let AO = Node()
//        for i in woah2 {
//            AO.add(PhysicsImage(i))
//        }
//        return AO
//    }
//}
//class PhysicsImage: Image, Physical {
//    var __physicsBody__: SKPhysicsBody = SKPhysicsBody()
//    override init(named: String) {
//        super.init(named: named)
//        self.__physicsBody__ = SKPhysicsBody.init(rectangleOf: __sprite__.size)
//        addPhysics()
//        normalPhysics()
//    }
//    init(_ from: Image) {
//        super.init(clone: from)
//        self.__physicsBody__ = SKPhysicsBody.init(rectangleOf: __sprite__.size)
//        addPhysics()
//        normalPhysics()
//    }
//
//    private var _imageIsRectangle: Bool = true
//    /// Changing this automatically resets the physics body to default values.
//    var imageIsRectangle: Bool {
//        get { _imageIsRectangle }
//        set {
//            if _imageIsRectangle == newValue { return }
//            _imageIsRectangle = newValue
//            if !newValue {
//                self.__physicsBody__ = SKPhysicsBody.init(texture: __sprite__.texture!, alphaThreshold: 0, size: __sprite__.size)
//            } else {
//                self.__physicsBody__ = SKPhysicsBody.init(rectangleOf: __sprite__.size)
//            }
//            addPhysics()
//            normalPhysics()
//        }
//    }
//
//    private init(_ node: SKSpriteNode,_ physics: SKPhysicsBody,_ named: String) { super.init(node, named); self.__physicsBody__ = physics }
//    override var copy: PhysicsImage {
//        PhysicsImage.init(node.copied, __physicsBody__.copied, _imageName_)
//    }
//}
