//
//  File.swift
//  Swift-Breakout
//
//  Created by Angelo Di Paolo on 6/18/14.
//  Copyright (c) 2014 Angelo Di Paolo. All rights reserved.
//

import SpriteKit

class Paddle: SKSpriteNode {
    
    var isActive = false
    
    convenience init() {
        self.init(color: UIColor.lightGrayColor(), size:CGSize(width: 150, height: 30))
    }
    
    init(texture: SKTexture!, color: UIColor!, size: CGSize)  {
        super.init(texture: texture, color: color, size: size)
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody.dynamic = false
        physicsBody.restitution = 0.1
        physicsBody.friction = 0.4
    }
}
