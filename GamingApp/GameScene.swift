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
        backgroundColor = SKColor.grayColor()
        
        self.addPlayerNode()
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addEnemyNodes),
                SKAction.waitForDuration(0.3)
                ])
            ))
        
        if #available(iOS 9.0, *) {
            let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
            backgroundMusic.autoplayLooped = true
            addChild(backgroundMusic)

        } else {
            // Fallback on earlier versions
        }
       
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)

            
            if(touchedNode.name == "startgame")
            {
                
                let mySprite: SKSpriteNode = childNodeWithName("startgame") as! SKSpriteNode
                
                let moveRight = SKAction.moveByX(0, y: -250, duration:1.0)
                let rotateAction = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
                
                let reversedMoveBottom = moveRight.reversedAction()
                let sequence = SKAction.sequence([moveRight, reversedMoveBottom,rotateAction])
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
    
    //-
    // MARK: - Custom Methods
    //-
    func addEnemyNodes()
    {
        let nodeEnemy=SKSpriteNode(imageNamed: "enemy")
        nodeEnemy.name = "enemy"
        
        // Determine where to spawn the monster along the Y axis
        let actualX = random(min: size.width - nodeEnemy.size.width/2, max: nodeEnemy.size.width/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        nodeEnemy.position = CGPoint(x: actualX, y: size.height + nodeEnemy.size.height/2)
        
        // Add the monster to the scene
        addChild(nodeEnemy)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.moveTo(CGPoint(x:actualX, y: -nodeEnemy.size.height/2), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        nodeEnemy.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    func addPlayerNode()
    {
        let nodePlayer=SKSpriteNode(imageNamed: "pacman")
        nodePlayer.position = CGPointMake(size.width/2,size.height*0.1)
        nodePlayer.name = "player"
        addChild(nodePlayer)
    }
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}
