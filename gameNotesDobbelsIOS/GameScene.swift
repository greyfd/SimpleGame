//
//  GameScene.swift
//  gameNotesDobbelsIOS
//
//  Created by GREYSON DOBBELS on 7/1/2026.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score: Int = 0
    
    let cam = SKCameraNode()

    var player: SKSpriteNode!
    
    var ground: SKSpriteNode!
    
    var newGround: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    
    
    //ONCE
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.ground = (self.childNode(withName: "ground") as! SKSpriteNode)
        self.camera = cam
        player = (self.childNode(withName: "player") as! SKSpriteNode)
        player.physicsBody?.velocity.dx = 5;
        scoreLabel = (self.childNode(withName: "scoreLabel") as! SKLabelNode)
//
//        for i in 0...50 {
//            let node = SKSpriteNode(color: .red, size: CGSize(width: 171, height: 167))
//            node.texture = SKTexture(imageNamed: "tile")
//            node.position = CGPoint(x: -580 + (171 * (i)), y: 0)
//            addChild(node)
//        }
    }
    
    //EVERY FRAME
    override func update(_ currentTime: TimeInterval) {
        cam.position.x = player.position.x + 500
        cam.position.y = player.position.y
        scoreLabel.position = CGPoint(x: cam.position.x + 500, y: cam.position.y + 150)
        
        if(player.physicsBody!.velocity.dx <= CGFloat(100)) {
            player.physicsBody?.velocity.dx += 5;
        }
    }
    
    //Listening for Contact
    func didBegin(_ contact: SKPhysicsContact) {
        print(contact)
        
        checkContact(nodeName: "coin") { [self] coin in
            score += 1
            scoreLabel.text = "Score: \(score)"
            coin.removeFromParent()
        }
        
        checkContact(nodeName: "spike") { [self] spike in
            let action = SKAction.run {
                self.player.position = CGPoint(x: 0, y: 0)
            }
                
            player.run(action)
        }
        
        
        func checkContact(nodeName: String, action: ((SKNode) -> Void)?) {
            if((contact.bodyA.node?.name == nodeName || contact.bodyB.node?.name == nodeName) && (contact.bodyA.node?.name == "player" || contact.bodyB.node?.name == "player")) {
                
                let node = contact.bodyA.node?.name == nodeName ? contact.bodyA.node : contact.bodyB.node

                action?(node!)
            }
        }
    }
    
    func die() {
        
    }
    
    
    
    
    
    
    
}

