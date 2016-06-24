//
//  GameScene.swift
//  GamingApp
//
//  Created by Jay on 2016-06-23.
//  Copyright (c) 2016 Jay. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        myLabel.name="hello"
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        var touchedCount=0

        for touch in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            var xPos=0.0 as CGFloat
            var yPos=90.0 as CGFloat

            if(touchedNode.name == "lblDown")
            {
                touchedCount=touchedCount+1
                let mySprite: SKLabelNode = childNodeWithName("lblDown") as! SKLabelNode
//                var moveBottomLeft = SKAction.moveTo(CGPointMake(500,100), duration:2.0)
//                mySprite.runAction(moveBottomLeft)
                
                let moveRight = SKAction.moveByX(xPos, y: yPos, duration:1.0)
//                mySprite.runAction(moveRight)
                let reversedMoveBottom = moveRight.reversedAction()
                let sequence = SKAction.sequence([moveRight, reversedMoveBottom])
                mySprite.runAction(SKAction.repeatActionForever(sequence))

            }
            
//            let sprite = SKSpriteNode(imageNamed:"ball")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(action)
//            
//            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
