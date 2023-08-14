//
//  OptionalBinding.swift
//  Testing
//
//  Created by Jonathan Pappas on 8/4/23.
//

import Foundation

protocol OptionalBinding {
    associatedtype BoundType: Codable & Equatable // It doesn't have to be equatable... Since lhs.encode() == rhs.encode()
    var value: BoundType { get }
    init(_ value: BoundType)
}


public class OptionalBool: NSObject, JSON, OptionalBinding {
    var value: Bool
    required init(_ value: Bool) { self.value = value }
    enum CodingKeys: String, CodingKey {
        case value
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(BoundType.self)
    }
    // Custom encode(to:) method to represent your class as a single integer in the JSON
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
public class OptionalInt: NSObject, JSON, OptionalBinding {
    var value: Int
    required init(_ value: Int) { self.value = value }
    enum CodingKeys: String, CodingKey {
        case value
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(BoundType.self)
    }
    // Custom encode(to:) method to represent your class as a single integer in the JSON
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
public class OptionalDouble: NSObject, JSON, OptionalBinding {
    var value: Double
    required init(_ value: Double) { self.value = value }
    enum CodingKeys: String, CodingKey {
        case value
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(BoundType.self)
    }
    // Custom encode(to:) method to represent your class as a single integer in the JSON
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
public class OptionalString: NSObject, JSON, OptionalBinding {
    var value: String
    required init(_ value: String) { self.value = value }
    enum CodingKeys: String, CodingKey {
        case value
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(BoundType.self)
    }
    // Custom encode(to:) method to represent your class as a single integer in the JSON
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

public class OptionalColor: NSObject, JSON, OptionalBinding {
    var value: Color
    required init(_ value: Color) { self.value = value }
    enum CodingKeys: String, CodingKey {
        case value
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(BoundType.self)
    }
    // Custom encode(to:) method to represent your class as a single integer in the JSON
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}



public enum FontList: String, JSON {
    case Helvetica
}
public class OptionalFont: NSObject, JSON, OptionalBinding {
    var value: FontList
    required init(_ value: FontList) { self.value = value }
    enum CodingKeys: String, CodingKey {
        case value
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(BoundType.self)
    }
    // Custom encode(to:) method to represent your class as a single integer in the JSON
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

public enum Horizontal: String, JSON {
    case left, right, center
    func horitzonalAlignmentMode() -> SKLabelHorizontalAlignmentMode {
        switch self {
        case .left: return .left
        case .right: return .right
        case .center: return .center
        }
    }
}
public class OptionalHorizontal: NSObject, JSON, OptionalBinding {
    var value: Horizontal
    required init(_ value: Horizontal) { self.value = value }
    enum CodingKeys: String, CodingKey {
        case value
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(BoundType.self)
    }
    // Custom encode(to:) method to represent your class as a single integer in the JSON
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
public enum Vertical: String, JSON {
    case top, bottom, center, baseline
    func verticalAlignmentMode() -> SKLabelVerticalAlignmentMode {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        case .center: return .center
        case .baseline: return .baseline
        }
    }
}
public class OptionalVertical: NSObject, JSON, OptionalBinding {
    var value: Vertical
    required init(_ value: Vertical) { self.value = value }
    enum CodingKeys: String, CodingKey {
        case value
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(BoundType.self)
    }
    // Custom encode(to:) method to represent your class as a single integer in the JSON
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

public class OptionalNode: NSObject, JSON, OptionalBinding {
    var value: [Container]
    required init(_ value: [Container]) { self.value = value }
    enum CodingKeys: String, CodingKey {
        case value
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(BoundType.self)
    }
    // Custom encode(to:) method to represent your class as a single integer in the JSON
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}




//class OptionalColor: NSObject, OptionalBinding {
//    var value: [UInt8]
//    func color() -> Color { .init(r: value[0], g: value[1], b: value[2], a: value[3]) }
//    // Custom init(from:) method to decode the JSON representing the class as a single integer
//    required init(_ value: [UInt8]) { self.value = value }
//    init(_ foo: Color) { self.value = [foo.r, foo.g, foo.b, foo.a] }
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        //value = .white
//        let wow = try container.decode([UInt8].self)
//        value = wow
//        //value = try container.decode(Hello.self)
//    }
//    // Custom encode(to:) method to represent your class as a single integer in the JSON
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        // try container.encode(value)
//        try container.encode(value)
//        //try container.encode(value.g)
//        //try container.encode(value.b)
//        //try container.encode(value.a)
//    }
//}


import SpriteKit

func Get<Bind: OptionalBinding>(_ value: Bind?,_ defaultValue: Bind.BoundType) -> Bind.BoundType {
    return value?.value ?? defaultValue
}
func Set<Bind: OptionalBinding, Nody: AnyObject, PathType>(_ value: inout Bind?,_ unlessDefault: Bind.BoundType,_ to: Bind.BoundType,_ node: Nody,_ pathTo: ReferenceWritableKeyPath<Nody, PathType>,_ convert: (Bind.BoundType) -> PathType) {
    node[keyPath: pathTo] = convert(to)
    if to == unlessDefault {
        value = nil
    } else {
        value = Bind.init(to)
    }
}
func Set<Bind: OptionalBinding>(_ value: inout Bind?,_ unlessDefault: Bind.BoundType,_ to: Bind.BoundType) {
    if to == unlessDefault {
        value = nil
    } else {
        value = Bind.init(to)
    }
}


func Set<Bind: OptionalBinding, Nody: AnyObject>(_ value: inout Bind?,_ unlessDefault: Bind.BoundType,_ to: Bind.BoundType,_ node: Nody,_ pathTo: ReferenceWritableKeyPath<Nody, Bind.BoundType>) {
    Set(&value, unlessDefault, to, node, pathTo) { $0 }
}
func Set<Bind: OptionalBinding, Nody: AnyObject>(_ value: inout Bind?,_ unlessDefault: Bind.BoundType,_ to: Bind.BoundType,_ node: Nody,_ pathTo: ReferenceWritableKeyPath<Nody, Bind.BoundType?>) {
    Set(&value, unlessDefault, to, node, pathTo) { $0 }
}
func Set<Bind: OptionalBinding, Nody: AnyObject, PathTo: CanConvert>(_ value: inout Bind?,_ unlessDefault: Bind.BoundType,_ to: Bind.BoundType,_ node: Nody,_ pathTo: ReferenceWritableKeyPath<Nody, PathTo>) where PathTo.CanConvertFrom == Bind.BoundType {
    Set(&value, unlessDefault, to, node, pathTo) { PathTo($0) }
}
func Set<Bind: OptionalBinding, Nody: AnyObject, PathTo>(_ value: inout Bind?,_ unlessDefault: Bind.BoundType,_ to: Bind.BoundType,_ node: Nody,_ pathTo: ReferenceWritableKeyPath<Nody, PathTo>) where Bind.BoundType: RawRepresentable, Bind.BoundType.RawValue == PathTo {
    Set(&value, unlessDefault, to, node, pathTo) { $0.rawValue }
}
func Set<Bind: OptionalBinding, Nody: AnyObject, PathTo>(_ value: inout Bind?,_ unlessDefault: Bind.BoundType,_ to: Bind.BoundType,_ node: Nody,_ pathTo: ReferenceWritableKeyPath<Nody, PathTo?>) where Bind.BoundType: RawRepresentable, Bind.BoundType.RawValue == PathTo {
    Set(&value, unlessDefault, to, node, pathTo) { $0.rawValue }
}


protocol CanConvert {
    associatedtype CanConvertFrom
    init(_ from: CanConvertFrom)
}
extension CGFloat: CanConvert {
    typealias CanConvertFrom = Double
}


class CopyOptionalID {
    var ids: [Int : OptionalID] = [:]
    
    func MakeCopy(_ of: OptionalID) -> OptionalID {
        if let o = ids[of.value] {
            return o
        } else {
            let new = OptionalID.Make()
            ids[of.value] = new
            return new
        }
    }
    func MakeCopy(_ of: OptionalID?) -> OptionalID? {
        guard let of = of else { return nil }
        return MakeCopy(of)
    }
    
    func MakeCopies(_ of: [OptionalID]) -> [OptionalID] {
        return of.map { MakeCopy($0) }
    }
    func MakeCopies(_ of: [OptionalID]?) -> [OptionalID]? {
        guard let of = of else { return nil }
        return MakeCopies(of)
    }
    
    func MakeCopies(_ of: Set<OptionalID>) -> Set<OptionalID> {
        return Set(of.map { MakeCopy($0) })
    }
    func MakeCopies(_ of: Set<OptionalID>?) -> Set<OptionalID>? {
        guard let of = of else { return nil }
        return MakeCopies(of)
    }
}

public class OptionalID: NSObject, Codable, OptionalBinding {
    static var initialized: Int = 0
    static var transform: [Int:OptionalID] = [:]
    
    var value: Int
    // Custom init(from:) method to decode the JSON representing the class as a single integer
    static func Make(_ foo: Int = .random(in: 0...(.max))) -> OptionalID {
        if let t = Self.transform[foo] {
            return t
        } else {
            let woah = OptionalID.init(initialized)
            transform[foo] = woah
            initialized += 1
            return woah
        }
    }
    required init(_ value: Int) {
        self.value = value
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(Int.self)
    }
    // Custom encode(to:) method to represent your class as a single integer in the JSON
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
