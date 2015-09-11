//
//  BlockGrid.swift
//  Swift-Breakout
//
//  Created by Angelo Di Paolo on 6/18/14.
//  Copyright (c) 2014 Angelo Di Paolo. All rights reserved.
//

import SpriteKit

final class BlockGrid {
    private (set) var blocks = [SKSpriteNode]()
    
    init(frame: CGRect, gridSize: CGSize) {
        let columns = Int(gridSize.width)
        let rows = Int(gridSize.height)
        let padding = CGFloat(10)
        
        let totalPaddingWidth = (gridSize.width - 1) * padding
        let totalPaddingHeight = (gridSize.height - 1) * padding
        let blockWidth = ((frame.width - totalPaddingWidth) / gridSize.width)
        let blockHeight = ((frame.height - totalPaddingHeight) / gridSize.height)
        
        for y in 1...rows {
            for x in 1...columns {
                let x = CGFloat(x)
                let y = CGFloat(y)
                
                let size = CGSize(width: blockWidth, height: blockHeight)
                let block = SKSpriteNode(color: UIColor.darkGrayColor(), size: size)
                let positionX = frame.origin.x + (x * (block.size.width + padding))
                let positionY = frame.origin.y - (y * (block.size.height + padding))
                block.position = CGPoint(x: positionX, y:  positionY)
                blocks.append(block)
            }
        }
    }
}

extension BlockGrid {
    
    func addToScene(scene: SKScene) {
        for block in blocks {
            scene.addChild(block)
        }
    }
    
    func removeBlockAtIndex(indexToRemove: Int) {
        blocks.removeAtIndex(indexToRemove)
    }
}
