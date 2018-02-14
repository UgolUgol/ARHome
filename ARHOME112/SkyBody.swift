//
//  SkyBody.swift
//  ARHOME112
//
//  Created by Ugol Ugol on 12/02/2018.
//  Copyright © 2018 Ugol Ugol. All rights reserved.
//

import Foundation
import SceneKit

class SkyBody: SCNNode{
    var mass: Float!
    var speed: Float!
    var velocity: Float!
    var density: Float!
    var temperature: Float!
    var radius: CGFloat!
    
    var title: String!
    var geom: SCNGeometry!
    
    convenience init(position: SCNVector3, withRad radius: Float, withMass mass: Float,
                     withDensity density: Float, withTemp temperature: Float,
                     withName name: String){
        // set global sky body characters
        self.init()
        
        self.mass = mass
        self.radius = CGFloat(radius)
        self.density = density
        self.temperature =  temperature
        self.title = name
        
        // create geometry of sphere
        self.geom  = SCNSphere(radius: self.radius)
        
        // create planet node and set it position
        let node = SCNNode(geometry: self.geom)
        node.name = self.title
        node.position = position
        
        // push planet to root
        self.addChildNode(node)
    }
    
    func addMaterial(materialName material: String) {
        self.geom.firstMaterial?.diffuse.contents = UIImage(named: material)
    }
    
    func addOrbit(){
        
    }
    
    
    
}
