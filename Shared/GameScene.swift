//
//  GameScene.swift
//  Swift-Breakout
//
//  Created by Angelo Di Paolo on 6/8/14.
//  Copyright (c) 2014 Angelo Di Paolo. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let bottom: UInt32 = 0x1 << 0
}

class GameScene: SKScene {
    
    let paddle = Paddle()
    let ball = Ball(imageNamed: "ball")
    lazy var grid: BlockGrid = {
        let scale = CGFloat(0.70)
        let width = self.size.width * 0.90
        let height = self.size.height * 0.60
        let frame = CGRectMake(0, self.size.height, width, height)
        
        return BlockGrid(frame: frame, gridSize: CGSizeMake(8, 6))
    }()
    
    var isGameRunning = false
    let deathThreshold = CGFloat(20)

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
        
        
        let deathNode = SKNode()
        let deathFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), 1)
        deathNode.physicsBody = SKPhysicsBody(edgeLoopFromRect: deathFrame)
        deathNode.physicsBody?.categoryBitMask = PhysicsCategory.bottom
        addChild(deathNode)
        
        addSprites()
        layoutSprites()
    }
    
    override func update(currentTime: CFTimeInterval) {
        // check for ball and block grid collision
        detectGridCollision()
        
        // check for lost ball
//        if ball.position.y < deathThreshold {
//            resetBall()
//        }
        
        // end level when all blocks are destroyed
        if grid.blocks.count == 0 {
            endLevel()
        }
    }
    
    // MARK: Detecting Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if #available(tvOS 9.0, *)  {
            paddle.isActive = true
        
        } else {
            let touch : AnyObject! = touches.first
            let location = touch.locationInNode(self)
            paddle.isActive = CGRectContainsPoint(paddle.frame, location)
        }
 
        if paddle.isActive && !isGameRunning {
            startLevel()
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: AnyObject! = touches.first
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
        paddle.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(frame) + (paddle.size.height * 5));
        ball.position = CGPoint(x: paddle.position.x, y: paddle.position.y + (ball.size.height * 1.1))
    }
    
    func addSprites() {
        addChild(paddle)
        addChild(ball)
        grid.addToScene(self)
    }
}

// MARK: - Level Events

extension GameScene {
    
    func startLevel() {
        isGameRunning = true
        ball.launch()
    }
    
    func loseBall() {
        paddle.isActive = false
        isGameRunning = false
        ball.reset()
        paddle.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(frame) + (paddle.size.height * 5));
        ball.position = CGPoint(x: paddle.position.x, y: paddle.position.y + (ball.size.height * 1.1))
    }
    
    func endLevel() {
        isGameRunning = false
        
//        let nextLevel = grid.levelNumber + 1
//        grid = BlockGrid(levelNumber: nextLevel)
        
        ball.reset()
        layoutSprites()
        grid.addToScene(self)
    }
}

// MARK: - Collision Detection

extension GameScene {
    
    func detectGridCollision() {
        var indexOfCollidedBlock: Int?
        
        // look for ball/block collision
        for (index, sprite) in grid.blocks.enumerate() {
            if CGRectIntersectsRect(sprite.frame, ball.frame) {
                    
                indexOfCollidedBlock = index
                sprite.removeFromParent()
                
                if let physicsBody = ball.physicsBody {
                    physicsBody.velocity.dy = -physicsBody.velocity.dy
                }
            }
        }
        
        // remove collided block
        if let indexToRemove = indexOfCollidedBlock {
            grid.removeBlockAtIndex(indexToRemove)
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == PhysicsCategory.bottom ||
            contact.bodyB.categoryBitMask == PhysicsCategory.bottom {
            loseBall()
        }
        
    }
}
