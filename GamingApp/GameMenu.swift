//
//  GameMenu.swift
//  GamingApp
//
//  Created by Jay on 2016-07-04.
//  Copyright © 2016 Jay. All rights reserved.
//

import Foundation

import SpriteKit

class GameMenu:SKScene
{
    override init(size: CGSize)
    {
        super.init(size: size)
        
        backgroundColor = SKColor.blackColor()
        
        let message = "Ghost Busters"
        let instructions="Move the player horizontally to shoot the ghost!!"
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 20
        label.fontColor = SKColor.yellowColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        let subLabel=SKLabelNode(fontNamed:"Helvetica")
        subLabel.text=instructions
        subLabel.fontSize=12
        subLabel.fontColor=SKColor.whiteColor()
        subLabel.position=CGPoint(x:size.width/2,y: label.position.y-30)
        addChild(subLabel)
        
        runAction(SKAction.sequence([
            SKAction.waitForDuration(2.0),
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