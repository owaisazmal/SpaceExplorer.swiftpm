//
//  Spaceship.swift
//  SpaceExplorer
//
//  Created by Khan, Owais on 2/10/25.
//

import SpriteKit

class Spaceship: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "spaceship") // Load the spaceship image as a texture
        super.init(texture: texture, color: .clear, size: texture.size()) // Initialize the sprite node with the texture
        self.name = "spaceship"
        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size) // Assign a physics body to the sprite for collision detection
        self.physicsBody?.isDynamic = true // The physics body will move and interact with other physics bodies
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
