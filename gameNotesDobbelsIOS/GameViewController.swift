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

    
    var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Respawn", for: .application)
        button.setImage(UIImage(systemName: "arrow.trianglehead.clockwise"), for: .application)
        return button
    }()
    
    var frame: UIView {
        let frame = UIView(frame: screenSize)
        frame.backgroundColor = .systemRed
        return frame
    }
    
    var scene2: GameScene?
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBAction func jumpAction(_ sender: UIButton) {
        print("jump")
        scene2?.player.physicsBody?.velocity.dy += 500
    }
}
