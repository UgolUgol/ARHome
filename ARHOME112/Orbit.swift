//
//  Orbit.swift
//  ARHOME112
//
//  Created by Ugol Ugol on 14/02/2018.
//  Copyright © 2018 Ugol Ugol. All rights reserved.
//

import Foundation

class Orbit{
    var a: Float    // major axis
    var b: Float    // small axis
    var c: Float    // linear eccentricity
    var e: Float    // eccentricity
    var p: Float    // focal param
    var perigelion: Float // distance from sun position to perigelion
    
    init(majorAxis a: Float, eccentricity e: Float){
        self.a = a
        self.e = e
        self.p = (1-self.e * self.e) * self.a
        self.b = sqrt(1-self.e * self.e) * self.a
        self.c = sqrt(self.a * self.a - self.b * self.b)
        self.perigelion = self.a - self.c
    }
    
    func r(angle E: Float)->Float{
        return self.a * (1 - self.e*cos(E))
    }
    
    func x(angle E: Float)->Float{
        return r(angle: E) * sin(E)
    }
    
    func z(angle E: Float)->Float{
        return r(angle: E) * cos(E)
    }
}
