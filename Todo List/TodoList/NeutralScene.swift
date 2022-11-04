//
//  NeutralScene.swift
//  TodoList
//
//  Created by Shaun Macdonald on 17/01/2018.
//  Copyright © 2018 Shaun Macdonald. All rights reserved.
//
//  See JumpScene for comment guide on the implementation of this and other SkScene classes
//

import SpriteKit

class NeutralScene: SKScene {
    
    var Tamu = SKSpriteNode()
    
    var TextureAtlas = SKTextureAtlas()
    var TextureArray = [SKTexture]()
    
    override func didMove(to view: SKView) {
        
        TextureAtlas = SKTextureAtlas(named: "TamuSprites")
        
        let Bg = SKSpriteNode(imageNamed: "background")
        
        Bg.size = CGSize(width: frame.width, height: frame.height)
        
        Bg.position = CGPoint(x: frame.midX, y: frame.midY)
        
        self.addChild(Bg)
        
        for i in 0...60{
            
            let Name = "spriteNeutral_\(i).png"
            TextureArray.append(SKTexture(imageNamed: Name))
        }
        
        Tamu = SKSpriteNode(imageNamed: TextureAtlas.textureNames[0] as String)
        
        Tamu.size = CGSize(width: frame.width/1.5, height: frame.height/2.7)
        
        Tamu.position = CGPoint(x: frame.midX, y: frame.midY)
        
        self.addChild(Tamu)
        
        Tamu.run(SKAction.repeatForever(SKAction.animate(with: TextureArray, timePerFrame: 0.2)))
        
    }
}






