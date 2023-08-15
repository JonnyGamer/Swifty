//
//  Overloads.swift
//  
//
//  Created by Jonathan Pappas on 8/14/23.
//

import Foundation

// Operator Overloads (Make more generic ones)
public func +=(lhs: inout CGFloat, rhs: Int) {
    lhs += CGFloat(rhs)
}
public func +=(lhs: inout Double, rhs: Int) {
    lhs += Double(rhs)
}

public extension BinaryFloatingPoint {
    func toDegrees() -> Self {
        return self * 180 / .pi
    }
    func toRadians() -> Self {
        return self * .pi / 180
    }
}

public extension CGPoint {
    func negative() -> Self {
        return .init(x: -x, y: -y)
    }
    static var one: Self {
        return .init(x: 1, y: 1)
    }
    static var half: Self {
        return .init(x: 0.5, y: 0.5)
    }
    static var midPoint: Self {
        return .init(x: trueScene.size.width/2, y: trueScene.size.height/2)
    }
}
public extension CGSize {
    static var screenSize: Self {
        return trueScene.size
    }
    static var hundred: Self {
        return .init(width: 100, height: 100)
    }
    func times(_ this: CGFloat) -> Self {
        return .init(width: width * this, height: height * this)
    }
    func widen(_ this: CGFloat) -> Self {
        return .init(width: width * this, height: height)
    }
    func heighten(_ this: CGFloat) -> Self {
        return .init(width: width, height: height * this)
    }
}

public func sin(_ d: Double) -> Double {
    return Foundation.sin(d)
}
public func cos(_ d: Double) -> Double {
    return Foundation.cos(d)
}
public func cot(_ d: Double) -> Double {
    return 1/Foundation.tan(d)
}
public func tan(_ d: Double) -> Double {
    return Foundation.tan(d)
}
public extension Hashable {
    var dup: Self {
        return self
    }
}
//infix operator ++ : AdditionPrecedence
//extension Dictionary where Key == String {
//    public static func +(_ lhs: [String:Value],_ rhs: [String:Value]) -> [String:Value] where Value: JSON {
//        var foo = lhs
//        for i in rhs {
//            if foo[i.key] != nil { print("Warning: Dictionary composition has duplicate keys, overwriting...") }
//            foo[i.key] = i.value
//        }
//        return foo
//    }
//}
//extension Dictionary {
//    public init(_ this: Self) {
//        self = this
//    }
//}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
