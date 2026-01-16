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
    
    var scoreLabel: SKLabelNode!
    
    var removedItems: [SKNode] = []
    
    var canJump = true;
    
    var caveNodes: [SKSpriteNode] = []
    
    var vc: GameViewController!
    //ONCE
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.camera = cam
        player = (self.childNode(withName: "player") as! SKSpriteNode)
        player.physicsBody?.velocity.dx = 5;
        scoreLabel = (self.childNode(withName: "scoreLabel") as! SKLabelNode)
//
//        for i in 0...50 {
//            let node = SKSpriteNode(color: .red, size: CGSize(width: 171, height: 167))
//            node.texture = SKTexture(imageNamed: "tile")
//            node.position = CGPoint(x: -580 + (171 * (i)), y: -130)
//            node.color = .systemGreen
//            node.name = "ground"
//            node.physicsBody?.contactTestBitMask = 2
//            node.physicsBody?.pinned = true
//            node.physicsBody?.categoryBitMask = 2
//            addChild(node)
//        }
        
        //Generate Random Grid
        
        for x in 0...100 {
            for y in 0...100 {
                if (x == 0 || x == 100) {
                  createCaveNode(x: x, y: y, addToList: true)
                    continue;
                } else if (y == 0 || y == 100) {
                    createCaveNode(x: x, y: y, addToList: true)
                    continue;
                } else if ((x == 1 && y == 1) || (x == 1 && y == 2) || (x == 2 && y == 1)) {
                    continue;
                }
                if Int.random(in: 0...100) > 60 {
                    createCaveNode(x: x, y: y, addToList: true)
                }
            }
        }
        
        for node in caveNodes {
            let postion = node.position
            var neighborCount = 0
            
            if(postion.x == 0 || postion.x == 100 * 100 || postion.y == 0 || postion.y == 100 * 100) {
                continue
            }
            
            if(self.nodes(at: CGPoint(x: postion.x + 100, y: postion.y)).count > 0) {
                neighborCount += 1
            }
            if(self.nodes(at: CGPoint(x: postion.x - 100, y: postion.y)).count > 0) {
                neighborCount += 1
            }
            if(self.nodes(at: CGPoint(x: postion.x + 100, y: postion.y + 100)).count > 0) {
                neighborCount += 1
            }
            if(self.nodes(at: CGPoint(x: postion.x - 100, y: postion.y + 100)).count > 0) {
                neighborCount += 1
            }
            if(self.nodes(at: CGPoint(x: postion.x - 100, y: postion.y - 100)).count > 0) {
                neighborCount += 1
            }
            if(self.nodes(at: CGPoint(x: postion.x + 100, y: postion.y - 100)).count > 0) {
                neighborCount += 1
            }
            if(self.nodes(at: CGPoint(x: postion.x + 100, y: postion.y + 100)).count > 0) {
                neighborCount += 1
            }
            if(self.nodes(at: CGPoint(x: postion.x, y: postion.y + 100)).count > 0) {
                neighborCount += 1
            }
            if(self.nodes(at: CGPoint(x: postion.x, y: postion.y - 100)).count > 0) {
                neighborCount += 1
            }
            
            if(neighborCount < 4) {
                caveNodes.re(node)
                node.removeFromParent()
            }
            
            
        }
        
        
        //IF they dont have at least four neighbors remove
        
        
        
        
        
    }
    
    //EVERY FRAME
    override func update(_ currentTime: TimeInterval) {
        cam.position.x = player.position.x + 500
        cam.position.y = player.position.y
        scoreLabel.position = CGPoint(x: cam.position.x + 500, y: cam.position.y + 150)
        
        if(player.physicsBody!.velocity.dx <= CGFloat(500)) {
            player.physicsBody?.velocity.dx += 1;
        }
    }
    
    //Listening for Contact
    func didBegin(_ contact: SKPhysicsContact) {
        print(contact)
        
        checkContact(nodeName: "coin") { [self] coin in
            score += 1
            scoreLabel.text = "Score: \(score)"
            removedItems.append(coin)
            removedItems.last!.removeFromParent()
        }
        
        
        checkContact(nodeName: "ground") { [self] ground in
            print("touch gorund")
            canJump = true;
            vc.jumpButton.isEnabled = true
        }
        
        checkContact(nodeName: "spike") { [self] spike in
            die()
        }
        
        
        func checkContact(nodeName: String, action: ((SKNode) -> Void)?) {
            if((contact.bodyA.node?.name == nodeName || contact.bodyB.node?.name == nodeName) && (contact.bodyA.node?.name == "player" || contact.bodyB.node?.name == "player")) {
                
                let node = contact.bodyA.node?.name == nodeName ? contact.bodyA.node : contact.bodyB.node

                action?(node!)
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        checkContact(nodeName: "ground") { [self] ground in
            print("end touch gorund")
            canJump = false;
//            vc.jumpButton.isEnabled = false
        }
        
        
        
        
        
        func checkContact(nodeName: String, action: ((SKNode) -> Void)?) {
            if((contact.bodyA.node?.name == nodeName || contact.bodyB.node?.name == nodeName) && (contact.bodyA.node?.name == "player" || contact.bodyB.node?.name == "player")) {
                
                let node = contact.bodyA.node?.name == nodeName ? contact.bodyA.node : contact.bodyB.node

                action?(node!)
            }
        }
    }
    
    func die() {
        
        let action = SKAction.run {
            self.player.position = CGPoint(x: 100, y: 100)
        }
            
        player.run(action)
        
        for node in removedItems {
            self.addChild(node)
        }
        
        removedItems.removeAll()
    }
    
    func jump() {
//        if(canJump) {
            print("jump")
            let action = SKAction.run {
                self.player.physicsBody?.velocity.dy = 750
            }
            player.run(action)

//        }
    }
    
    func createCaveNode(x: Int, y: Int, addToList: Bool) {
        let node = SKSpriteNode(color: .systemGreen, size: CGSize(width: 100, height: 100))
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.contactTestBitMask = 2
        node.physicsBody?.pinned = true
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.categoryBitMask = 2
        node.name = "ground"
        node.position = CGPoint(x: 100 * x, y: 100 * y)
        self.addChild(node)
        if(addToList) {
            caveNodes.append(node)
        }
    }
    
    
    
    
    
    
    
}

