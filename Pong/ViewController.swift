//
//  ViewController.swift
//  Pong
//
//  Created by Matthew Hasler on 01/09/2014.
//  Copyright (c) 2014 Ganzogo. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
  
  var pongView:SKView = SKView()
  var pongScene:PongScene = PongScene()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pongView.multipleTouchEnabled = false
    pongView.showsDrawCount = true
    pongView.showsNodeCount = true
    pongView.showsFPS = true
    pongView.backgroundColor = UIColor.greenColor()
    pongView.frame = self.view.bounds
    
    
    view.addSubview(pongView)

    pongScene.size = self.view.bounds.size
    pongScene.createSceneContents()
    pongView.presentScene(pongScene)
    
    
//    let button = UIButton(frame: CGRectMake(10, 60, 100, 50))
//    button.backgroundColor = UIColor.redColor()
//    self.view.addSubview(button)
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
    var touch:UITouch = touches.anyObject() as UITouch
    var point = touch.locationInView(self.view)
    
    if (point.x < self.view.bounds.size.width / 2.0) {
      // left
      pongScene.moveLeft()
    } else {
      // right
      pongScene.moveRight()
    }
  }


}

class PongScene : SKScene, SKPhysicsContactDelegate {
  
  var paddle:SKSpriteNode = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 100, height: 10))
  var ball:SKSpriteNode = SKSpriteNode(color: UIColor.yellowColor(), size: CGSize(width: 10, height: 10))
  var floor:SKSpriteNode?
  
  let collisionCategory:UInt32 = 1
  
  func createSceneContents() {
    paddle.position = CGPoint(x: self.size.width / 2.0, y: 100)
    paddle.physicsBody = SKPhysicsBody(rectangleOfSize: paddle.size)
    paddle.physicsBody.affectedByGravity = false
    paddle.physicsBody.dynamic = false
    paddle.physicsBody.usesPreciseCollisionDetection = true
    self.addChild(paddle)
    
    ball.position = CGPoint(x: self.size.width / 2.0, y: self.size.height - 50.0)
    ball.physicsBody = SKPhysicsBody(rectangleOfSize: ball.size)
    ball.physicsBody.restitution = 1.0
    ball.physicsBody.linearDamping = 0.0
    ball.physicsBody.angularVelocity = 1.37
    ball.physicsBody.usesPreciseCollisionDetection = true
    ball.physicsBody.contactTestBitMask = collisionCategory
    self.addChild(ball)
    
    self.addWall(CGSize(width: 10, height: self.size.height), position: CGPoint(x: 5, y: self.size.height / 2.0))
    self.addWall(CGSize(width: 10, height: self.size.height), position: CGPoint(x: self.size.width - 5, y: self.size.height / 2.0))
    self.addWall(CGSize(width: self.size.width, height: 10), position: CGPoint(x: self.size.width / 2.0, y: self.size.height - 5))
    floor = self.addWall(CGSize(width: self.size.width, height: 10), position: CGPoint(x: self.size.width / 2.0, y: 5))
    
    self.physicsWorld.contactDelegate = self
  }
  
  func moveLeft() {
    paddle.position.x -= 10
  }
  
  func moveRight() {
    paddle.position.x += 10
  }
  
  func addWall(size: CGSize, position: CGPoint) -> SKSpriteNode {
    let wall = SKSpriteNode(color: UIColor.greenColor(), size: CGSizeZero)
    wall.size = size
    wall.position = position
    wall.physicsBody = SKPhysicsBody(rectangleOfSize: wall.size)
    wall.physicsBody.affectedByGravity = false
    wall.physicsBody.dynamic = false
    wall.physicsBody.usesPreciseCollisionDetection = true
    self.addChild(wall)
    return wall
  }
  
  func didBeginContact(contact: SKPhysicsContact!) {
    if (contact.bodyA == self.paddle.physicsBody || contact.bodyB == self.paddle.physicsBody) {
       NSLog("paddle");
    }
    
    if (contact.bodyA == self.floor?.physicsBody || contact.bodyB == self.floor?.physicsBody) {
      NSLog("floor");
    }
    
  }
}