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
    var angle_speed: Float!
    var velocity: Float!
    
    var density: Float!
    var temperature: Float!
    var radius: Float!                  // real skybody radius, use for phys calculating
    var drad: Float!                    // skybody radius considering the scale. it uses for displaing
    
    var orbit: Orbit!
    var T: Float!                       // orbital period
    var g: Float!                       // gravity parameter
    var n: Float!                       // middle angle speed of virtual body
    var M: Float!                       // middle anomaly
    var E: Float!                       // eccentry anomaly
    var v: Float!                       // true anomaly
    var time: Float! = 0.0              // start time in perigelion
    var dt: Float! = 12*3600               // adding time in seconds
    
    var title: String!
    var geom: SCNGeometry!
    
    convenience init(position: SCNVector3, withRad radius: Float,
                     onDispRad drad: Float, withDensity density: Float,
                     withOrbit orbit: Orbit, withName name: String,
                     gravity g: Float){
        
        // set global sky body characters
        self.init()
        self.radius = radius
        self.drad = drad
        self.density = density
        self.mass = 4/3 * Float.pi * powf(self.radius, 3) * self.density
        self.temperature =  0.0
        self.title = name
        self.orbit = orbit
        self.g = g
        self.T = 2 * Float.pi * sqrt(powf(self.orbit.a, 3) / g)
        self.n = 2 * Float.pi / self.T
        self.E = 0
        
        // create geometry of sphere
        self.geom  = SCNSphere(radius: CGFloat(self.drad))
        
        // create planet node and set it position
        self.geometry = self.geom
        self.name = self.title
        
        // set position to skybody in perigelion
        self.position = position
    }
    
    func addMaterial(materialName material: String) {
        self.geom.firstMaterial?.diffuse.contents = UIImage(named: material)
    }
    
    
    func rotationStep(position: SCNVector3, scale: Float!){
        
        // rotation time moment
        self.time = (self.time + self.dt) <= self.T ? self.time + self.dt : 0.0
        
        // find the angle E(t) solving kelper eq with Halleys method
        // after it find true anomaly v(E, t)
        var newPosition = SCNVector3()
        self.M = self.n * self.time
        self.E = methodHalleys()
        self.v = trueAnomaly()
            
        // set new position to move
        newPosition.x = self.orbit.x(angle: self.v) / scale
        newPosition.y = position.y
        newPosition.z = self.orbit.z(angle: self.v) / scale
        
        // speed calculation
        speedAtPoint(r: self.orbit.r(angle: self.v))
        
        // move to new position
        self.position = newPosition
    }
    
    
    func speedAtPoint(r: Float){
        self.speed = sqrt(self.g * (2 / r - 1 / self.orbit.a))
    }
    
    func trueAnomaly() -> Float{
        return 2 * atanf(sqrtf((1 + self.orbit.e)/(1 - self.orbit.e)) * tanf(self.E/2))
    }
    
    
    // we should solve eq E - e*sin(E) = M
    // here we will define three functions that's using in halleys method
    // F(E), F'(E), F''(E)
    func F(E: Float) -> Float{
        return E - self.M - self.orbit.e * sinf(E)
    }
    func dF(E: Float) -> Float{
        return 1 - self.orbit.e * cosf(E)
    }
    func ddF(E: Float) -> Float{
        return self.orbit.e * sinf(E)
    }
    
    func methodHalleys() -> Float{
        var En = Float(0.0)
        var E = self.M!
        let eps = Float(1e-5)
        repeat{
            En = E
            E = En - (2 * F(E: En) * dF(E: En)) /
                (2 * powf(dF(E: En), 2) - F(E: En)*ddF(E: En))
        }
        while(fabs(E - En) > eps)
        return E
    }
    
    
    
}
