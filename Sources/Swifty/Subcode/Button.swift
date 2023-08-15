//
//  Button.swift
//  GameTest
//
//  Created by Jonathan Pappas on 1/17/23.
//

import SpriteKit

public class Button: SKNode, Touchable {
    
    var touching: Bool = false
    var touchBegan: () -> () = {}
    var touchEnded: () -> () = {}
    var touchCancelled: () -> () = {}
    
    var button: SKShapeNode
    var buttonColor: Color = .lightGray
    var pressedColor: Color = .darkGray
    
    func registerAsButton(whenPressed: @escaping () -> ()) {
        touchBegan = pressed
        touchEnded = {
            self.released()
            whenPressed()
        }
        touchCancelled = cancelled
    }
    
    func setButtonColor(_ to: Color, pressed: Color) {
        button.fillColor = to.nsColor
        button.strokeColor = button.fillColor
        buttonColor = to
        pressedColor = pressed
    }
    
    public init(size: CGSize, corner: CGFloat, whenPressed: @escaping () -> ()) {
        self.button = SKShapeNode.init(rectOf: size, cornerRadius: corner)
        super.init()
        addChild(button)
        let copped = button.copy() as! SKShapeNode
        copped.fillColor = .black
        copped.strokeColor = .clear
        copped.alpha = 0.1
        copped.position.y -= 10
        addChild(copped)
        copped.zPosition -= 1
        registerAsButton(whenPressed: whenPressed)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func verifyTouchedOn(_ at: CGPoint) -> Bool {
        return button.path?.contains(at) == true
    }
    func pressed() {
        button.run(.moveBy(x: 0, y: -10, duration: 0.1))
        run(.fillColor(from: buttonColor, to: pressedColor, duration: 0.1, colorize: \Button.button.fillColor, \.button.strokeColor))
    }
    func released() {
        button.run(.moveBy(x: 0, y: 10, duration: 0.1))
        run(.fillColor(from: pressedColor, to: buttonColor, duration: 0.1, colorize: \Button.button.fillColor, \.button.strokeColor))
    }
    func cancelled() {
        released()
    }
    
}

public class ButtonLabel: Button {
    
    var label: SKLabelNode
    var textColor: Color = .white
    var pressedTextColor: Color = .darkGray
    
    func setTextColor(_ to: Color, pressed: Color) {
        label.fontColor = to.nsColor
        textColor = to
        pressedTextColor = pressed
        
        //label.reveal(distancePerLetter: 0.1, speedPerLetter: 0.1, fromColor: buttonColor, toColor: textColor)
        //label.centerText(CGSize.init(width: maxWidth - 99, height: height * 0.5))
        //label.centerAt(point: .zero)
    }
    
    private var maxWidth: CGFloat
    private var height: CGFloat
    public init(maxWidth: CGFloat, height: CGFloat, corner: CGFloat, text: String, whenPressed: @escaping () -> ()) {
        self.maxWidth = maxWidth
        self.height = height
        let woah = SKLabelNode.init(text: text)
        woah.numberOfLines = -1
        woah.centerText(CGSize.init(width: maxWidth * 0.9, height: height * 0.5))
        label = woah
        super.init(size: .init(width: min(woah.frame.width + 99, maxWidth), height: height), corner: corner, whenPressed: whenPressed)
        button.addChild(woah)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pressed() {
        super.pressed()
        run(.fillColor(from: textColor, to: pressedTextColor, duration: 0.1, colorize: \ButtonLabel.label.fontColor!))
    }
    override func released() {
        super.released()
        run(.fillColor(from: pressedTextColor, to: textColor, duration: 0.1, colorize: \ButtonLabel.label.fontColor!))
    }
    
}
