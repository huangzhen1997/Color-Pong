//
//  MenuVC.swift
//  Color-Pong
//
//  Created by  huangzhen on 23/03/2017.
//  Copyright © 2017  huangzhen. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

enum GameType{
    case  easy
    case  med
    case  hard
    case  player2
}


class MenuVC: UIViewController{


    
    
    
    
    override func viewDidLoad() {
        
        p2.layer.cornerRadius = 10
        
        let skView = view as! SKView
        skView.presentScene(MainMenuScene(size:skView.bounds.size))
   
    
        
        
        
    }
    

    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    
    @IBAction func player2(_ sender: Any) {
        moveToGame(game: .player2)
    }
    
    @IBAction func easy(_ sender: Any) {
        moveToGame(game: .easy)
    }
    
    
    @IBAction func med(_ sender: Any) {
        moveToGame(game: .med)
    }
    
    
    @IBAction func hard(_ sender: Any) {
        moveToGame(game: .hard)
    }
    
    func moveToGame(game: GameType){
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as! GameViewController
        
        currentGameType = game
        
        //((gameVC.view as! SKView).scene as GameScene).
        gameVC.restart(self)
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    @IBOutlet weak var p2: UIButton!
   
}
