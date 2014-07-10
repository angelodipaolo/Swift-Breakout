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
        physicsBody.applyImpulse(CGVectorMake(15, -15))
    }
}
