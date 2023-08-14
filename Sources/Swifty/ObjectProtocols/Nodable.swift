//
//  Nodable.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 8/3/23.
//

import SpriteKit

@objc protocol Nodable {
    var Name: OptionalString? { get set }
    var X: OptionalDouble? { get set }
    var Y: OptionalDouble? { get set }
    var Z: OptionalDouble? { get set }
    var Alpha: OptionalDouble? { get set }
    var Angle: OptionalDouble? { get set }
    var __node__: SKNode { get }
    
    var ID: OptionalID! { get set }
    var parentID: OptionalID! { get set }
    var childrenIDs: Set<OptionalID>? { get set }
    var deallocated: OptionalBool? { get set }
}

extension Nodable {
    var x: Double {
        get { Get(X, 0.0) }
        set { Set(&X, 0.0, newValue, __node__, \.position.x) }
    }
    var y: Double {
        get { Get(Y, 0.0) }
        set { Set(&Y, 0.0, newValue, __node__, \.position.y) }
    }
    var name: String {
        get { Get(Name, "") }
        set { Set(&Name, "", newValue, __node__, \.name) }
    }
    var z: Double {
        get { Get(Z, 0.0) }
        set { Set(&Z, 0.0, newValue, __node__, \.zPosition) }
    }
    var alpha: Double {
        get { Get(Alpha, 1.0) }
        set { Set(&Alpha, 1.0, newValue, __node__, \.alpha) }
    }
    var angle: Double {
        get { Get(Angle, 0.0) }
        set { Set(&Angle, 0.0, newValue, __node__, \.zRotation) { CGFloat($0.toRadians()) } }
    }
    
    var id: Int {
        get { ID!.value }
    }
    var parent: Node? {
        guard let _pID = _parentID else { return nil }
        return Everything.getNode(key: _pID.value)
    }
    /// This property should be private.
    var _parentID: OptionalID? {
        get { parentID }
        set {
            parentID = newValue == nil ? nil : .init(newValue!)
        }
    }
    
    var children: [Node] {
        return _childrenIDs.map { Everything.getNode(key: $0.value) }.compactMap { $0 }
    }
    /// This property should be private.
    var _childrenIDs: Set<OptionalID> {
        get { childrenIDs ?? [] }
        set {
            childrenIDs = newValue.isEmpty ? nil : newValue
        }
    }
    
    /// This method should be private.
    func _addID(_ childID: OptionalID) {
        //if _childrenIDs == nil { _childrenIDs = [] }
        _childrenIDs.insert(childID)
    }
    
    
    /// Remove a node from its parent.
    func remove() {
        _removeIDFromParent()
        __node__.removeFromParent()
    }
    /// This method should be private.
    func _removeIDFromParent() {
        // Remove this node's id from it's parent's children id list
        parent?._childrenIDs.remove(ID)
        _parentID = nil
//        if let pID = parentID?.value {
//            Everything._nodes[pID]?._childrenIDs.remove(ID!)
//            _parentID = nil
//        }
    }
    
    /// This property should be private.
    var _deallocated: Bool {
        get { deallocated?.value ?? false }
        set {
            deallocated = newValue ? .init(true) : nil
        }
    }
    /// Deallocate the node, so it won't appear when dumping JSON of all the nodes you've ever made. Warning, once deallocated, you cannot add this node to the scene.
    func deallocate() {
        _deallocated = true
        remove()
        Everything.removeNode(key: id)
        // Everything._nodes[ID.value] = nil
        for childID in childrenIDs ?? [] {
            Everything.getNode(key: childID.value)?.deallocate()
        }
    }
    
}
