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
    var grid = BlockGrid.GridWithLevel(1)
    var isGameRunning = false
    let deathThreshold = CGFloat(20.0)
    
    //MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = UIColor.blackColor()
        
        // setup physics
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody?.friction = 0.0
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        ball.configurePhysicsBody()
        
        // setup nodes
        positionNodes()
        addNodes()
    }
    
    //MARK: Node Setup
    
    func positionNodes() {
        paddle.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMinY(self.frame) + (paddle.size.height * 5));
        ball.position = CGPoint(x: paddle.position.x, y: paddle.position.y + (ball.size.height * 1.1))
    }
    
    func addNodes() {
        addChild(paddle)
        addChild(ball)
        
        addGridNodes()
    }
    
    func addGridNodes() {
        for block in grid.blocks {
            addChild(block.node)
        }
    }
    
    //MARK: Level Events
    
    func runGame() {
        isGameRunning = true
        ball.launch()
    }
    
    func resetBall() {
        isGameRunning = false
        ball.configurePhysicsBody()
        positionNodes()
    }
    
    func endLevel() {
        let nextLevel = grid.levelNumber++
        grid = BlockGrid.GridWithLevel(nextLevel)
        
        resetBall()
        addGridNodes()
    }
    
    //MARK: Detecting Touches
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch : AnyObject! = touches.first
        let location = touch.locationInNode(self)
        
        if CGRectContainsPoint(paddle.frame, location) {
            paddle.isActive = true;
            
            if !isGameRunning {
                runGame()
            }
        }
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch : AnyObject! = touches.first
        let location = touch.locationInNode(self)
        
        if paddle.isActive {
            paddle.position.x = location.x
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        paddle.isActive = false
    }
    
    //MARK: Updating Scene
   
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
    
    func detectGridCollision() {
        var indexOfCollidedBlock: Int? // optionals are sweeeeeeeet
        
        // look for ball/block collision
        for (index, block) in enumerate(grid.blocks) {
            if CGRectIntersectsRect(block.node.frame, ball.frame) {
                indexOfCollidedBlock = index
                block.node.removeFromParent()
                
                if let body = self.ball.physicsBody {
                    body.velocity.dy = -body.velocity.dy
                }
            }
        }
        
        // remove collided block
        if let index = indexOfCollidedBlock {
            grid.blocks.removeAtIndex(index)
        }
    }
}
