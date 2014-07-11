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

    init(position: CGPoint, size: CGSize) {
        addBlocksAtPosition(position, size: size)
    }
    
    func addBlocksAtPosition(position: CGPoint, size: CGSize) {
        let columns = Int(size.width)
        let rows = Int(size.height)
        let padding = 10
        
        for y in 1...rows {
            for x in 1...columns {
                var block = Block()
                block.node = SKSpriteNode(color: UIColor.darkGrayColor(), size:block.size)
                let positionX = x * (Int(block.size.width) + padding)
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
        size = CGSize(width: 90, height: 30)
    }
}
