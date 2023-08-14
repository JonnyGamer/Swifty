//
//  Everything.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 8/3/23.
//

import Foundation

/*
 let currently = Everything()
 
 let createdNode: Node = Node()
 (Does this node get put inside the everything yet? Or only when added to the scene...)
 */


struct Everything {
    
    static var o: Everything = Everything()
    
    //private(set) static var _nodes: [Int:Node] = [:]
    private(set) var _nodes: [Int:Node] = [:]
    
    static var _nodesInitialized: Int = 0
    static func addNodes(key: Int, value: Node) {
        //if let p = _nodes.first(where: { $0.value === value }) {
        //    print("bad news...", p.key, p.value)
        //}
        if o._nodes[key] != nil {
            fatalError("You can only use this JSON once")
        }
        assert(o._nodes[key] == nil)
        o._nodes[key] = value
    }
    static func removeNode(key: Int) {
        o._nodes[key] = nil
    }
    static func getNode(key: Int) -> Node? {
        return o._nodes[key]
    }
    
    static func encode() -> String {
        return o._nodes.map({ Container($0.value) }).encode()
    }
    static func decodeFrom(_ c: [Container]) -> [Node] {
        var o: [Node] = []

        let copytime = CopyOptionalID()

        for j in c {
            let i = j.object

            i.ID = copytime.MakeCopy(i.ID)
            if let o = i._parentID, o.value != -1 { // That is, check if it is has a parent who is not the scene
                i._parentID = copytime.MakeCopy(i._parentID)
            }
            i._childrenIDs = copytime.MakeCopies(i._childrenIDs)

            Everything.addNodes(key: i.id, value: i)
            o.append(i)
        }

        for j in c {
            let i = j.object
            if let o = i.parent {
                o.add(i)
            } else {
                if i._parentID?.value == -1 {
                    trueScene.curr.curr.add(i)
                }
            }
        }

        return o
    }
    static func decode(_ jsonString: String) -> [Node] {
        let c = [Container].decode(jsonString)
        return decodeFrom(c)
    }
}

enum Types: String, JSONEnum {
    case Node, Box, Text, Image, StampedImage, Circle, Shape
    case PhysicsNode, PhysicsBox, PhysicsImage, PhysicsCircle, PhysicsShape
}

protocol Constructable {
    var type: Types { get }
}


class Container: JSON, Equatable {
    static func == (lhs: Container, rhs: Container) -> Bool {
        return lhs.object == rhs.object
    }
    var type: Types
    var object: Node
    init(_ object: Node) {
        self.object = object
        self.type = object.type
    }
    private enum CodingKeys: String, CodingKey {
        case type, object
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let t = try container.decode(Types.self, forKey: .type)
        self.type = t
        
        switch self.type {
        case .Node: self.object = try container.decode(Node.self, forKey: .object)
        case .PhysicsNode: self.object = try container.decode(PhysicsNode.self, forKey: .object)
        case .Box: self.object = try container.decode(Box.self, forKey: .object)
        case .PhysicsBox: self.object = try container.decode(PhysicsBox.self, forKey: .object)
        case .Text: self.object = try container.decode(Text.self, forKey: .object)
        case .Image: self.object = try container.decode(Image.self, forKey: .object)
        case .PhysicsImage: self.object = try container.decode(PhysicsImage.self, forKey: .object)
        case .StampedImage: self.object = try container.decode(StampedImage.self, forKey: .object)
        case .Circle: self.object = try container.decode(Circle.self, forKey: .object)
        case .PhysicsCircle: self.object = try container.decode(PhysicsCircle.self, forKey: .object)
        case .Shape: self.object = try container.decode(Shape.self, forKey: .object)
        case .PhysicsShape: self.object = try container.decode(Shape.self, forKey: .object)
        }
    }
}
