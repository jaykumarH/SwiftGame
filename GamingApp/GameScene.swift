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
        backgroundColor = SKColor.blackColor()

        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Try to hit me!"
        myLabel.fontSize = 20
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        myLabel.name="lblHit"
        self.addChild(myLabel)
        
        let playBall=SKSpriteNode(imageNamed: "ball")
        playBall.position = CGPointMake(size.width/2,size.height)
        playBall.name = "startgame"
        addChild(playBall)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */

        for touch in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            var xPos=150.0 as CGFloat
            var yPos=0.0 as CGFloat

            if(touchedNode.name == "lblHit")
            {
 
                let mySprite: SKLabelNode = childNodeWithName("lblHit") as! SKLabelNode
                
                let moveRight = SKAction.moveByX(xPos, y: yPos, duration:1.0)
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
