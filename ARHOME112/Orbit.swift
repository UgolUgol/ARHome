//
//  Orbit.swift
//  ARHOME112
//
//  Created by Ugol Ugol on 14/02/2018.
//  Copyright © 2018 Ugol Ugol. All rights reserved.
//

import Foundation
import SceneKit

class Orbit: SCNNode{
    var a: Float!                           // major axis
    var b: Float!                           // small axis
    var c: Float!                           // linear eccentricity
    var e: Float!                           // eccentricity
    var p: Float!                           // focal param
    var perigelion: Float!                  // distance from sun position to perigelion
    
    
    var isTrajFinish: Bool!                       // is a trajectory ellipse is finished to draw
    
    convenience init(majorAxis a: Float, eccentricity e: Float, sunPosition pos: SCNVector3){
        self.init()
        self.a = a
        self.e = e
        self.b = sqrt(1-self.e * self.e) * self.a
        self.c = sqrt(self.a * self.a - self.b * self.b)
        self.p = powf(self.b, 2) / self.c
        self.perigelion = self.a - self.c
        
        // init trajectory
        initTrajectory()
    }
    
    func r(angle v: Float)->Float{
        return self.a * (1 - powf(self.e, 2)) / (1 + self.e * cosf(v))
    }
    
    func x(angle v: Float)->Float{
        return r(angle: v) * cos(v)
    }
    
    func z(angle v: Float)->Float{
        return r(angle: v) * sin(v)
    }
    
    // create orbit trajectory node
    func initTrajectory(){
        
        // orbit trajectory is node with position in sun center
        // and it has children - spheres showing the trajectory of planet
        self.isTrajFinish = false
        self.position = SCNVector3(0, 0, 0)
    }
    
    func updateTrajectory(planetPosition pos: SCNVector3){
        
        // create new orbit trajectory point
        let point = createTrajectoryPoint(position: pos)
        
        // add point to orbit
        self.addChildNode(point)
    }
    
    func createTrajectoryPoint(position: SCNVector3) -> SCNNode {
        
        // create point geometry
        let geom = SCNSphere(radius: 0.0008)
        geom.firstMaterial?.diffuse.contents = UIColor.white
        
        // create point node
        let node = SCNNode(geometry: geom)
        node.position = position
        return node
    }
}
