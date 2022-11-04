//
//  WorryScene.swift
//  TodoList
//
//  Created by Shaun Macdonald on 12/01/2018.
//  Copyright © 2018 Shaun Macdonald. All rights reserved.
//
//  See JumpScene for comment guide on the implementation of this and other SkScene classes
//

import SpriteKit

class WorryScene: SKScene {
    
    
    
    var Tamu = SKSpriteNode()
    
    var TextureAtlas = SKTextureAtlas()
    var WorryArray = [SKTexture]()
    var NormalArray = [SKTexture]()
    
    override func didMove(to view: SKView) {
        
        let worrySound = SKAction.playSoundFileNamed("Sounds/worryTone.wav", waitForCompletion: false)
        
        TextureAtlas = SKTextureAtlas(named: "TamuSprites")
        
        let Bg = SKSpriteNode(imageNamed: "background")
        
        Bg.size = CGSize(width: frame.width, height: frame.height)
        
        Bg.position = CGPoint(x: frame.midX, y: frame.midY)
        
        self.addChild(Bg)
        
        for i in 0...37{
            
            let Name = "tamuSad_\(i).png"
            WorryArray.append(SKTexture(imageNamed: Name))
        }
        
        Tamu = SKSpriteNode(imageNamed: TextureAtlas.textureNames[0] as String)
        
        Tamu.size = CGSize(width: frame.width/1.5, height: frame.height/2.7)
        
        Tamu.position = CGPoint(x: frame.midX, y: frame.midY)
        
        self.addChild(Tamu)
        
        run(worrySound)
        
        Tamu.run(SKAction.repeatForever(SKAction.animate(with: WorryArray, timePerFrame: 0.1)))
        
    }
}




