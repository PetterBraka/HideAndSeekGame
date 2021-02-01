//
//  GameScene.swift
//  Astroids1
//
//  Created by Petter vang Brakalsvålet on 28/01/2021.
//

import SpriteKit
import GameplayKit

enum Rotation {
    case None
    case Left
    case Right
}

class Spaceship: SKSpriteNode{
    let shipSpeed: CGFloat = 100.0
    let spriteScale: CGFloat = 0.25
    var shipRotation = Rotation.None
    var moving = false
}

class Asteroid: SKSpriteNode {
    var velocity = CGVector(dx: 0, dy: 0)
    var rotationSpeed = 0.0
    var spriteScale: CGFloat = 0.2
    func setUp(location: CGPoint) {
        self.xScale = spriteScale
        self.yScale = spriteScale
        self.position = location
    }
}

class Bullet: SKSpriteNode{
    let bulletSpeed: CGFloat = 240.0
    var velocity = CGVector(dx: 0, dy: 0)
    var lifeSpan = 60
}

class GameScene: SKScene {
    let spaceship = Spaceship(imageNamed: "Spaceship")
    var asteroids: [Asteroid] = []
    var lastUpdateTime: CFTimeInterval = 0
    
    override func didMove(to view: SKView) {
        spaceship.xScale = spaceship.spriteScale
        spaceship.yScale = spaceship.spriteScale
        spaceship.position = CGPoint(
            x: self.frame.midX,
            y: self.frame.midY)
        spaceship.zRotation = 0 // Facing upwards
        self.addChild(spaceship)
        
        for _ in 1 ... 4 {
            let asteroid = Asteroid(imageNamed:"asteroid")
            let location = CGPoint(
                x: getRandomAwayFrom(self.frame.midX, self.frame.maxX),
                y: getRandomAwayFrom(self.frame.midY, self.frame.maxY))
            asteroid.setUp(location: location )
            asteroid.velocity = CGVector(
                dx: CGFloat.random(in: 0...200.0)-100.0,
                dy: CGFloat.random(in: 0...200.0)-100.0 )
            self.addChild(asteroid)
            let action = SKAction.rotate(byAngle:(
                                            CGFloat.random(in: 0...20.0)-10.0)/100, duration:0.03)
            asteroid.run(SKAction.repeatForever(action))
            asteroids.append(asteroid)
        }
    }
    
    override func didEvaluateActions() {
        shootAsteroids()
        if shipCollision() {
            let actionImpactSound = SKAction.playSoundFileNamed("poom.mp3",waitForCompletion: false)
            spaceship.run(actionImpactSound)
            spaceship.removeFromParent()
        }
    }
    
    func shipCollision( ) -> Bool {
        var result = false
        for asteroid in asteroids {
            if spaceship.frame.intersects( asteroid.frame.insetBy(dx: 30.0, dy: 30.0)) {
                result = true
            }
            
        }
        return result
    }
    
    func getRandomAwayFrom(_ midValue: CGFloat, _ maxValue: CGFloat) -> CGFloat {
        // Returns values that are at least 150 from the ship
        let awayValue: CGFloat = 150 // How far away it must be
        let furthest = maxValue - awayValue
        let randValue = CGFloat.random(in: -furthest...furthest)
        if randValue > 0.0 {
            return midValue + randValue + awayValue
        }
        return midValue + randValue - awayValue
    }
    
    func wrapPosition(_ position: CGPoint, ObjSize: CGSize) -> CGPoint {
        let minHeight = ObjSize.height / 3
        let minWidth = ObjSize.width / 3
        var newPosition = position
        if newPosition.x > self.frame.maxX - minWidth {
            newPosition.x = self.frame.minX + minWidth
        } else if newPosition.x < self.frame.minX + minWidth {
            newPosition.x = self.frame.maxX - minWidth
        }
        if newPosition.y > self.frame.maxY - minHeight {
            newPosition.y = self.frame.minY + minHeight
        } else if newPosition.y < self.frame.minY + minHeight {
            newPosition.y = self.frame.maxY - minHeight
        }
        return(newPosition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches {
            let location = touch.location(in: self)
            if location.x < -self.frame.maxX * 0.5 {
                //Touch on left quarter
                if location.y < 0   {
                    // Bottom half - fire bullets
                    let actionFireSound = SKAction.playSoundFileNamed("boosh.mp3",waitForCompletion: false)
                    let angle = spaceship.zRotation + CGFloat(Double.pi) / 2
                    let bullet = Bullet(imageNamed:"bullet")
                    bullet.name = "bullet"
                    bullet.xScale = 0.5
                    bullet.yScale = 0.5
                    bullet.position = spaceship.position
                    bullet.position.x = bullet.position.x + cos(angle)*45
                    bullet.position.y = bullet.position.y + sin(angle)*45
                    let finalPosition = CGPoint(x: bullet.position.x + cos(angle)
                                                    * bullet.bulletSpeed, y: bullet.position.y + sin(angle)
                                                        * bullet.bulletSpeed)
                    let actionMove = SKAction.move(to: finalPosition, duration: 1)
                    let actionDelete = SKAction.removeFromParent()
                    bullet.run(SKAction.sequence([actionFireSound, actionMove, actionDelete]))
                    self.addChild(bullet)
                } else {
                    // Top half - rotate clockwise
                    spaceship.shipRotation = .Right
                }
            } else if location.x > self.frame.maxX * 0.5 {
                // Touch on right quarter
                if location.y <  0 {
                    // Bottom Right - move ship
                    spaceship.moving = true
                } else {
                    // Top right - rotate anticlockwise
                    spaceship.shipRotation = .Left
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if location.y > 0 {
                spaceship.shipRotation = .None
            } else if location.x  >  0 {
                spaceship.moving = false
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        let dTime: CGFloat = CGFloat(max(1.0/30, currentTime - lastUpdateTime))
        lastUpdateTime = currentTime
        for asteroid in asteroids {
            asteroid.position.x = asteroid.position.x + asteroid.velocity.dx * dTime
            asteroid.position.y = asteroid.position.y + asteroid.velocity.dy * dTime
            asteroid.position = wrapPosition( asteroid.position,
                                              ObjSize:  asteroid.size )
        }
        if spaceship.moving {
            let angle = spaceship.zRotation + CGFloat(Double.pi) / 2
            let xDiff = cos(angle) * spaceship.shipSpeed * dTime
            let yDiff = sin(angle) * spaceship.shipSpeed * dTime
            spaceship.position.x = spaceship.position.x + xDiff
            spaceship.position.y = spaceship.position.y + yDiff
            spaceship.position = wrapPosition( spaceship.position,
                                               ObjSize: spaceship.size )
        }
        switch spaceship.shipRotation {
        case .Left:
            let action = SKAction.rotate(byAngle: CGFloat(-0.03), duration:0.03)
            spaceship.run(SKAction.repeat(action, count: 1))
        case .Right:
            let action = SKAction.rotate(byAngle: CGFloat(0.03),
                                         duration:0.03)
            spaceship.run(SKAction.repeat(action, count: 1))
        default:  break
        }
    }
    
    // Code for checking whether a bullet has hit an asteroid
    //
    //  Created by Chris Price on 23/11/2018.
    //  Copyright © 2018 Chris Price. All rights reserved.
    //
    
    func shootAsteroids( ) {
        // Loop through the bullets checking
        enumerateChildNodes(withName: "bullet") {node, _ in
            let bullet = node as! Bullet
            var deadAsteroids: [Asteroid] = []
            var newAsteroids: [Asteroid] = []
            for asteroid in self.asteroids {
                if bullet.frame.intersects(asteroid.frame.insetBy(dx: 30.0, dy: 30.0)) {
                    if asteroid.spriteScale == 0.2 { //big asteroid - split
                        asteroid.spriteScale = 0.12
                        asteroid.xScale = asteroid.spriteScale
                        asteroid.yScale = asteroid.spriteScale
                        let newAsteroid = Asteroid(imageNamed:"asteroid")
                        newAsteroid.setUp(location: asteroid.position)
                        newAsteroid.spriteScale = 0.12
                        newAsteroid.xScale = newAsteroid.spriteScale
                        newAsteroid.yScale = newAsteroid.spriteScale
                        asteroid.velocity = CGVector(dx: CGFloat.random(in: 0...300)-150, dy: CGFloat.random(in: 0...300)-150 )
                        newAsteroid.velocity = CGVector(dx: CGFloat.random(in: 0...300)-150, dy: CGFloat.random(in: 0...300)-150 )
                        let action = SKAction.rotate(byAngle: CGFloat(CGFloat.random(in: 0...10)/100), duration:0.03)
                        newAsteroid.run(SKAction.repeatForever(action))
                        newAsteroids.append(newAsteroid)
                        self.addChild(newAsteroid)
                    } else {
                        deadAsteroids.append(asteroid)
                        
                    }
                }
            }
            if deadAsteroids.count > 0 {
                var redoneAsteroids: [Asteroid] = []
                for asteroid in self.asteroids {
                    var keepThis = true
                    for deadAsteroid in deadAsteroids {
                        if deadAsteroid == asteroid {
                            keepThis = false
                            asteroid.removeFromParent()
                        }
                    }
                    if keepThis {
                        redoneAsteroids.append(asteroid)
                    }
                }
                self.asteroids = redoneAsteroids
            }
            
            if newAsteroids.count > 0 {
                self.asteroids = self.asteroids + newAsteroids
            }
        }
    }
    
    
}
