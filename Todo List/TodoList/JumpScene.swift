//
//  JumpScene.swift
//  TodoList
//
//  Created by Shaun Macdonald on 01/01/2018.
//  Copyright © 2018 Shaun Macdonald. All rights reserved.
//
import SpriteKit
import AVFoundation

class JumpScene: SKScene {
    
    // define sprite node and arrays
    var Tamu = SKSpriteNode()
    var TextureAtlas = SKTextureAtlas()
    var TextureArray = [SKTexture]()
    
    override func didMove(to view: SKView) {
        
        // load sound file
        let jumpSound = SKAction.playSoundFileNamed("Sounds/jumpTone.wav", waitForCompletion: false)
        
        // load sprite frames
        TextureAtlas = SKTextureAtlas(named: "TamuSprites")
        
        // place and define node to host sprites
        let Bg = SKSpriteNode(imageNamed: "background")
        Bg.size = CGSize(width: frame.width, height: frame.height)
        Bg.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(Bg)
        
        // add all sprite frames to array
        for i in 0...6{
            let Name = "tamuJump_\(i).png"
            TextureArray.append(SKTexture(imageNamed: Name))
        }
        Tamu = SKSpriteNode(imageNamed: TextureAtlas.textureNames[0] as String)
        Tamu.size = CGSize(width: frame.width/1.5, height: frame.height/2.7)
        Tamu.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(Tamu)
        
        // play animation sound and loop the frames in the texture array
        run(jumpSound)
        Tamu.run(SKAction.repeatForever(SKAction.animate(with: TextureArray, timePerFrame: 0.1)))
        
    }
}

