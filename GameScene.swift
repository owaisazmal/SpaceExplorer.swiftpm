//
//  GameScene.swift
//  SpaceExplorer
//
//  Created by Khan, Owais on 2/10/25.
//

import SpriteKit

@MainActor // Make the entire GameScene class MainActor-isolated
class GameScene: SKScene, SKPhysicsContactDelegate {

    let spaceship = Spaceship()
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")

    override func didMove(to view: SKView) {
        backgroundColor = .black
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        spaceship.position = CGPoint(x: size.width / 2, y: size.height / 4)
        addChild(spaceship)

        spaceship.physicsBody?.categoryBitMask = PhysicsCategory.spaceship
        spaceship.physicsBody?.contactTestBitMask = PhysicsCategory.obstacle | PhysicsCategory.item
        spaceship.physicsBody?.collisionBitMask = PhysicsCategory.none
        spaceship.physicsBody?.linearDamping = 0.5

        scoreLabel.text = "Score: \(score)"
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.9)
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = .white
        addChild(scoreLabel)

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task {
                await self.addObstacle()
                await self.addItem()
            }
        }
    }

    func addObstacle() { // No @MainActor here
        let obstacle = Obstacle()
        let randomX = CGFloat.random(in: obstacle.size.width/2...size.width - obstacle.size.width/2)
        obstacle.position = CGPoint(x: randomX, y: size.height + obstacle.size.height/2)
        addChild(obstacle)

        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.spaceship
        obstacle.physicsBody?.collisionBitMask = PhysicsCategory.none
        obstacle.physicsBody?.velocity = CGVector(dx: 0, dy: -200)
    }

    func addItem() { // No @MainActor here
        let item = Item()
        let randomX = CGFloat.random(in: item.size.width/2...size.width - item.size.width/2)
        item.position = CGPoint(x: randomX, y: size.height + item.size.height/2)
        addChild(item)

        item.physicsBody?.categoryBitMask = PhysicsCategory.item
        item.physicsBody?.contactTestBitMask = PhysicsCategory.spaceship
        item.physicsBody?.collisionBitMask = PhysicsCategory.none
        item.physicsBody?.velocity = CGVector(dx: 0, dy: -200)
    }


    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        spaceship.position.x = location.x
    }

//    func didBegin(_ contact: SKPhysicsContact) { // No @MainActor here
//        let bodyA = contact.bodyA
//        let bodyB = contact.bodyB
//
//        if (bodyA.categoryBitMask == PhysicsCategory.spaceship && bodyB.categoryBitMask == PhysicsCategory.obstacle) ||
//           (bodyB.categoryBitMask == PhysicsCategory.spaceship && bodyA.categoryBitMask == PhysicsCategory.obstacle) {
//            print("Game Over!")
//            // Implement game over logic here
//        }
//
//        if (bodyA.categoryBitMask == PhysicsCategory.spaceship && bodyB.categoryBitMask == PhysicsCategory.item) ||
//           (bodyB.categoryBitMask == PhysicsCategory.spaceship && bodyA.categoryBitMask == PhysicsCategory.item) {
//            print("Got an item!")
//            if let itemNode = bodyA.node as? Item {
//                itemNode.removeFromParent()
//            } else if let itemNode = bodyB.node as? Item {
//                itemNode.removeFromParent()
//            }
//            score += 1
//            scoreLabel.text = "Score: \(score)"
//        }
//    }
}

struct PhysicsCategory {
    static let none: UInt32             = 0
    static let all: UInt32              = UInt32.max
    static let spaceship: UInt32        = 0b1       // 1
    static let obstacle: UInt32         = 0b10      // 2
    static let item: UInt32           = 0b100     // 4
}
