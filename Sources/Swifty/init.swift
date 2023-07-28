//
//  init.swift
//  Swifty
//
//  Created by Jonathan Pappas on 7/28/23.
//

import SwiftUI
import SpriteKit

public struct Build: View {
    public var body: some View {
        let o = RootScene.init(size: CGSize.init(width: 1600, height: 1000))
        o.scaleMode = .aspectFit
        return SpriteView.init(scene: o)
    }
    init(_ n: Scene) {
        currentScene = n
    }
}

public var trueScene: RootScene!
public var currentScene: Scene!

public class Options {
    static var cameraTrackingDelay: Double = 0.1
}

public class RootScene: SKScene, SKPhysicsContactDelegate {
    
    var curr: SceneHost!
    var magicCamera = SKCameraNode()
    var followingNode: SKNode?
    
    public override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        trueScene = self
        presentScene(currentScene)
        
        addChild(magicCamera)
        self.camera = magicCamera
    }
    
    public override func update(_ currentTime: TimeInterval) {
        if let f = followingNode {
            magicCamera.run(.move(to: f.position, duration: Options.cameraTrackingDelay))
        }
        curr.curr.update?()
    }
    
    var keysPressed: [Key] = []
    public override func keyDown(with event: NSEvent) {
        if event.isARepeat { return }
        let key = Key.init(rawValue: event.keyCode) ?? .unknown
        keysPressed.append(key)
        curr.curr.keyPressed?(key: key)
    }
    public override func keyUp(with event: NSEvent) {
        let key = Key.init(rawValue: event.keyCode) ?? .unknown
        if keysPressed.contains(key) {
            keysPressed.removeAll(where: { $0 == key })
            curr.curr.keyReleased?(key: key)
        }
    }
    
    public override func mouseDown(with event: NSEvent) {
        
    }
    public override func mouseUp(with event: NSEvent) {
        
    }
    public override func mouseDragged(with event: NSEvent) {
        
    }

    public func didBegin(_ contact: SKPhysicsContact) {
        curr.curr.collision?()
    }
    
    func presentScene<T: Scene>(_ someScene: T) {
        curr?.removeFromParent()
        keysPressed = []
        curr = SceneHost.init(hosting: someScene)
        curr.curr.began?()
        addChild(curr)
    }
}

class SceneHost: SKNode {
    var curr: Scene
    init(hosting: Scene) {
        self.curr = hosting
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


@objc public protocol Scene {
    @objc optional func began()
    @objc optional func update()
    @objc optional func keyPressed(key: Key)
    @objc optional func keyReleased(key: Key)
    @objc optional func collision()
}
extension Scene {
    func presentScene<T: Scene>(_ someScene: T) {
        trueScene.presentScene(someScene)
    }
}

extension Scene {
    var keysPressed: [Key] { return trueScene.keysPressed }
    func add<T: Nodable>(_ child: T) {
        if child.__node__.parent != nil {
            print("Warning: Attempting to add a child which already has a parent.")
            return
        }
        trueScene.curr.addChild(child.__node__)
    }
    func holdingKey(_ key: Key) -> Bool {
        return keysPressed.contains(key)
    }
    func cameraFollows<T: Nodable>(_ child: T) {
        trueScene.followingNode = child.__node__
    }
    func removeCamera() {
        trueScene.followingNode = nil
    }
}

