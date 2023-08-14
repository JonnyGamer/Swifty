//
//  Sprite.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 5/5/23.
//

import SpriteKit

extension String {
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

extension NSColor {
    convenience init(hex: String) {
        let (r,g,b) = hex.color
        self.init(r: r, g: g, b: b)
    }
    convenience init(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = .max) {
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff,
            alpha: CGFloat(a) / 0xff
        )
    }
    func color() -> Color {
        Color.init(r: UInt8(self.redComponent * 0xff), g: UInt8(self.greenComponent * 0xff), b: UInt8(self.blueComponent * 0xff))
    }
}

#if os(iOS)
typealias NSColor = UIColor
#endif


struct Color: Equatable, JSON {
    var r: UInt8
    var g: UInt8
    var b: UInt8
    var a: UInt8
    
    var red: UInt8 { get { r } set { r = newValue} }
    var green: UInt8 { get { g } set { g = newValue} }
    var blue: UInt8 { get { b } set { b = newValue} }
    var alpha: UInt8 { get { a } set { a = newValue} }
    
    var json: [String : JSON] { ["r":r,"g":g,"b":b,"a":a] }
    
    var nsColor: NSColor { return .init(r: red, g: green, b: blue, a: alpha) }
    
    init(r: UInt8, g: UInt8, b: UInt8) {
        (self.r, self.g, self.b, self.a) = (r, g, b, .max)
    }
    init(r: UInt8, g: UInt8, b: UInt8, a: UInt8) {
        (self.r, self.g, self.b, self.a) = (r, g, b, a)
    }
    init(hex: String) {
        (r, g, b) = hex.color
        a = .max
    }
    
    static var black: Self { Color.init(hex: "000000") }
    static var blue: Self { Color.init(hex: "c0d8da") }
    static var darkBlue: Self { Color.init(hex: "8aabb0") }
    static var lightGray: Self { Color.init(hex: "cecece") }
    static var darkGray: Self { Color.init(hex: "848484") }
    static var orange: Self { Color.init(hex: "e9c1a7") }
    static var green: Self { Color.init(hex: "9bb085") }
    static var darkYellow: Self { Color.init(hex: "b89c5d") }
    static var purple: Self { Color.init(hex: "885ca7") }
    static var white: Self { Color.init(hex: "ffffff") }
    static var redSelection: Self { Color.init(hex: "ff8888") }
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
