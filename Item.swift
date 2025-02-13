//
//  Item.swift
//  SpaceExplorer
//
//  Created by Khan, Owais on 2/10/25.
//
import SpriteKit

class Item: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "item")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        self.physicsBody?.isDynamic = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
