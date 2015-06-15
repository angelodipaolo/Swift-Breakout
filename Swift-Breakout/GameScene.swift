//
//  GameScene.swift
//  Swift-Breakout
//
//  Created by Angelo Di Paolo on 6/8/14.
//  Copyright (c) 2014 Angelo Di Paolo. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let paddle = Paddle()
    let ball = Ball(imageNamed: "ball")
    var grid = BlockGrid(levelNumber: 1)
    var isGameRunning = false
    let deathThreshold = CGFloat(20.0)

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = UIColor.blackColor()
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody?.friction = 0.0
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        addSprites()
        layoutSprites()
    }
    
    override func update(currentTime: CFTimeInterval) {
        // check for ball and block grid collision
        detectGridCollision()
        
        // check for lost ball
        if ball.position.y < deathThreshold {
            resetBall()
        }
        
        // end level when all blocks are destroyed
        if grid.blocks.count == 0 {
            endLevel()
        }
    }
    
    // MARK: Detecting Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch : AnyObject! = touches.first
        let location = touch.locationInNode(self)
        
        if CGRectContainsPoint(paddle.frame, location) {
            paddle.isActive = true;
            
            if !isGameRunning {
                startLevel()
            }
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch : AnyObject! = touches.first
        let location = touch.locationInNode(self)
        
        if paddle.isActive {
            paddle.position.x = location.x
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        paddle.isActive = false
    }
}

// MARK: - Sprite Setup

extension GameScene {
    
    func layoutSprites() {
        paddle.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMinY(self.frame) + (paddle.size.height * 5));
        ball.position = CGPoint(x: paddle.position.x, y: paddle.position.y + (ball.size.height * 1.1))
    }
    
    func addSprites() {
        addChild(paddle)
        addChild(ball)
        
        addGridSprites()
    }
    
    func addGridSprites() {
        for block in grid.blocks {
            if let sprite = block.sprite {
                addChild(sprite)
            }
        }
    }
}

// MARK: - Level Events

extension GameScene {
    
    func startLevel() {
        isGameRunning = true
        ball.launch()
    }
    
    func resetBall() {
        ball.reset()
    }
    
    func endLevel() {
        isGameRunning = false
        
        let nextLevel = grid.levelNumber++
        grid = BlockGrid(levelNumber: nextLevel)
        
        ball.reset()
        layoutSprites()
        addGridSprites()
    }
}

// MARK: - Collision Detection

extension GameScene {
    
    func detectGridCollision() {
        var indexOfCollidedBlock: Int?
        
        // look for ball/block collision
        for (index, block) in grid.blocks.enumerate() {
            if let sprite = block.sprite
                where CGRectIntersectsRect(sprite.frame, ball.frame) {
                    
                    indexOfCollidedBlock = index
                    sprite.removeFromParent()
                    
                    if let physicsBody = ball.physicsBody {
                        physicsBody.velocity.dy = -physicsBody.velocity.dy
                    }
            }
        }
        
        // remove collided block
        if let indexToRemove = indexOfCollidedBlock {
            grid.blocks.removeAtIndex(indexToRemove)
        }
    }
}
