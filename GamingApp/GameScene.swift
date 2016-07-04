//
//  GameScene.swift
//  GamingApp
//
//  Created by Jay on 2016-06-23.
//  Copyright (c) 2016 Jay. All rights reserved.
//

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Enemy     : UInt32 = 0b1
    static let Player    : UInt32 = 0b10
    static let winConditionNumber=10
}

import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate{
    var nodeTouched=SKSpriteNode()
    var countOfEnemy=0
    override func didMoveToView(view: SKView)
    {
        /* Setup your scene here */
        backgroundColor = SKColor.blackColor()
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GameScene.handlePanFrom(_:)))
        self.view!.addGestureRecognizer(gestureRecognizer)
        
        self.addPlayerNode()
        
        //setup physics
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
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
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    //
    // MARK: - Touch Delegates
    //
    //    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    //    {
    //        /* Called when a touch begins */
    //
    //        for touch in touches {
    //            let location = touch.locationInNode(self)
    //            let touchedNode = self.nodeAtPoint(location)
    //        }
    //    }
    
    
    //
    // MARK: - Custom Methods
    //
    func addEnemyNodes()
    {
        countOfEnemy += 1

        let nodeEnemy=SKSpriteNode(imageNamed: "enemy")
        nodeEnemy.name = "enemy"
        
        nodeEnemy.physicsBody = SKPhysicsBody(circleOfRadius:nodeEnemy.size.width/2)
        nodeEnemy.physicsBody?.dynamic = true
        nodeEnemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        nodeEnemy.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        nodeEnemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        nodeEnemy.physicsBody?.usesPreciseCollisionDetection = true
        
        // Determine where to move the enemy along the X axis
        let actualX = random(min: size.width - nodeEnemy.size.width/2, max: nodeEnemy.size.width/2)
        
        // Position the enemy slightly off-screen along the top edge,
        // and along a random position along the X axis as calculated above
        nodeEnemy.position = CGPoint(x: actualX, y: size.height + nodeEnemy.size.height/2)
        
        // Add the enemy to the scene
        addChild(nodeEnemy)
        
        // Determine speed of the enemy
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.moveTo(CGPoint(x:actualX, y: -nodeEnemy.size.height/2), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        if countOfEnemy>PhysicsCategory.winConditionNumber
        {
            let winAction = SKAction.runBlock() {
                let reveal = SKTransition.flipVerticalWithDuration(0.5)
                let gameOverScene = GameOverScene(size: self.size, won: true)
                self.view?.presentScene(gameOverScene, transition: reveal)
            }
            nodeEnemy.runAction(SKAction.sequence([actionMove, winAction, actionMoveDone]))
        }
        else
        {
            nodeEnemy.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        }
        
    }
    func addPlayerNode()
    {
        let nodePlayer=SKSpriteNode(imageNamed: "player")
        nodePlayer.position = CGPointMake(size.width/2,size.height*0.1)
        nodePlayer.name = "player"
        
        nodePlayer.physicsBody = SKPhysicsBody(circleOfRadius:nodePlayer.size.width)
        nodePlayer.physicsBody?.dynamic = true
        nodePlayer.physicsBody?.categoryBitMask = PhysicsCategory.Player
        nodePlayer.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        nodePlayer.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        addChild(nodePlayer)
    }
    func random() -> CGFloat
    {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat
    {
        return random() * (max - min) + min
    }
    func degToRad(degree: Double) -> CGFloat
    {
        return CGFloat(Double(degree) / 180.0 * M_PI)
    }
    
    
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
    
    //
    //MARK: - Collision Detection
    //
    func enemyDidCollideWithPlayer(enemy:SKSpriteNode, player:SKSpriteNode) {
        print("Hit")
        
        let removeAllAction=SKAction.removeFromParent()
        self.scene?.removeFromParent()

        let loseAction = SKAction.runBlock() {
            let reveal = SKTransition.flipVerticalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        
        runAction(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
        runAction(SKAction.sequence([loseAction,removeAllAction]))

    }
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Enemy != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Player != 0)) {
            enemyDidCollideWithPlayer(firstBody.node as! SKSpriteNode, player: secondBody.node as! SKSpriteNode)
        }
        
    }
}
