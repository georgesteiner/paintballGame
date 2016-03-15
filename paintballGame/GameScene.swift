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
    
    
    
    
//    let roundPlayer = SKShapeNode(circleOfRadius: 10)
    let roundPlayer = SKSpriteNode(imageNamed: "roundplayer20")
    
//    let roundPlayer = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: 20, height: 20))
    
    var leftButton: SKSpriteNode! = nil
    var rightButton: SKSpriteNode! = nil
    var upButton: SKSpriteNode! = nil
    var downButton: SKSpriteNode! = nil
    
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
        
    }

    
    
    
    
    //bunkers
    
    
    func setUpBunkers() {
       
        
        let bunkerColor = UIColor(hue:1, saturation:1, brightness:0.69, alpha:1)
        
        //bottom of field
        
        
        
        let roundBunker = SKShapeNode(circleOfRadius: 20)
        roundBunker.fillColor = bunkerColor
        roundBunker.lineWidth = 0
        roundBunker.position = CGPoint(x: size.width * 0.1, y: size.height * 0.2)
        addChild(roundBunker)

        let roundBunker2 = SKShapeNode(circleOfRadius: 20)
        roundBunker2.fillColor = bunkerColor
        roundBunker2.lineWidth = 0
        roundBunker2.position = CGPoint(x: size.width * 0.9, y: size.height * 0.2)
        addChild(roundBunker2)

        let squareBunker = SKSpriteNode(color: bunkerColor, size: CGSize(width: 40, height: 40))
        squareBunker.position = CGPoint(x: size.width * 0.5, y: size.height * 0.2)
        addChild(squareBunker)
        
        
        
//        let rectangleBunker = SKSpriteNode(color: bunkerColor, size: CGSize(width: 15, height: 10))
        
        var i = 0
        
        while i < 3 {
            print("hello \(i)")
            i++
            
            let arrayOfWidth: Array[CGFloat] = [0.3, 0.5, 0.7]
            let one = arrayOfWidth[0]
            
//            let xCoordinate: Double = size.width * 0.2 * i
            
            
            let squareBunker = SKSpriteNode(color: bunkerColor, size: CGSize(width: 40, height: 40))
            squareBunker.position = CGPoint(x: size.width * 0.3, y: size.height * 0.4)
            addChild(squareBunker)
            
            squareBunker.physicsBody = SKPhysicsBody(rectangleOfSize: squareBunker.size) // 1
            squareBunker.physicsBody?.dynamic = false // 2
            squareBunker.physicsBody?.categoryBitMask = PhysicsCategory.Bunker // 3
            squareBunker.physicsBody?.contactTestBitMask = PhysicsCategory.Paintball // 4
            squareBunker.physicsBody?.collisionBitMask = PhysicsCategory.Player // 5
            
        }

        squareBunker.physicsBody = SKPhysicsBody(rectangleOfSize: squareBunker.size) // 1
        squareBunker.physicsBody?.dynamic = false // 2
        squareBunker.physicsBody?.categoryBitMask = PhysicsCategory.Bunker // 3
        squareBunker.physicsBody?.contactTestBitMask = PhysicsCategory.Paintball // 4
        squareBunker.physicsBody?.collisionBitMask = PhysicsCategory.Player // 5
        
        
    }
    
    
    
    override func didMoveToView(view: SKView) {

        backgroundColor = SKColor(hue: 0.33, saturation: 1, brightness: 0.54, alpha: 1)

        roundPlayer.position = CGPoint(x: size.width * 0.5, y: size.height * 0.15)
        addChild(roundPlayer)
        
        setUpBunkers()
        setUpButtons()
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        roundPlayer.physicsBody = SKPhysicsBody(circleOfRadius: roundPlayer.size.width / 2)
        roundPlayer.physicsBody?.dynamic = true
        roundPlayer.physicsBody?.categoryBitMask = PhysicsCategory.Player
        roundPlayer.physicsBody?.collisionBitMask = PhysicsCategory.Bunker
        
//        roundPlayer.physicsBody?.categoryBitMask =
        
//        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
//        borderBody.friction = 0
//        self.physicsBody = borderBody
        
        
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        
        
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        
        
        
        
        
        
        if leftButton.containsPoint(touchLocation) {
            print("move left")
            
            let movePlayerLeft = SKAction.moveToX(roundPlayer.position.x - 450, duration: 6)
            roundPlayer.runAction(movePlayerLeft)
        }
        
        else if rightButton.containsPoint(touchLocation) {
            print("move right")
            
            let movePlayerRight = SKAction.moveToX(roundPlayer.position.x + 450, duration: 6)
            roundPlayer.runAction(movePlayerRight)
        }
        
        else if upButton.containsPoint(touchLocation) {
            print("move up")
            
            let movePlayerUp = SKAction.moveToY(roundPlayer.position.y + 900, duration: 12)
            roundPlayer.runAction(movePlayerUp)
        }
        
        else if downButton.containsPoint(touchLocation) {
            print("move down")
            
            let movePlayerDown = SKAction.moveToY(roundPlayer.position.y - 900, duration: 12)
            roundPlayer.runAction(movePlayerDown)
        }
        
        
        

    }
    
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        
        
        roundPlayer.removeAllActions()

        
        
        
        if !leftButton.containsPoint(touchLocation) && !rightButton.containsPoint(touchLocation) && !upButton.containsPoint(touchLocation) && !downButton.containsPoint(touchLocation){
            

        
        
        // 2 - Set up initial location of projectile
        
        let paintballShape = SKShapeNode(circleOfRadius: 3)
        paintballShape.fillColor = UIColor.yellowColor()
        paintballShape.lineWidth = 0
        
        let texture = view?.textureFromNode(paintballShape)
        let paintball = SKSpriteNode(texture: texture)
        
        paintball.position = roundPlayer.position
        
        paintball.physicsBody = SKPhysicsBody(circleOfRadius: paintball.frame.width/2)
        //check on this frame later
        
        paintball.physicsBody?.dynamic = true
        paintball.physicsBody?.categoryBitMask = PhysicsCategory.Paintball
        paintball.physicsBody?.contactTestBitMask = PhysicsCategory.Bunker
        paintball.physicsBody?.collisionBitMask = PhysicsCategory.None
        paintball.physicsBody?.usesPreciseCollisionDetection = true

        // 3 - Determine offset of location to projectile
        let offset = touchLocation - paintball.position
        
        // 4 - Bail out if you are shooting down or backwards
//        if (offset.x < 0) { return }
        
        // 5 - OK to add now - you've double checked position
        addChild(paintball)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + paintball.position
        
        // 9 - Create the actions
        let actionMove = SKAction.moveTo(realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        paintball.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
        
        
        
        
        
        
            
        }
    }
    
    func paintballDidCollideWithBunker(paintball:SKSpriteNode, bunker:SKSpriteNode) {
        print("Hit")
        bunker.removeFromParent()
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        print("did begin contact called")
        
        contact.bodyA
        
        // 1
//        var firstBody: SKPhysicsBody
//        var secondBody: SKPhysicsBody
//        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
//            firstBody = contact.bodyA
//            secondBody = contact.bodyB
//        } else {
//            firstBody = contact.bodyB
//            secondBody = contact.bodyA
//        }
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

