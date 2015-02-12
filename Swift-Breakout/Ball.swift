//
//  Ball.swift
//  Swift-Breakout
//
//  Created by Angelo Di Paolo on 6/18/14.
//  Copyright (c) 2014 Angelo Di Paolo. All rights reserved.
//

import SpriteKit

class Ball: SKSpriteNode {
    
    func launch() {        
        if let body = self.physicsBody {
            body.applyImpulse(CGVectorMake(15, -15))
        }
    }
    
    func configurePhysicsBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: frame.size.width/2)
        physicsBody?.friction = 0.0
        physicsBody?.restitution = 1.0
        physicsBody?.linearDamping = 0.0
        physicsBody?.allowsRotation = false
    }
}
