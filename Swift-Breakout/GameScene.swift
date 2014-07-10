//
//  GameScene.swift
//  Swift-Breakout
//
//  Created by Angelo Di Paolo on 6/8/14.
//  Copyright (c) 2014 Angelo Di Paolo. All rights reserved.
//

import SpriteKit

enum CollisionType: UInt32 {
    case Paddle = 1
    case Ball = 2
    case Block = 4
    case Wall = 8
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    // Nodes
    
    let paddle = Paddle()
    let ball = Ball(imageNamed: "ball")
    let grid = BlockGrid(position: CGPoint(x: 0, y: 650), size: CGSizeMake(9, 8))
    
    // Initialization
    
    init(coder aDecoder: NSCoder!)  {
        super.init(coder: aDecoder)

        // setup physics
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody.friction = 0.0
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self

        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)
        ball.physicsBody.friction = 0.0
        ball.physicsBody.restitution = 1.0
        ball.physicsBody.linearDamping = 0.0
        ball.physicsBody.allowsRotation = false
        ball.physicsBody.categoryBitMask = CollisionType.Ball.toRaw()
        ball.physicsBody.contactTestBitMask = CollisionType.Block.toRaw()
        
        // position nodes
        paddle.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMinY(self.frame) + (paddle.size.height * 5));
        ball.position = CGPoint(x: paddle.position.x, y: paddle.position.y + (ball.size.height * 1.5))
        
        // add nodes
        addChild(paddle)
        addChild(ball)
        
        for block in grid.blocks {
            addChild(block.node)
        }
    }

    override func didMoveToView(view: SKView) {
        ball.launch()
    }
    
    // Detecting Touches
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)  {
        let touch : AnyObject! = touches.anyObject()
        let location = touch.locationInNode(self)
        paddle.position.x = location.x
    }
    
    // Updating Scene
   
    override func update(currentTime: CFTimeInterval) {
        handleCollisions()
    }
    
    func handleCollisions() {
        var indexOfCollidedBlock: Int? // optionals are sweeeeeeeet
        
        // look for ball/block collision
        for (index, block) in enumerate(grid.blocks) {
            if CGRectIntersectsRect(block.node.frame, ball.frame) {
                indexOfCollidedBlock = index
                block.node.removeFromParent()
                ball.physicsBody.velocity.dy = -ball.physicsBody.velocity.dy
            }
        }
        
        // remove collided block
        if let index = indexOfCollidedBlock {
            grid.blocks.removeAtIndex(index)
        }
    }
}
