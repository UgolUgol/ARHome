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
    
    
    var dt: Float! = 12 * 3600               // adding time in seconds
    
    var T: Float!                       // orbital period
    var n: Float!                       // middle angle speed of virtual body
    var M: Float!                       // middle anomaly
    var E: Float!                       // eccentry anomaly
    var v: Float!                       // true anomaly
    
    var isTrajFinish: Bool!                 // is a trajectory ellipse is finished to draw
    var wayPointsLimit: Int!                // showing count of trajectory points on orbit
    var pointsCounter: Int!                 // show number of rendering way points
    
    
    convenience init(majorAxis a: Float, eccentricity e: Float,
                     sunPosition pos: SCNVector3, gravity g: Float){
        self.init()
        self.a = a
        self.e = e
        self.b = sqrt(1-self.e * self.e) * self.a
        self.c = sqrt(self.a * self.a - self.b * self.b)
        self.p = powf(self.b, 2) / self.c
        self.perigelion = self.a - self.c
        
        self.T = findPlanetPeriod(g: g)
        self.n = 2 * Float.pi / self.T
        self.E = 0
        self.v = 0
        
        self.wayPointsLimit = lroundf(self.T / self.dt * 12)
        self.pointsCounter = 0
        
        // init trajectory
        initTrajectory()
    }
    
    // calculate T
    // considering that T % dt = 0
    func findPlanetPeriod(g: Float) -> Float{
        // find period with standart formula
        let per = 2 * Float.pi * sqrt(powf(self.a, 3) / g)
        
        // find closest number for per/dt
        let decPer = Float(lroundf(per / self.dt))
        
        // return decimalPeriod
        return decPer * self.dt
    }
    
    
    func r()->Float{
        return self.a * (1 - powf(self.e, 2)) / (1 + self.e * cosf(self.v))
    }
    
    func x()->Float{
        return r() * cos(self.v)
    }
    
    func z()->Float{
        return r() * sin(self.v)
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
