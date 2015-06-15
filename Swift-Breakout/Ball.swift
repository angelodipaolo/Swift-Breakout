//
//  Ball.swift
//  Swift-Breakout
//
//  Created by Angelo Di Paolo on 6/18/14.
//  Copyright (c) 2014 Angelo Di Paolo. All rights reserved.
//

import SpriteKit

class Ball: SKSpriteNode {
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize)  {
        super.init(texture: texture, color: color, size: size)
        reset()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(imageNamed: "ball")
    }
}

extension Ball {
    
    func reset() {
        physicsBody = SKPhysicsBody(circleOfRadius: frame.size.width/2)
        physicsBody?.friction = 0.0
        physicsBody?.restitution = 1.0
        physicsBody?.linearDamping = 0.0
        physicsBody?.allowsRotation = false
    }
    
    func launch() {
        physicsBody?.applyImpulse(CGVectorMake(15, -15))
    }
}
