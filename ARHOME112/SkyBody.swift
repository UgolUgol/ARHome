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
    var radius: Float!
    var orbit: Orbit!
    var T: Float! // orbital period
    var g: Float! // gravity parameter
    var n: Float! // middle angle speed of virtual body
    var M: Float! // middle anomaly
    var E: Float! // eccentry anomaly
    var time: Float! = 0.0 // start time in perigelion
    
    var title: String!
    var geom: SCNGeometry!
    
    convenience init(position: SCNVector3, withRad radius: Float,
                     onDispRad drad: Float, withDensity density: Float,
                     withOrbit orbit: Orbit, withName name: String,
                     gravity g: Float){
        
        // set global sky body characters
        self.init()
        self.radius = radius
        self.density = density
        self.mass = 4/3 * Float.pi * powf(self.radius, 3) * self.density
        self.temperature =  0.0
        self.title = name
        self.orbit = orbit
        self.g = g
        self.T = 2 * Float.pi * sqrt(powf(self.orbit.a, 3) / g)
        self.n = 2 * Float.pi / self.T
        
        
        // create geometry of sphere
        self.geom  = SCNSphere(radius: CGFloat(drad))
        
        // create planet node and set it position
        let node = SCNNode(geometry: self.geom)
        node.name = self.title
        
        // set position to skybody in aphelion
        node.position = position
        
        // push planet to root
        self.addChildNode(node)
    }
    
    func addMaterial(materialName material: String) {
        self.geom.firstMaterial?.diffuse.contents = UIImage(named: material)
    }
    
    
    func rotationStep(position: SCNVector3, scale: Float!){
        
        // rotation time moment
        self.time = (self.time + 3600) <= self.T ? self.time + 3600 : 0.0
        
        // find new position in XZ plane
        var newPosition = SCNVector3()
        self.M = self.n * self.time
        self.E = solveKeplerEquation()
        newPosition.x = self.orbit.x(angle: E) / scale
        newPosition.y = position.y
        newPosition.z = self.orbit.z(angle: E) / scale
        print("\(self.E) \t \(newPosition) \t \(self.time)")
        
        // her one tick of rotation
        let moveAction = SCNAction.move(to: newPosition, duration: 1)
        self.runAction(moveAction)
    }
    
    
    // we should solve eq E - e*sin(E) = M
    func solveKeplerEquation() -> Float
    {
        // here we will use method of static point x = f(x)
        var En = Float(0.0)
        var E = Float(0.0)
        let eps = Float(1e-5)
        repeat{
            En = E
            E = self.orbit.e * sinf(En) + self.M
        }
        while(fabs(E - En) > eps)
        return E
    }
    
    
    
}
