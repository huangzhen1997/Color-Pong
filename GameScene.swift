//
//  GameScene.swift
//  Color-Pong
//
//  Created by  huangzhen on 18/03/2017.
//  Copyright © 2017  huangzhen. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene , SKPhysicsContactDelegate{
   
    var index = 0
    var contentCreated = false
    var speedflag: Bool = false   //difficult
    var actflag: Bool = false  //medium
    var ball = SKShapeNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    
    
   
    
    var score=[0,0]
    var update=0
    let soundAction = SKAction.playSoundFileNamed("p.mp3", waitForCompletion: false)
    let scorelable = SKLabelNode(fontNamed: "Chalkduster")
    let highestcore = SKLabelNode(fontNamed: "Chalkduster")
    var firstUpdate = true
    var startTime=0.0
    
    var col=[UIColor(red: 1.1, green: 1.0, blue: 0.65, alpha: 1.0),UIColor(red: 0.6, green: 1.0, blue: 0.55, alpha: 1.0),UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 1.0),UIColor(red: 0.6, green: 1.0, blue: 0, alpha: 1.0),UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)]
    
    var indexi = 0 // accelerate
    
    func starfieldEmitter(color: SKColor, starSpeedY: CGFloat, starsPerSecond: CGFloat, starScaleFactor: CGFloat) -> SKEmitterNode {
        
        // Determine the time a star is visible on screen
        let lifetime =  frame.size.height * UIScreen.main.scale / starSpeedY
        
        // Create the emitter node
        let emitterNode = SKEmitterNode()
        
        emitterNode.particleTexture = SKTexture(imageNamed: "Star")
        emitterNode.particleBirthRate = starsPerSecond
        emitterNode.particleColor = SKColor.lightGray
        emitterNode.particleSpeed = starSpeedY * -1
        emitterNode.particleScale = starScaleFactor
        emitterNode.particleColorBlendFactor = 1
        emitterNode.particleLifetime = lifetime
        
        // Position in the middle at top of the screen
        emitterNode.position = CGPoint(x: 0, y: frame.size.height)
        emitterNode.particlePositionRange = CGVector(dx: frame.size.width, dy: 0)
        
        // Fast forward the effect to start with a filled screen
        emitterNode.advanceSimulationTime(TimeInterval(lifetime))
        
        return emitterNode
    }

    
    override func didMove(to view: SKView) {
        
        if !contentCreated{
        
         
            scorelable.text="\(score[0])"
            
            
            
        // Add Starfield with 3 emitterNodes for a parallax effect
        // - Stars in top layer: light, fast, big
        // - ...
        // - Stars in back layer: dark, slow, small
            
            
        print(currentGameType)
        if(currentGameType != .hard ){
            
            scorelable.text=("win \(score[0]) : lost:\(score[1]) ")
        }
            
        
        scorelable.fontSize=12
        scorelable.fontColor=SKColor.white
        scorelable.position=CGPoint(x: enemy.position.x, y: enemy.position.y+90)
            
            
        
        if(currentGameType == .easy){
                highestcore.text=("relaxing-highest: \(UserDefaults.standard.integer(forKey: "easyh"))")
        }
        else if(currentGameType == .med){
            highestcore.text=("interesting-highest: \(UserDefaults.standard.integer(forKey: "midh"))")
        }
        
        else if(currentGameType == .hard){
            highestcore.text=("challenging-highest: \(UserDefaults.standard.integer(forKey: "hardh"))")
            }
        highestcore.fontSize=12
        
        self.addChild(scorelable)
        self.addChild(highestcore)
            
        var emitterNode = starfieldEmitter(color: SKColor.lightGray, starSpeedY: 50, starsPerSecond: 1, starScaleFactor: 0.2)
        emitterNode.zPosition = -10
        self.addChild(emitterNode)
        
        emitterNode = starfieldEmitter(color: SKColor.gray, starSpeedY: 30, starsPerSecond: 2, starScaleFactor: 0.1)
        emitterNode.zPosition = -11
        self.addChild(emitterNode)
        
        emitterNode = starfieldEmitter(color: SKColor.darkGray, starSpeedY: 15, starsPerSecond: 4, starScaleFactor: 0.05)
        emitterNode.zPosition = -12
        self.addChild(emitterNode)
        
        
        ball = SKShapeNode(circleOfRadius:10)
        ball.position = CGPoint(x:0,y:0)
        ball.fillColor = UIColor(red: 0.3, green: 0.9, blue: 0.6 , alpha: 1.0)
        ball.strokeColor = ball.fillColor
        ball.physicsBody = SKPhysicsBody(circleOfRadius:20)
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.friction=0
        ball.physicsBody?.linearDamping=0
        ball.physicsBody?.angularDamping=0
        ball.physicsBody?.restitution=1.0
        ball.physicsBody?.allowsRotation=false
        ball.physicsBody?.contactTestBitMask=0b0001
            ball.name = "ball"
            
        
            
        
        self.addChild(ball)
        enemy=self.childNode(withName: "enemy") as! SKSpriteNode
        main=self.childNode(withName: "main") as! SKSpriteNode
            
            
        
            
                
     

        
            
          /*  self.run(SKAction.sequence([SKAction.wait(forDuration: 9.0),SKAction.run({
                self.removeChildren(in: [(self.blocl1)])
            })]))
            
            self.run(SKAction.sequence([SKAction.wait(forDuration: 10.0),SKAction.run({
                self.removeChildren(in: [(self.blocl2)])
            })]))
 
            */
           
            
        
        
        
        ball.physicsBody?.applyImpulse(CGVector(dx:-20,dy:20))
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.categoryBitMask=0b0100
        
        
        
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        self.physicsWorld.contactDelegate=self
        
            contentCreated = true
            
            let effectNode = SKEffectNode()
            effectNode.shouldRasterize = true
            effectNode.name = "effectNode"
            ball.addChild(effectNode)
            
            
            let effectChild = SKShapeNode(circleOfRadius: 20.0)
            effectChild.fillColor = ball.fillColor
            effectChild.strokeColor = ball.strokeColor
            effectChild.name = "effectChild"
            effectNode.addChild(effectChild)
            effectNode.filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius":20.0])
        
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
       
        
        
        
        index = Int (arc4random_uniform(5))
        if(update<=30){
            return
        }
        
        
        update  =  0
        
        ball.fillColor = col[index]
        ball.strokeColor = ball.fillColor
        indexi = indexi + 1
        let effectNode = ball.childNode(withName: "effectNode") as? SKEffectNode
        let effectChild = effectNode?.childNode(withName: "effectChild") as? SKShapeNode
        effectChild?.fillColor = ball.fillColor
        effectChild?.strokeColor = ball.strokeColor
        self.run(soundAction)
        
        /*let xxx = ball.physicsBody?.velocity.dx
        let yyy = ball.physicsBody?.velocity.dy
        if (indexi > 10)
        {
            if (speedflag){
                let accelerate = CGFloat(1.4)
                ball.physicsBody?.velocity = CGVector(dx: (xxx! * accelerate) , dy:(yyy! * accelerate))
  
            }
            else if (actflag){
                let accelerate = CGFloat(1.2)
                ball.physicsBody?.velocity = CGVector(dx: (xxx! * accelerate) , dy:(yyy! * accelerate))
            }
        indexi = 0
        }*/
        
        if(currentGameType == .hard){
            var easys = UserDefaults.standard.integer(forKey: "hardh")
            if (easys < indexi){
                UserDefaults.standard.set(indexi, forKey: "hardh")
                highestcore.text="Insane-highest: \(indexi)"
            }
        }

    }
    
    
    
    
    
    
    func check(){
        indexi = 0
        ball.physicsBody?.velocity=CGVector(dx:0.0,dy:0.0)
        ball.position = CGPoint(x:0,y:0)
        
    }
    
    func reapplyForce(){
        let sequence = SKAction.sequence([SKAction.wait(forDuration: 2.0),SKAction.applyImpulse(CGVector(dx:-20,dy:20), duration: 0.1)])
        ball.run(sequence)
    }
    
    
    func randRange (lower : Int , upper : Int) -> Int {
        let difference = upper - lower
        return Int(Float(arc4random())/Float(RAND_MAX) * Float(difference + 1)) + lower
    }
    
    func restart(state: Int ) {
        
       /* if(state==3){
            speedflag=true
        }
        
        else if (state==2){
            actflag=true
        }
        */
        
        
        if ((ball.physicsBody?.velocity.dy)! > CGFloat(0)){
            if (((ball.physicsBody?.velocity.dx)! - (ball.physicsBody?.velocity.dy)!) > CGFloat(15)){
                let  xxx=ball.physicsBody?.velocity.dx
                let yyy=ball.physicsBody?.velocity.dy
                ball.physicsBody?.velocity = CGVector(dx: (xxx! - CGFloat(1)) , dy:(yyy! + CGFloat(4)))
            }
        }
            
        else if (((ball.physicsBody?.velocity.dx)! - (ball.physicsBody?.velocity.dy)!) > CGFloat(15)){
            let  xxx=ball.physicsBody?.velocity.dx
            let yyy=ball.physicsBody?.velocity.dy
            ball.physicsBody?.velocity = CGVector(dx: (xxx! - CGFloat(1)) , dy:(yyy! - CGFloat(4)))
            
        }
        
        if (((ball.physicsBody?.velocity.dy)!) < CGFloat(2) && ball.position.y > CGFloat(0)){
            let  xxx=ball.physicsBody?.velocity.dx
            let yyy=ball.physicsBody?.velocity.dy
            ball.physicsBody?.velocity=CGVector(dx: (xxx! ) , dy:(yyy! - CGFloat(4)))
        }
        else if(((ball.physicsBody?.velocity.dy)!) < CGFloat(2) && ball.position.y < CGFloat(0)){
            let  xxx=ball.physicsBody?.velocity.dx
            let yyy=ball.physicsBody?.velocity.dy
            ball.physicsBody?.velocity=CGVector(dx: (xxx! ) , dy:(yyy! + CGFloat(4)))
        }
        
        if(ball.position.y > (enemy.position.y+20)){
            score[0] += 1
            
            if(currentGameType == .easy){
            var easys = UserDefaults.standard.integer(forKey: "easyh")
            if (easys < score[0]){
                UserDefaults.standard.set(score[0], forKey: "easyh")
                highestcore.text="relaxing-highest: \(score[0])"
                
                }
            }
            else if(currentGameType == GameType.med){
                var meds = UserDefaults.standard.integer(forKey: "midh")
                if (meds < score[0]){
                    UserDefaults.standard.set(score[0], forKey: "midh")
                    highestcore.text="interesting-highest: \(score[0])"
                }
            }
           // else if(currentGameType == .hard){
             //   var easys = UserDefaults.standard.integer(forKey: "hardh")
               // if (easys < indexi){
                 //   UserDefaults.standard.set(indexi, forKey: "hardh")
                   // highestcore.text="Insane-highest: \(indexi)"
                //}
            //}
            
            scorelable.text=("win \(score[0]) : lost:\(score[1]) ")
           //main win
            check()
            let yy = randRange(lower:-30,upper:-25)
            let xx = randRange(lower: 10,upper: 20)
            let sequence = SKAction.sequence([SKAction.wait(forDuration: 2.0),SKAction.applyImpulse(CGVector(dx:xx,dy:yy), duration: 0.1)])
            ball.run(sequence)
        }
        else if (ball.position.y < (main.position.y-20)){
            score[1]  += 1
            scorelable.text=("win \(score[0]) : lost:\(score[1]) ")
            //enemy win
            check()
            let yy = randRange(lower:30,upper:25)
            let xx = randRange(lower: -10,upper: 5)
            let sequence = SKAction.sequence([SKAction.wait(forDuration: 2.0),SKAction.applyImpulse(CGVector(dx:xx,dy:yy), duration: 0.1)])
            ball.run(sequence)
            
        }
        
}
    
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            let location = touch.location(in : self)
            if currentGameType == .player2{
                if location.y>0{
                    
                    enemy.run(SKAction.moveTo(x:location.x,duration:0.01))
                    
                }
                
                if location.y<0{
                    
                    main.run(SKAction.moveTo(x:location.x,duration:0.01))
                }
            }
                
            else{
                
                main.run(SKAction.moveTo(x:location.x,duration:0.01))
            }

        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        for touch in touches{
            let location = touch.location(in : self)
            
            if currentGameType == .player2{
                if location.y>0{
                    
                    enemy.run(SKAction.moveTo(x:location.x,duration:0.01))
                    
                }
                
                if location.y<0{
                
                    main.run(SKAction.moveTo(x:location.x,duration:0.01))
                }
            }
            
            else{
            
                main.run(SKAction.moveTo(x:location.x,duration:0.01))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        switch currentGameType {
        case .easy:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.1))
            restart(state: 1)
        case .med:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.002))
            restart(state: 2)
        case .hard:
            scorelable.text=("rounds: \(indexi)")
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.00))
            restart(state:3)
        case .player2:
            scorelable.text=("lowwer \(score[0]) : upper:\(score[1]) ")
            restart(state:3)
       
        }
        update = update + 1
    }
 
}
