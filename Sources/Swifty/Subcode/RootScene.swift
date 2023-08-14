//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 8/14/23.
//

import Foundation
import SwiftUI
import SpriteKit

@available(macOS 10.15, *)
public struct Build: View {
    public var body: some View {
        let o = RootScene.init(size: CGSize.init(width: 1600, height: 1000))
        o.scaleMode = .aspectFit
        if #available(macOS 11.0, *) {
            return SpriteView.init(scene: o)
        } else {
            // Fallback on earlier versions
            fatalError("Upgrade to MacOS 11 for the SpriteView object")
        }
    }
    public init(_ n: Scene) {
        currentScene = n
    }
}

@available(macOS 10.11, *)
var trueScene: RootScene! // public
@available(macOS 10.11, *)
var currentScene: Scene! // public

class RootScene: SKScene, SKPhysicsContactDelegate {
    
    var curr: SceneHost!
    // var magicCamera = SKCameraNode()
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        trueScene = self
        backgroundColor = .black
        presentScene(currentScene, transition: .none)
    }
    
    // Scene Update amidst Transitioning
    var outgoingCurr: SceneHost?
    var pauseOutgoingCurr: Bool = false
    var incomingCurr: SceneHost?
    var pauseIncomingCurr: Bool = false
    var transitioning: Bool = false
    override func didFinishUpdate() {
        if !transitioning {
            curr.update()
        }
        if !pauseIncomingCurr {
            incomingCurr?.update()
        }
        if !pauseOutgoingCurr {
            outgoingCurr?.update()
        }
    }
    
    // Key Functionality
    var keysPressed: [Key] = []
    override func keyDown(with event: NSEvent) {
        if transitioning { return }
        if event.isARepeat { return }
        let key = Key.init(rawValue: event.keyCode) ?? .unknown
        keysPressed.append(key)
        curr.curr.keyPressed?(key: key)
    }
    override func keyUp(with event: NSEvent) {
        if transitioning { return }
        let key = Key.init(rawValue: event.keyCode) ?? .unknown
        if keysPressed.contains(key) {
            keysPressed.removeAll(where: { $0 == key })
            curr.curr.keyReleased?(key: key)
        }
    }
    
    
    func isPoint(_ point: CGPoint, insideNode node: SKNode) -> Bool {
        let pointInNodeSpace = node.convert(point, from: self)
        return node.contains(pointInNodeSpace)
    }
    
    // Touching Functionality
    var nodesTouching: [SKNode] = []
    var nodesReleased: [SKNode] = []
    var location: CGPoint = .zero
    override func mouseDown(with event: NSEvent) {
        if transitioning { return }
        location = event.location(in: self)
        //nodesTouching = nodes(at: location)
        nodesTouching = nodes(at: location).filter({ $0.containsPoint(location) })
        curr.curr.touchBegan?(x: location.x, y: location.y)
    }
    override func mouseMoved(with event: NSEvent) {
        if transitioning { return }
        let newLocation = event.location(in: self)
        let dx = newLocation.x - location.x
        let dy = newLocation.y - location.y
        location = newLocation
        curr.curr.touchMoved?(dx: dx, dy: dy)
    }
    override func mouseUp(with event: NSEvent) {
        if transitioning { return }
        nodesReleased = nodesTouching
        nodesTouching.removeAll()
        curr.curr.touchEnded?()
        nodesReleased.removeAll()
    }

    // Collision Fest :)
    func didBegin(_ contact: SKPhysicsContact) {
        curr.curr.collision?()
    }
    
    
    func presentScene<T: Scene>(_ someScene: T, transition: SceneTransition) {
        // Remove old scene, and properties
        let centerPosition = CGPoint.zero// CGPoint.init(x: self.size.width/2, y: self.size.height/2)
        keysPressed = []
        nodesTouching = []
        nodesReleased = []
        transitioning = true
        physicsWorld.removeAllJoints()
        
        switch transition {
        case .none:
            curr?.removeFromParentRecursive()
            //followingNode = nil
            //magicCamera.removeAllActions()
            //magicCamera.position = .zero
            curr = SceneHost.init(hosting: someScene)
            addChild(curr)
            curr.position = centerPosition
            curr.curr.began?()
            transitioning = false
            
        case .push(let x):
            
            let dpoint = x.d
            let moveByAction = SKAction.move(by: dpoint, duration: 1).easeInOut()
            
            guard let oldCurr = curr else { return }
            outgoingCurr = oldCurr
            oldCurr.run(moveByAction) {
                oldCurr.removeFromParentRecursive()
                self.outgoingCurr = nil
            }
            
            let newCurr = SceneHost.init(hosting: someScene)
            self.curr = newCurr
            incomingCurr = newCurr
            addChild(newCurr)
            newCurr.position = centerPosition
            newCurr.position.x -= dpoint.dx
            newCurr.position.y -= dpoint.dy
            newCurr.run(moveByAction) {
                self.incomingCurr = nil
                self.transitioning = false
            }
            newCurr.curr.began?()
        
        case .slide(let x):
            let dpoint = x.d
            let moveByAction = SKAction.move(by: dpoint, duration: 1).easeInOut()
            
            guard let oldCurr = curr else { return }
            outgoingCurr = oldCurr
            oldCurr.run(.wait(forDuration: 1)) {
                oldCurr.removeFromParentRecursive()
                self.outgoingCurr = nil
            }
            
            let newCurr = SceneHost.init(hosting: someScene)
            self.curr = newCurr
            incomingCurr = newCurr
            addChild(newCurr)
            newCurr.position = centerPosition
            newCurr.position.x -= dpoint.dx
            newCurr.position.y -= dpoint.dy
            newCurr.run(moveByAction) {
                self.incomingCurr = nil
                self.transitioning = false
            }
            newCurr.curr.began?()
        
        default:
            break
            
        }
        
    }
}

class SceneHost: SKCropNode {
    
    class Options {
        var cameraTrackingDelay: Double = 0
        // var cameraTracksRotation: Bool = true
        // fileprivate var _resetCameraRotation = false
        // func resetCameraRotation() { _resetCameraRotation = true }
    }
    var options = Options()
    
    var curr: Scene
//    let backgroundColor: Color {
//        get { Color }
//        set {}
//    }
    
    var hostNode = SKNode()
    var followingNode: SKNode?
    
    fileprivate let bg: SKSpriteNode = SKSpriteNode.init(color: .darkGray, size: .screenSize).then({
        $0.zPosition = -.infinity
        $0.position = .midPoint
    })
    
    func update() {
        if let f = followingNode {
            if !hostNode.hasActions() {
                hostNode.position = f.position.negative()
            }
            if options.cameraTrackingDelay > 0 {
                hostNode.run(.move(to: f.position.negative(), duration: options.cameraTrackingDelay))
            } else {
                hostNode.position = f.position.negative()
            }
            // Doesn't work properly with SKPhysics ... OOF!
//            if options.cameraTracksRotation {
//                hostNode.zRotation = -f.zRotation
//            } else if options._resetCameraRotation {
//                hostNode.zRotation = 0
//                options._resetCameraRotation = false
//            }
        }
        curr.update?()
    }
    
    init(hosting: Scene) {
        self.curr = hosting
        super.init()
        addChild(hostNode)
        
        let scrop = SKSpriteNode.init(color: .white, size: .screenSize)
        maskNode = scrop
        scrop.position = .midPoint
        //scrop.run(.moveBy(x: 0, y: 100, duration: 1))
        
        addChild(bg)
        
        // Testing Spotlight SKCropNode lol
//        let N = SKNode()
//        for i in 1...100 {
//            let o = SKShapeNode.init(circleOfRadius: 300 - CGFloat(i)*1)
//            o.fillColor = .init(white: 1.0, alpha: 0.05)
//            o.strokeColor = .clear
//            N.addChild(o)
//        }
//
//        //let nstamp = N.stamp
//        self.maskNode = N
//        N.run(.repeatForever(.sequence([.moveBy(x: 300, y: 0, duration: 1), .moveBy(x: -300, y: 0, duration: 1)])))
        
        
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
    @objc optional func touchBegan(x: Double, y: Double)
    @objc optional func touchMoved(dx: Double, dy: Double)
    @objc optional func touchEnded()
}
enum SceneTransition {
    enum Direction: Int {
        case left, right, up, down
        var d: CGVector {
            switch self {
            case .left: return .init(dx: -1600, dy: 0)
            case .right: return .init(dx: 1600, dy: 0)
            case .down: return .init(dx: 0, dy: -1000)
            case .up: return .init(dx: 0, dy: 1000)
            }
        }
    }
    case none
    case push(Direction)
    case slide(Direction)
    case fadeTogether
    case fade(Color)
}
extension Scene {
    func presentScene<T: Scene>(_ someScene: T) {
        presentScene(someScene, transition: .none)
    }
    func presentScene<T: Scene>(_ someScene: T, transition: SceneTransition) {
        trueScene.presentScene(someScene, transition: transition)
    }
}

extension Scene {
    var keysPressed: [Key] { return trueScene.keysPressed }
    func add<T: Nodable>(_ child: T) {
        if child.__node__.parent != nil {
            print("Warning: Attempting to add a child which already has a parent.")
            return
        }
        child.parentID = OptionalID(-1)
        
        trueScene.curr.hostNode.addChild(child.__node__)
    }
    func holdingKey(_ key: Key) -> Bool {
        return keysPressed.contains(key)
    }
    func cameraFollows<T: Nodable>(_ child: T) {
        trueScene.curr.followingNode = nil
        trueScene.curr.hostNode.removeAllActions()
        trueScene.curr.followingNode = child.__node__
    }
    func cameraStopFollowing() {
        trueScene.curr.followingNode = nil
    }
    var backgroundColor: Color {
        get { trueScene.curr.bg.color.color() }
        set { trueScene.curr.bg.color = newValue.nsColor }
    }
    var width: Double { Double(trueScene.size.width) }
    var height: Double { Double(trueScene.size.height) }
    var options: SceneHost.Options {
        get { trueScene.curr.options }
        set { trueScene.curr.options = newValue }
    }
    func iAmTouching<T: Nodable>(_ some: T) -> Bool {
        return trueScene.nodesTouching.contains { some.__node__ === $0 }
    }
    func iStoppedTouching<T: Nodable>(_ some: T) -> Bool {
        return trueScene.nodesReleased.contains { some.__node__ === $0 }
    }
}
