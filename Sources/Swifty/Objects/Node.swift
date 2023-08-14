//
//  Node.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 5/5/23.
//

import SpriteKit

public class Node: JSON, Nodable, Constructable, Equatable {
    
    // may or may not need this
    static public func == (lhs: Node, rhs: Node) -> Bool {
        return lhs === rhs
    }
    
    private enum CodingKeys: String, CodingKey {
        case X, Y, Name, Angle, Alpha
        case ID, parentID, childrenIDs
    }
    
    var type: Types { .Node }
    var node: SKNode = SKNode()
    public var __node__: SKNode { return node }
    
    var Name: OptionalString?
    var X: OptionalDouble?
    var Y: OptionalDouble?
    var Z: OptionalDouble?
    var Angle: OptionalDouble?
    var Alpha: OptionalDouble?
    
    private func updateValues() {
        x = x
        y = y
        z = z
        angle = angle
        alpha = alpha
    }
    
    var ID: OptionalID?
    var parentID: OptionalID!
    var childrenIDs: Set<OptionalID>?
    var deallocated: OptionalBool?
    
    public init() {
        if ID == nil {
            ID = .Make()
        }
        Everything.addNodes(key: id, value: self)
        updateValues()
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.X = try container.decodeIfPresent(OptionalDouble.self, forKey: .X)
        self.Y = try container.decodeIfPresent(OptionalDouble.self, forKey: .Y)
        self.Name = try container.decodeIfPresent(OptionalString.self, forKey: .Name)
        self.Angle = try container.decodeIfPresent(OptionalDouble.self, forKey: .Angle)
        self.Alpha = try container.decodeIfPresent(OptionalDouble.self, forKey: .Alpha)
        self.ID = try container.decodeIfPresent(OptionalID.self, forKey: .ID)
        self.parentID = try container.decodeIfPresent(OptionalID.self, forKey: .parentID)
        self.childrenIDs = try container.decodeIfPresent(Set<OptionalID>.self, forKey: .childrenIDs)
        updateValues()
    }
    
}

extension Node {
    
    /// Add a child node.
    public func add<T: Node>(_ child: T...) {
        for child in child {
            if _deallocated { print("Warning: Attempting to add a node you deallocated"); return }
            if child.__node__.parent != nil {
                print("Warning: Attempting to add a child which already has a parent.")
                return
            }
            _addID(child.ID!)
            child._parentID = ID
            __node__.addChild(child.__node__)
        }
    }
    
    /// Move a node to a new parent.
    public func moveTo<T: Node>(_ toNewParent: T) {
        //guard let pID = parent?.id else { print("Warning: Node does not have a parent yet lol"); return }
        if __node__.parent == nil { print("Warning: Node does not have a parent yet lol"); return }
        if let pID = parent?.id, Everything.getNode(key: pID) === toNewParent { print("Warning: Moving a node to it's own parent."); return }
        
        _removeIDFromParent()
        toNewParent._addID(ID!)
        parentID = toNewParent.ID
        
        __node__.move(toParent: toNewParent.__node__)
    }
    
    public var copy: Self {
        let copyTime = CopyOptionalID()
        
        let woo = notTopCopy(copyTime)
        woo._parentID = nil
        
        return woo
    }
    
    func notTopCopy(_ c: CopyOptionalID, layer: Int = 0) -> Self {
        let copyChilds = childrenIDs
        childrenIDs = nil
        let copiedSelf: Self = _decode(_encode(self))
        //copiedSelf.updateAllValues()
        //let copiedSelf = Self._decode(self._encode(), false)
        childrenIDs = copyChilds
        
        copiedSelf.ID = c.MakeCopy(ID)
        
        copiedSelf.parentID = c.MakeCopy(parentID)
        
        Everything.addNodes(key: copiedSelf.id, value: copiedSelf)
        
        let Thechildren = _childrenIDs
        let o = Thechildren.map({ Everything.getNode(key: $0.value)!.notTopCopy(c, layer: layer+1) })
        copiedSelf._childrenIDs = Set(o.map({ $0.ID! }))
        
        // I 'did' need this (didn't?)
        copiedSelf.children.forEach({ copiedSelf.add($0) })
        
        return copiedSelf
    }
    
//    var stamp: StampedImage {
//        StampedImage.init(stamp: self)
//    }
    
    func allChildrenRecursive() -> [Node] {
        return children + children.map({ $0.allChildrenRecursive() }).flatMap { $0 }
    }
    
//    func run(_ action: Action) {
//        let a = action.convertToSKAction()
//        __node__.run(a, withKey: action.name)
//    }
    
}

