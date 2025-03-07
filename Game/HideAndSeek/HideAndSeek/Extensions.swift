//
//  extensions.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 26/02/2021.
//

import SpriteKit

enum ChallangeRating: String {
    case easy = "Easy"
    case normal = "Normal"
    case hard = "Hard"
}

enum ColliderType: UInt32 {
    case Player = 1
    case HidingPlace = 2
}

extension SKSpriteNode {
    
    /**
     Will change the size of the SKSpriteNode, but keep the aspec ratio of the texture set.
     
     - parameter size: - The CGSize wanted for the SKSpriteNode.
     
     # Notes: #
     1. The SKSpriteNode needs an texture to resize the node.
     
     # Example #
     ```
     let sprite = SKSpriteNode(imageNamed: "image name")
     sprite.aspectFillToSize(size: CGSize)
     ```
     */
    func aspectFillToSize(size: CGSize) {
        guard let texture = self.texture else {
            print("Can't set aspect ratio of node. No textures found for node")
            return
        }
        self.size = texture.size()
        let heightRatio = size.height / texture.size().height
        let widthRatio = size.width / texture.size().width
        
        let scaleingRatio = widthRatio > heightRatio ? widthRatio : heightRatio
        
        setScale(scaleingRatio)
    }
}

/**
* Copyright (c) 2017 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
* distribute, sublicense, create a derivative work, and/or sell copies of the
* Software in any work that is designed, intended, or marketed for pedagogical or
* instructional purposes related to programming, coding, application development,
* or information technology.  Permission for such use, copying, modification,
* merger, publication, distribution, sublicensing, creation of derivative works,
* or sale is expressly withheld.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Foundation
import CoreGraphics

func + (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (left: inout CGPoint, right: CGPoint) {
  left = left + right
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func -= (left: inout CGPoint, right: CGPoint) {
  left = left - right
}

func * (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

func *= (left: inout CGPoint, right: CGPoint) {
  left = left * right
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func *= (point: inout CGPoint, scalar: CGFloat) {
  point = point * scalar
}

func / (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

func /= ( left: inout CGPoint, right: CGPoint) {
  left = left / right
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

func /= (point: inout CGPoint, scalar: CGFloat) {
  point = point / scalar
}

extension CGPoint {
  
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
  
  var angle: CGFloat {
    return atan2(y, x)
  }
}

let π = CGFloat.pi

func shortestAngleBetween(angle1: CGFloat,
                          angle2: CGFloat) -> CGFloat {
  let twoπ = π * 2.0
  var angle = (angle2 - angle1)
    .truncatingRemainder(dividingBy: twoπ)
  if angle >= π {
    angle = angle - twoπ
  }
  if angle <= -π {
    angle = angle + twoπ
  }
  return angle
}

extension CGFloat {
  func sign() -> CGFloat {
    return self >= 0.0 ? 1.0 : -1.0
  }
}

extension CGFloat {
  static func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(UInt32.max))
  }

  static func random(min: CGFloat, max: CGFloat) -> CGFloat {
    assert(min < max)
    return CGFloat.random() * (max - min) + min
  }
}

