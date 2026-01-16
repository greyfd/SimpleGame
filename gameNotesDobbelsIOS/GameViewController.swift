//
//  GameViewController.swift
//  gameNotesDobbelsIOS
//
//  Created by GREYSON DOBBELS on 7/1/2026.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    let screenSize: CGRect = UIScreen.main.bounds
    var jumpButton: UIButton!
    
    @IBOutlet weak var jumpOutlet: UIButton!
    
    
    var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Respawn", for: .application)
        button.setImage(UIImage(systemName: "arrow.trianglehead.clockwise"), for: .application)
        return button
    }()
    
    
    
    var scene2: GameScene?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jumpButton = {
                let button = UIButton(type: .system)
                button.setTitle("Jump", for: .normal)
                button.setTitle("Can't Jump", for: .disabled)
            let imageConfig = UIImage.SymbolConfiguration(scale: .large)
                    button.setImage(UIImage(systemName: "arrow.up", withConfiguration: imageConfig), for: .normal)
                    
                    button.semanticContentAttribute = .forceRightToLeft
                    
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
                    button.tintColor = .white
                
                button.sizeToFit()
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
                let xPos = screenSize.width - 300
                    let yPos = screenSize.height - 120
                    
                    button.center = CGPoint(x: xPos, y: yPos)
                let buttonAction = UIAction(handler: { [self] _ in
                    scene2?.jump()
                })
                button.addAction(buttonAction, for: .touchUpInside)
                
                return button
            }()
        
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
                    UIDevice.current.setValue(value, forKey: "orientation")
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
    
                scene2 = scene as? GameScene
                scene2!.vc = self
                // Present the scene
                view.presentScene(scene)
            }
            
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.addSubview(jumpButton)
            NSLayoutConstraint.activate([
                            // Pin to the Right side (minus 40 padding)
                            jumpButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
                            // Pin to the Bottom (minus 20 padding)
                            jumpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
                        ])
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBAction func jumpAction(_ sender: UIButton) {
        if(scene2?.canJump == true) {
            print("jump")
            scene2?.player.physicsBody?.velocity.dy += 500
        }
    }
}
