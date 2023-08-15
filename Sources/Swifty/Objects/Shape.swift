//
//  Shape.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 8/7/23.
//

import SpriteKit

// Shape
public class Shape: Node, Polygonable {
    
    override var type: Types { .Shape }
    var shape: SKShapeNode!
    override var node: SKNode { get { shape } set { shape = newValue as? SKShapeNode } }
    var __shape__: SKShapeNode { shape }
    
    private enum CodingKeys: String, CodingKey {
        case Color, Points
    }
    
    var Color: OptionalColor?
    var Points: [CGPoint]?
    
    public var color: Color { get { _color } set { _color = newValue } }
    //public var shape: [CGPoint] { get { _shape } set { _shape = newValue } }
    
    private func updateValues() {
        color = color
    }
    
//    init(radius: CGFloat) {
//        shape = SKShapeNode.init(circleOfRadius: radius)
//        super.init()
//        color = .white
//        updateValues()
//    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        Color = try container.decodeIfPresent(OptionalColor.self, forKey: .Color)
        Points = try container.decodeIfPresent([CGPoint].self, forKey: .Color)
        updateValues()
    }
    
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(Color, forKey: .Color)
        try container.encodeIfPresent(Points, forKey: .Points)
        try super.encode(to: encoder)
    }
    
//    fileprivate var node: SKShapeNode
//    var __node__: SKNode { return node }
//    var __shape__: SKShapeNode { return node }
//
    convenience public init(points: [Double], _ extra: [Double]...) {
        self.init(p: [points] + extra)
    }
    
    init(p: [[Double]]) {
        Points = p.map({ CGPoint.init(x: $0[0], y: $0[1]) })
        shape = SKShapeNode.init(p: Points ?? [])
        super.init()
        color = .white
        updateValues()
    }
    
    
//    fileprivate init(_ shape: SKShapeNode) {
//        node = shape
//    }
//    fileprivate init(_ shape: Shape) {
//        node = shape.__shape__
//    }
    public init(sides: Int, radius: Double) {
        assert(sides > 2)
        let n = sides
        let r = radius
        let path = CGMutablePath()
        let angle = 2.0 * Double.pi / Double(n)
        var base: Double = (.pi/2)
        if sides % 2 == 0 { base += angle/2 }
        var points: [CGPoint] = []
        
        for i in 0..<n {
            let x = r * cos(Double(i) * angle + base)
            let y = r * sin(Double(i) * angle + base)

            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
                points.append(CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
                points.append(CGPoint(x: x, y: y))
            }
        }
        shape = SKShapeNode.init(path: path)
        super.init()
        color = .white
        Points = points
        updateValues()
    }
    convenience public init(sides: Int, sideLength: Double) {
        let height = cot(.pi / Double(sides * 2)) * sideLength / 2
        let apothem = cot(.pi / Double(sides)) * sideLength / 2
        self.init(sides: sides, radius: height - apothem)
    }
    
}

