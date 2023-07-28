//
//  Sprite.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 5/5/23.
//

import SpriteKit

public extension String {
    var color: (r:UInt8,g:UInt8,b:UInt8) {
        let scanner = Scanner(string: self)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        return (UInt8(r), UInt8(g), UInt8(b))
    }
}

public extension NSColor {
    convenience init(hex: String) {
        let (r,g,b) = hex.color
        self.init(r: r, g: g, b: b)
    }
    convenience init(r: UInt8, g: UInt8, b: UInt8) {
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    func color() -> Color {
        Color.init(r: UInt8(self.redComponent * 0xff), g: UInt8(self.greenComponent * 0xff), b: UInt8(self.blueComponent * 0xff))
    }
}

#if os(iOS)
typealias NSColor = UIColor
#endif


public struct Color {
    public var red: UInt8
    public var green: UInt8
    public var blue: UInt8
    
    public var nsColor: NSColor { return .init(r: red, g: green, b: blue) }
    
    public init(r: UInt8, g: UInt8, b: UInt8) {
        (self.red, self.green, self.blue) = (r, g, b)
    }
    public init(hex: String) {
        (red, green, blue) = hex.color
    }
    
    public static var black: Self { Color.init(hex: "000000") }
    public static var blue: Self { Color.init(hex: "c0d8da") }
    public static var darkBlue: Self { Color.init(hex: "8aabb0") }
    public static var lightGray: Self { Color.init(hex: "cecece") }
    public static var darkGray: Self { Color.init(hex: "848484") }
    public static var orange: Self { Color.init(hex: "e9c1a7") }
    public static var green: Self { Color.init(hex: "9bb085") }
    public static var darkYellow: Self { Color.init(hex: "b89c5d") }
    public static var purple: Self { Color.init(hex: "885ca7") }
    public static var white: Self { Color.init(hex: "ffffff") }
    public static var redSelection: Self { Color.init(hex: "ff8888") }
}

//
//
//
//
//extension SKAction {
//    static func fillColor<T: SKNode>(from: (r: CGFloat, g: CGFloat, b: CGFloat), to: (r: CGFloat, g: CGFloat, b: CGFloat), duration: Double, colorize: [ReferenceWritableKeyPath<T, NSColor>] = []) -> SKAction {
//        return .customAction(withDuration: duration, actionBlock: { i, j in
//            let rinseR = from.r + (to.r - from.r) * j / CGFloat(duration)
//            let rinseG = from.g + (to.g - from.g) * j / CGFloat(duration)
//            let rinseB = from.b + (to.b - from.b) * j / CGFloat(duration)
//            for c in colorize {
//                (i as? T)?[keyPath: c] = NSColor.init(red: rinseR, green: rinseG, blue: rinseB, alpha: 1.0)
//            }
//        })
//    }
//}
//
//extension SKAction {
//    static func fillColor<T: SKNode>(from: Color, to: Color, duration: Double, colorize: ReferenceWritableKeyPath<T, NSColor>...) -> SKAction {
//        .fillColor(from: from.rgb, to: to.rgb, duration: duration, colorize: colorize)
//    }
//}
//
//extension SKShapeNode {
//    func setColor(_ to: UIColor) {
//        fillColor = to//.hexColor
//        strokeColor = to//.hexColor
//    }
//}
