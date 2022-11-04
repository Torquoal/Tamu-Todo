//
//  PetScene.swift
//  TodoList
//
//  Created by Shaun Macdonald on 17/01/2018.
//  Copyright © 2018 Shaun Macdonald. All rights reserved.
//
//  See JumpScene for comment guide on the implementation of this and other SkScene classes
//

import SpriteKit

class PetScene: SKScene {
    
     let petSound = SKAction.playSoundFileNamed("Sounds/petTone.wav", waitForCompletion: false)
    
    var Tamu = SKSpriteNode()
    
    var TextureAtlas = SKTextureAtlas()
    var TextureArray = [SKTexture]()
    
    override func didMove(to view: SKView) {
        
        TextureAtlas = SKTextureAtlas(named: "TamuSprites")
        
        let Bg = SKSpriteNode(imageNamed: "background")
        
        Bg.size = CGSize(width: frame.width, height: frame.height)
        
        Bg.position = CGPoint(x: frame.midX, y: frame.midY)
        
        self.addChild(Bg)
        
        for i in 0...35{
            
            let Name = "tamuPet_\(i).png"
            TextureArray.append(SKTexture(imageNamed: Name))
        }
        
        Tamu = SKSpriteNode(imageNamed: TextureAtlas.textureNames[0] as String)
        
        Tamu.size = CGSize(width: frame.width, height: frame.height/1.78)
        
        Tamu.position = CGPoint(x: frame.midX, y: frame.height/3.6)
        
        self.addChild(Tamu)
        
        run(petSound)
        
        Tamu.run(SKAction.repeatForever(SKAction.animate(with: TextureArray, timePerFrame: 0.1)))
        
    }
}





