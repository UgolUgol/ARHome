//
//  Orbit.swift
//  ARHOME112
//
//  Created by Ugol Ugol on 14/02/2018.
//  Copyright © 2018 Ugol Ugol. All rights reserved.
//

import Foundation
import SceneKit

class Orbit{
    var a: Float                // major axis
    var b: Float                // small axis
    var c: Float                // linear eccentricity
    var e: Float                // eccentricity
    var p: Float                // focal param
    var perigelion: Float       // distance from sun position to perigelion
    var show: Bool              // show orbit
    var trajectory: SCNNode!     // orbit trajectory
    
    
    init(majorAxis a: Float, eccentricity e: Float, sunPosition pos: SCNVector3){
        self.a = a
        self.e = e
        self.b = sqrt(1-self.e * self.e) * self.a
        self.c = sqrt(self.a * self.a - self.b * self.b)
        self.p = powf(self.b, 2) / self.c
        self.perigelion = self.a - self.c
        
        // show orbit trajectory
        self.show = true
        self.trajectory = SCNNode()
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
    // todo
}
