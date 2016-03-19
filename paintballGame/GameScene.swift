import SpriteKit

//phsyics categories

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    
    static let Player: UInt32       = 0b1
    static let Paintball: UInt32    = 0b10
    static let Bunker   : UInt32    = 0b100

}

//vector math


func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}





class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let humanPlayer = SKSpriteNode(imageNamed: "roundplayer20")
    let computerPlayerOne = SKSpriteNode(imageNamed: "roundplayer20")
    let computerPlayerTwo = SKSpriteNode(imageNamed: "roundplayer20")
    let computerPlayerThree = SKSpriteNode(imageNamed: "roundplayer20")
    
    var leftButton: SKSpriteNode! = nil
    var rightButton: SKSpriteNode! = nil
    var upButton: SKSpriteNode! = nil
    var downButton: SKSpriteNode! = nil
    var shotCounter: Int = 0
    var shotCountLabel: SKLabelNode! = nil
    
    var paintballSpeed: NSTimeInterval = 2 // 1 very fast 4 very slow
    
    func setUpButtons() {
        leftButton = SKSpriteNode(imageNamed: "leftarrow64")
        leftButton.anchorPoint = CGPoint(x: 0, y: 0)
        leftButton.position = CGPoint(x: 0, y: 0)
        self.addChild(leftButton)
        
        rightButton = SKSpriteNode(imageNamed: "rightarrow64")
        rightButton.anchorPoint = CGPointZero
        rightButton.position = CGPoint(x: leftButton.frame.width, y: 0)
        self.addChild(rightButton)
        
        upButton = SKSpriteNode(imageNamed: "uparrow64")
        upButton.anchorPoint = CGPointZero
        upButton.position = CGPoint(x: leftButton.frame.width + rightButton.frame.width, y: 0)
        self.addChild(upButton)
        
        downButton = SKSpriteNode(imageNamed: "downarrow64")
        downButton.anchorPoint = CGPointZero
        downButton.position = CGPoint(x: leftButton.frame.width * 3, y: 0)
        self.addChild(downButton)
        
        
        shotCountLabel = SKLabelNode(text: "\(shotCounter)")
        shotCountLabel.position = CGPoint(x: size.width * 0.85, y: size.height * 0.03)
        self.addChild(shotCountLabel)
        
    }

    func setUpBunkers() {
       
        
        let bunkerColor = UIColor(hue:1, saturation:1, brightness:0.69, alpha:1)
        
        var rows = 0
        
        
        let arrayOfWidth : [CGFloat]  = [0.1, 0.5, 0.9]

        let arrayOfHeight : [CGFloat] = [0.2, 0.45, 0.65, 0.9]
        
        while rows < 4 {
//            print("rows \(rows)")

            var i = 0

            while i < 3 {
//                print("i \(i)")
                
              
                
                let squareBunker = SKSpriteNode(color: bunkerColor, size: CGSize(width: 40, height: 40))
                
                squareBunker.position = CGPoint(x: size.width * arrayOfWidth[i], y: size.height * arrayOfHeight[rows])
                
                addChild(squareBunker)
                
                squareBunker.physicsBody = SKPhysicsBody(rectangleOfSize: squareBunker.size) // 1
                squareBunker.physicsBody?.dynamic = false // 2
                squareBunker.physicsBody?.categoryBitMask = PhysicsCategory.Bunker // 3
                squareBunker.physicsBody?.contactTestBitMask = PhysicsCategory.Paintball // 4
                squareBunker.physicsBody?.collisionBitMask = PhysicsCategory.Player // 5
                
                i++
            }
            
            rows++
            
        }

        
    }
    
    let joystick = AnalogJoystick(diameter: 100)
    
    
    
    override func didMoveToView(view: SKView) {
        
        addChild(joystick)
        joystick.position = CGPoint(x: 50, y: 50)
        joystick.substrate.color = UIColor.grayColor()
        joystick.trackingHandler = { jData in
            
            print("jdata.angular is \(jData.angular) jdata.velocity is \(jData.velocity)")
            // something...
            // jData contains angular && velocity (jData.angular, jData.velocity)
            
//            self.humanPlayer.position.x += 1
            
            
            
//            self.humanPlayer.position.x += jData.angular
//            self.humanPlayer.position = jData.velocity
            
            let xMovement = jData.velocity.x
            let yMovement = jData.velocity.y
            
            // 1 = 49.975
            
            self.humanPlayer.position.x += xMovement / 20
            self.humanPlayer.position.y += yMovement / 20
            
        }

        backgroundColor = SKColor(hue: 0.33, saturation: 1, brightness: 0.54, alpha: 1)

        humanPlayer.position = CGPoint(x: size.width * 0.5, y: size.height * 0.15)
        addChild(humanPlayer)
        
        setUpBunkers()
//        setUpButtons()
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        humanPlayer.physicsBody = SKPhysicsBody(circleOfRadius: humanPlayer.size.width / 2)
        humanPlayer.physicsBody?.dynamic = true
        humanPlayer.physicsBody?.categoryBitMask = PhysicsCategory.Player
        humanPlayer.physicsBody?.collisionBitMask = PhysicsCategory.Bunker
        
        
//        setUpOpponents()
        
        
        
        
        let prefs = NSUserDefaults.standardUserDefaults()
        let paintballSpeedFromStorage = prefs.floatForKey("paintballSpeed")
        paintballSpeed = Double(paintballSpeedFromStorage)
        
        
    }
    
    func setUpOpponents() {
        
     
        let arrayOfComputerPlayers = [computerPlayerOne, computerPlayerTwo, computerPlayerThree]
        let arrayOfWidth : [CGFloat]  = [0.1, 0.5, 0.9]
        let arrayOfFirstPositionMovement : [CGFloat] = [45, 45, -45]
        
        var i = 0
            
        while i < 3 {
            
//            print("i \(i)")
            
            let computerPlayerToPlaceOnScreen: SKSpriteNode = arrayOfComputerPlayers[i]
        
            computerPlayerToPlaceOnScreen.position = CGPoint(x: size.width * arrayOfWidth[i], y: size.height * 0.96)
            addChild(computerPlayerToPlaceOnScreen)
            
            computerPlayerToPlaceOnScreen.physicsBody = SKPhysicsBody(circleOfRadius: computerPlayerToPlaceOnScreen.size.width / 2)
            computerPlayerToPlaceOnScreen.physicsBody?.dynamic = true
            computerPlayerToPlaceOnScreen.physicsBody?.categoryBitMask = PhysicsCategory.Player
            computerPlayerToPlaceOnScreen.physicsBody?.contactTestBitMask = PhysicsCategory.Paintball
            
            let positionMovement: CGFloat = arrayOfFirstPositionMovement[i]
            let negativeOne: CGFloat = -1
            
            let firstPositionMovement = SKAction.moveToX(computerPlayerToPlaceOnScreen.position.x + positionMovement, duration: 0.7)
    //        let movePlayerLeft = SKAction.moveToX(computerPlayerToPlaceOnScreen.position.x - 150, duration: 2)
            let secondPositionMovement = SKAction.moveByX(positionMovement * negativeOne, y: 0, duration: 0.7)
            
            let fireShot = SKAction.performSelector("shootPaintballForComputer", onTarget: self)
            
            let sequence = SKAction.sequence([firstPositionMovement, fireShot, secondPositionMovement])
            
            let sequenceRepeating = SKAction.repeatActionForever(sequence)
            
            computerPlayerToPlaceOnScreen.runAction(sequenceRepeating)
            
//            let shotTime = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "shootPaintballForComputer", userInfo: nil, repeats: true)
            
            
    //        shotTime.fire()
            
            i++
        
        }
        
        
        
    }
    
    func shootPaintballForComputer() {
        
        
        
//        print("computer position is \(computerPlayerOne.position)")
//
//        print("node.parent is \(computerPlayerOne.parent)")
        var i = 0
        let arrayOfComputerPlayers = [computerPlayerOne, computerPlayerTwo, computerPlayerThree]
        
        while i < 3 {
            
            
            let computerPlayer: SKSpriteNode = arrayOfComputerPlayers[i]

            
            if computerPlayer.parent != nil {
                
                let humanPositionToTheRight = CGPoint(x: humanPlayer.position.x + 27, y: humanPlayer.position.y)
                let humanPositionToTheLeft = CGPoint(x: humanPlayer.position.x - 27, y: humanPlayer.position.y)

                
                shootPaintballFromStartPositionTowards(computerPlayer.position, towardsPosition: humanPositionToTheLeft)
                shootPaintballFromStartPositionTowards(computerPlayer.position, towardsPosition: humanPositionToTheRight)
                shootPaintballFromStartPositionTowards(computerPlayer.position, towardsPosition: humanPlayer.position)

                
            }
            
            i++
        
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        
        
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        
        
        
        
        
        
        if leftButton.containsPoint(touchLocation) {
//            print("move left")
            
            let movePlayerLeft = SKAction.moveToX(humanPlayer.position.x - 450, duration: 6)
            humanPlayer.runAction(movePlayerLeft)
        }
        
        else if rightButton.containsPoint(touchLocation) {
//            print("move right")
            
            let movePlayerRight = SKAction.moveToX(humanPlayer.position.x + 450, duration: 6)
            humanPlayer.runAction(movePlayerRight)
        }
        
        else if upButton.containsPoint(touchLocation) {
//            print("move up")
            
            let movePlayerUp = SKAction.moveToY(humanPlayer.position.y + 900, duration: 12)
            humanPlayer.runAction(movePlayerUp)
        }
        
        else if downButton.containsPoint(touchLocation) {
//            print("move down")
            
            let movePlayerDown = SKAction.moveToY(humanPlayer.position.y - 900, duration: 12)
            humanPlayer.runAction(movePlayerDown)
        }
        
        
        

    }
    
    
    func shootPaintballFromStartPositionTowards(startPosition: CGPoint, towardsPosition: CGPoint){
        
        // 2 - Set up initial location of projectile
        
        let paintballShape = SKShapeNode(circleOfRadius: 3)
        paintballShape.fillColor = UIColor.yellowColor()
        paintballShape.lineWidth = 0
        
        let texture = view?.textureFromNode(paintballShape)
        let paintball = SKSpriteNode(texture: texture)
        
        
        
        
        
        
        let offset = towardsPosition - startPosition

        let direction = offset.normalized()
//        print("direction \(direction)")
        
        var largerNumber: CGFloat
        
        if fabs(direction.x) > fabs(direction.y) {
            largerNumber = direction.x
//            print("x is larger number")
        }
        
        else {
            largerNumber = direction.y
//            print("y is larger number")

        }
        
        let multiplier = (((humanPlayer.size.width / 2) + (paintball.size.width / 2)) / fabs(largerNumber))
        
        let xStartPosition = startPosition.x + (direction.x * multiplier * 1.1)
        
        let yStartPosition = startPosition.y + (direction.y * multiplier * 1.1)
        
//        print("player x position: \(startPosition.x) player y position: \(startPosition.y)")

        
//        print("x start position: \(xStartPosition) y start position: \(yStartPosition)")
        
        
        paintball.position = CGPoint(x: startPosition.x + (direction.x * multiplier * 1.1), y: startPosition.y + (direction.y * multiplier * 1.1))
        
        
        
        
        
        
        
        
        
        
        paintball.physicsBody = SKPhysicsBody(circleOfRadius: paintball.frame.width/2)
        //check on this frame later
        
        paintball.physicsBody?.dynamic = true
        paintball.physicsBody?.categoryBitMask = PhysicsCategory.Paintball
        paintball.physicsBody?.contactTestBitMask = PhysicsCategory.Bunker | PhysicsCategory.Player
        paintball.physicsBody?.collisionBitMask = PhysicsCategory.None
        paintball.physicsBody?.usesPreciseCollisionDetection = true
        
        // 3 - Determine offset of location to projectile
        
        // 4 - Bail out if you are shooting down or backwards
        //        if (offset.x < 0) { return }
        
        // 5 - OK to add now - you've double checked position
        addChild(paintball)
        
        // 6 - Get the direction of where to shoot
        
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
//        print("shoot amount \(shootAmount)")
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + paintball.position
//        print("real dest \(realDest)")
        
        
        // 9 - Create the actions
        let actionMove = SKAction.moveTo(realDest, duration: paintballSpeed)
        let actionMoveDone = SKAction.removeFromParent()
        paintball.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
        
        
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        
        

        
        
        
        if !leftButton.containsPoint(touchLocation) && !rightButton.containsPoint(touchLocation) && !upButton.containsPoint(touchLocation) && !downButton.containsPoint(touchLocation){
            

//        print("touch location: \(touchLocation)")
        
            if humanPlayer.parent != nil {
            
                shootPaintballFromStartPositionTowards(humanPlayer.position, towardsPosition: touchLocation)
                shotCounter++
                shotCountLabel.text = "\(shotCounter)"
            }
            
        }
        
        else {
                humanPlayer.removeAllActions()

        }
    }
    
    func paintballDidCollideWithBunker(paintball:SKSpriteNode, bunker:SKSpriteNode) {
//        print("Hit")
        bunker.removeFromParent()
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
//        print("did begin contact called")
        
        contact.bodyA

        //bunker has largest bitmask
        
        var bunker: SKPhysicsBody
        var paintball: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
//            print("bunker is body B")
            
            paintball = contact.bodyA
            bunker = contact.bodyB
            
            paintball.node?.removeFromParent()
            bunker.node?.removeFromParent()
            
            
        } else {
            
//            print("bunker is body A")

            paintball = contact.bodyB
            bunker = contact.bodyA
            
            paintball.node?.removeFromParent()

        }
//
//        
//        // 2
//        if ((firstBody.categoryBitMask & PhysicsCategory.Bunker != 0) &&
//            (secondBody.categoryBitMask & PhysicsCategory.Paintball != 0)) {
//
//                paintballDidCollideWithBunker(firstBody.node as! SKSpriteNode, bunker: secondBody.node as! SKSpriteNode)
//                
//                
//                
//              
//        }
        
    }
    
}

