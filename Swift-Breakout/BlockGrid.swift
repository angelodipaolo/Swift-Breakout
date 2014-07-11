//
//  BlockGrid.swift
//  Swift-Breakout
//
//  Created by Angelo Di Paolo on 6/18/14.
//  Copyright (c) 2014 Angelo Di Paolo. All rights reserved.
//

import SpriteKit

class BlockGrid {
    
    var blocks: [Block] = []
    var levelNumber = 1
    
    class func GridWithLevel(levelNumber: Int) -> BlockGrid {
        let grid = BlockGrid(position: CGPoint(x: 50, y: 650), size: CGSizeMake(10, 8))
        grid.levelNumber = levelNumber
        return grid
    }

    init(position: CGPoint, size: CGSize) {
        addBlocksAtPosition(position, size: size)
    }
    
    func addBlocksAtPosition(position: CGPoint, size: CGSize) {
        let columns = Int(size.width)
        let rows = Int(size.height)
        let padding = 10
        
        for y in 0...rows {
            for x in 0...columns {
                var block = Block()
                block.node = SKSpriteNode(color: UIColor.darkGrayColor(), size:block.size)
                let positionX = Int(position.x) + x * (Int(block.size.width) + padding)
                let positionY = Int(position.y) - (y * (Int(block.size.height) + padding))
                block.node.position = CGPoint(x: positionX, y:  positionY)
                blocks.append(block)
            }
        }
    }
}

struct Block {
    var size: CGSize
    var node: SKNode!
    
    init() {
        size = CGSize(width: 105.6, height: 30)
    }
}
