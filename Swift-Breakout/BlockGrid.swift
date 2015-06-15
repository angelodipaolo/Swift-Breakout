//
//  BlockGrid.swift
//  Swift-Breakout
//
//  Created by Angelo Di Paolo on 6/18/14.
//  Copyright (c) 2014 Angelo Di Paolo. All rights reserved.
//

import SpriteKit

struct BlockGrid {
    
    struct Block {
        let size = CGSize(width: 105.6, height: 30)
        var node: SKNode?
    }
    
    var blocks = [Block]()
    var levelNumber = 1
    
    init(levelNumber: Int) {
        self.init(position: CGPoint(x: 50, y: 650), size: CGSizeMake(10, 8))
        self.levelNumber = levelNumber
    }

    init(position: CGPoint, size: CGSize) {
        let columns = Int(size.width)
        let rows = Int(size.height)
        let padding = 10
        
        for y in 0...rows {
            for x in 0...columns {
                var block = Block()
                block.node = SKSpriteNode(color: UIColor.darkGrayColor(), size:block.size)
                let positionX = Int(position.x) + x * (Int(block.size.width) + padding)
                let positionY = Int(position.y) - (y * (Int(block.size.height) + padding))
                block.node?.position = CGPoint(x: positionX, y:  positionY)
                blocks.append(block)
            }
        }
    }
}

