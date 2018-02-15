//
//  GameViewController.swift
//  Color-Pong
//
//  Created by  huangzhen on 18/03/2017.
//  Copyright © 2017  huangzhen. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

var currentGameType = GameType.med

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view as! SKView
        let gameScene = GameScene(fileNamed:"GameScene")
        //gameScene?.size = self.view.frame.size
        gameScene?.scaleMode = .aspectFill
        view.presentScene(gameScene)
        view.ignoresSiblingOrder = true
        
       
       
        
    }
    
    @IBAction func restart(_ sender: Any) {
        
        ((view as! SKView).scene as! GameScene).score=[0,0]
        ((view as! SKView).scene as! GameScene).scorelable.text = "Win 0 : loss 0"
        ((view as! SKView).scene as! GameScene).check()
        ((view as! SKView).scene as! GameScene).reapplyForce()
        ((view as! SKView).scene as! GameScene).indexi=0
        
        
        
    }
    
    
    
    @IBOutlet weak var pauseButton: UIButton!
    
    
    @IBAction func pause(_ sender: Any) {
        
        if((view as! SKView).isPaused == true){
            
            (view as! SKView).isPaused = false
            pauseButton.setImage(#imageLiteral(resourceName: "icons8-Pause-100"), for: .normal)
            pauseButton.contentMode = .scaleAspectFit
        }else{
            (view as! SKView).isPaused = true
            pauseButton.setImage(#imageLiteral(resourceName: "icons8-Play-100"), for: .normal)
            pauseButton.contentMode = .scaleAspectFit
        }
        
    }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true) }
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
