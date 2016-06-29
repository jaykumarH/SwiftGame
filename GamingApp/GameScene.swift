//
//  GameScene.swift
//  GamingApp
//
//  Created by Jay on 2016-06-23.
//  Copyright (c) 2016 Jay. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var nodeTouched=SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = SKColor.grayColor()
        
        self.addPlayerNode()
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addEnemyNodes),
                SKAction.waitForDuration(0.2)
                ])
            ))
        
        if #available(iOS 9.0, *) {
            let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
            backgroundMusic.autoplayLooped = true
            addChild(backgroundMusic)
            
        } else {
            // Fallback on earlier versions
        }
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GameScene.handlePanFrom(_:)))
        self.view!.addGestureRecognizer(gestureRecognizer)
        
    }
    
    //
    // MARK: - Touch Delegates
    //
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
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    //
    // MARK: - Custom Methods
    //
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
        let nodePlayer=SKSpriteNode(imageNamed: "player")
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
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * M_PI)
    }
    
    //
    //MARK: - Gesture Handlers
    //
    func handlePanFrom(recognizer: UIPanGestureRecognizer)
    {
        if recognizer.state == .Began
        {
            var touchLocation = recognizer.locationInView(recognizer.view)
            touchLocation = self.convertPointFromView(touchLocation)
            let touchedNode = self.nodeAtPoint(touchLocation)
            
            if touchedNode is SKSpriteNode
            {
                nodeTouched=touchedNode as! SKSpriteNode
            }
            
        }
        else if recognizer.state == .Changed
        {
            var translation = recognizer.translationInView(recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            
            let position = nodeTouched.position
            nodeTouched.position = CGPoint(x: position.x + translation.x, y: position.y)
            recognizer.setTranslation(CGPointZero, inView: recognizer.view)
        }
        else if recognizer.state == .Ended
        {
            
        }
    }
}
