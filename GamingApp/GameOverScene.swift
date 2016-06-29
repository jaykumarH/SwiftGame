//
//  GameOverScene.swift
//  GamingApp
//
//  Created by Jay on 2016-06-29.
//  Copyright © 2016 Jay. All rights reserved.
//

import SpriteKit

class GameOverScene:GameScene
{
    init(size: CGSize, won:Bool)
    {
        super.init(size: size)
        
        backgroundColor = SKColor.whiteColor()
        
        let message = won ? "You Won!" : "Sorry ....You Lose!!!!"
       
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 20
        label.fontColor = SKColor.whiteColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        runAction(SKAction.sequence([
            SKAction.waitForDuration(5.0),
            SKAction.runBlock() {
                
                let reveal = SKTransition.flipVerticalWithDuration(0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}