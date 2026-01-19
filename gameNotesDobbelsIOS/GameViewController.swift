//
//  GameViewController.swift
//  gameNotesDobbelsIOS
//
//  Created by GREYSON DOBBELS on 7/1/2026.
//

import UIKit
import SpriteKit
import GameplayKit
import JoyStickView

class GameViewController: UIViewController {
    
    let screenSize: CGRect = UIScreen.main.bounds
    var jumpButton: UIButton!
    var joystick: JoyStickView!
    
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
        
         joystick = {
            var stick = JoyStickView(frame: CGRect(x: 50, y: 250, width: 100, height: 100))
             let monitor: JoyStickViewPolarMonitor = { data in
                 let angleInRadians = data.angle * .pi / 180.0
                 
                 let dx = cos(angleInRadians) * data.displacement * 300.0
                 let action = SKAction.run {
                     self.scene2?.player.physicsBody?.velocity.dx = dx
                 }
                 self.scene2?.player.run(action)
                 
                 print("Angle: \(data.angle)°, Rad: \(String(format: "%.2f", angleInRadians)), dx: \(dx)")
             }
             stick.monitor = .polar(monitor: monitor)
            return stick
        }()
        
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
            view.addSubview(joystick)

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
