
//  HelpScene.swift
//  TodoList
//
//  Created by Shaun Macdonald on 17/01/2018.
//  Copyright © 2018 Shaun Macdonald. All rights reserved.
//

import SpriteKit

class helpScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        // display static help image in the centre of the frame
        let Bg = SKSpriteNode(imageNamed: "help")
        Bg.size = CGSize(width: frame.width, height: frame.height)
        Bg.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(Bg)
        
    }
}






