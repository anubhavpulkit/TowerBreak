//
//  TowerMaterial.swift
//  TowerBreak
//
//  Created by Pully on 05/06/21.
//

import SceneKit

public enum JTexture: String {
    case wood
    case floor
    
    static var longSides = [UIImage?]()
    static var shortSides = [UIImage?]()
    static var leftSides = [UIImage?]()
    static var floorTexture: UIImage?
    
    static func loadTextures() {
        JTexture.longSides = (1...16).map { return UIImage(named: "block-long-\($0).jpeg") }
        JTexture.leftSides = (1...16).map { return UIImage(named: "block-side-\($0).PNG") }
        JTexture.shortSides = [UIImage(named: "block-short-1.PNG")]
        JTexture.floorTexture = UIImage(named: "floor1.jpg")
    }
}

extension Collection {
    
    func randomNumber<T : SignedInteger>(inRange range: ClosedRange<T> = 1...6) -> T {
        let length = Int64(range.upperBound - range.lowerBound + 1)
        let value = Int64(arc4random()) % length + Int64(range.lowerBound)
        return T(value)
    }
    
    func randomItem() -> Self.Iterator.Element {
        let count = distance(from: startIndex, to: endIndex)
        let roll = randomNumber(inRange: 0...count-1)
        return self[index(startIndex, offsetBy: roll)]
    }
}

class JMaterial {
    
    var materials = [SCNMaterial]()
    let type: JTexture
    
    init(type: JTexture) {
        self.type = type
        
        if type == .floor {
            let material = SCNMaterial()

            material.diffuse.wrapS = .repeat
            material.diffuse.wrapT = .repeat
            
            material.lightingModel = .physicallyBased
            material.diffuse.contents = JTexture.floorTexture
            
            materials.append(material)
        } else {
            // front, right, back, left, top, bottom
            // small, long, small, long, long, long
            let short = JTexture.shortSides
            let long = JTexture.longSides
            let left = JTexture.leftSides
            for image in [short.randomItem(), left.randomItem(), short.randomItem(), left.randomItem(), long.randomItem(), long.randomItem()] {
                
                let material = SCNMaterial()
                
                material.lightingModel = .physicallyBased
                material.diffuse.contents = image
            
                materials.append(material)
            }
            
        }
    }
    
    func apply(to geometry: SCNGeometry) {
        if type == .floor {
            geometry.firstMaterial = materials.first!
            return
        }
        geometry.materials = materials
    }
    
}
