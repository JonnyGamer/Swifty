//
//  StampedImage.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 8/7/23.
//

import SpriteKit

public class StampedImage: Image, Stampable {
    
    override var type: Types { .StampedImage }
    var Stamp: OptionalNode?
    
    init(stamp: Node) {
        let t = SKView().texture(from: stamp.__node__) ?? .init()
        super.init(t)
        
        let new = stamp.copy
        let focus: [Container] = [Container(new)] + new.allChildrenRecursive().map({ Container($0) })
        Stamp = .init(focus)
        for i in focus {
            Everything.removeNode(key: i.object.id)
        }
    }
    
    override public var image: String {
        get { "@custom" }
        set { print("Warning: You may not change the image of a stamped image.") }
    }
    
    private enum CodingKeys: String, CodingKey {
        case Stamp
    }
    
    func updateValues() {
        
        let c: [Container] = Stamp?.value ?? []
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
        
        var topNode: SKNode?
        for j in c {
            let i = j.object
            if let o = i.parent {
                o.add(i)
            } else {
                if i._parentID?.value == -1 {
                    trueScene.curr.curr.add(i)
                } else {
                    topNode = i.__node__
                }
            }
        }
        
        for i in o {
            Everything.removeNode(key: i.id)
        }
        
        guard let top = topNode else { fatalError("") }
        let t = SKView().texture(from: top)
        __sprite__.texture = t
        //return o
        
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        Stamp = try container.decodeIfPresent(OptionalNode.self, forKey: .Stamp)
        updateValues()
    }
    
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(Stamp, forKey: .Stamp)
        try super.encode(to: encoder)
    }
    
    var physics: PhysicsImage {
        return PhysicsImage.init(self)
    }
    
}
