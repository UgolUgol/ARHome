//
//  SolarSystem.swift
//  ARHOME112
//
//  Created by Ugol Ugol on 13/02/2018.
//  Copyright © 2018 Ugol Ugol. All rights reserved.
//

import Foundation
import SceneKit

class SolarSystem: SCNScene{
    var sun: SkyBody!
    var sunRadius: Float!
    var planets: Dictionary<String, SkyBody>!
    var time: Float! = 0.0
    var G: Float! = 6.67 * powf(10, -11)    // Gravity constant
    var au: Float! = 6.6846e-12             // how much astronimical units in 1 meter
    var scale: Float! = 9e10
    
    convenience init(sunPosition posVec: SCNVector3){
        self.init()
        
        // create sun and it's material
        createSun(posVec: posVec)
        
        // create solar planets
        createPlanets(posVec: posVec)

        self.rootNode.addChildNode(self.sun)
    }
    
    
    // rule for planets orbit radius
    func TiciusBode(planetNumber k: Int)->Float{
        if k == 0 {
            return 0.4
        }
        else {
            let D = 3 * (pow(2, k-1))
            return Float(truncating: (D + 4) / 10 as NSNumber)
        }
    }
    
    
    // sun creation func
    func createSun(posVec: SCNVector3){
        self.sunRadius = Float(6.9551e8)
        self.sun = SkyBody(position: posVec, withRad: self.sunRadius, onDispRad: 0.2,
                           withDensity: 1409.0, withOrbit: Orbit(majorAxis: 0, eccentricity: 0),
                           withName: "Sun", gravity: self.G)
        self.sun.addMaterial(materialName: "Sun_diffuse")
    }
    
    
    // create planets of solar system
    func createPlanets(posVec: SCNVector3){
        
        // set planets default parameters
        // [name, orbitRadius, selfRadius, density, temperature, materialPath]
        let defaultPlanetsParameters = [
            ["name": "Mercury", "selfRadius": Float(2440e3), "density": Float(5427.0),
             "majorAxis": Float(57909227000), "eccentricity": Float(0.206),
             "materialPath": "mercury_diffuse_2k"]
        ]
        
        // create planets of scene adding it to planets array
        self.planets = [String:SkyBody]()
        for planet in defaultPlanetsParameters{
            
            // get planet parameters
            let planetName = planet["name"] as! String
            let planetRad = planet["selfRadius"] as! Float
            let planetDensity = planet["density"] as! Float
            let material = planet["materialPath"] as! String
            let a = planet["majorAxis"] as! Float
            let e = planet["eccentricity"] as! Float
            
            // create planet orbit and position in sky
            // z coordinate is caculating considering the scale
            let planetOrbit = Orbit(majorAxis: a, eccentricity: e)
            let planetPosition = SCNVector3(posVec.x,
                                            posVec.y,
                                            posVec.z + (planetOrbit.z(angle: 0)) / self.scale)
            
            // create planetr
            // g = G * au * sunMass - grav parameter in astronomic units (g = GM)
            self.planets[planetName] = SkyBody(position: planetPosition, withRad: planetRad, onDispRad: 0.05,
                                               withDensity: planetDensity, withOrbit: planetOrbit,
                                               withName: planetName, gravity: self.G * self.sun.mass!)
            
            // set plane material
            self.planets[planetName]!.addMaterial(materialName: material)
            
            // add plane to solar system
            self.sun.addChildNode(self.planets[planetName]!)
        }
    }
    
    
    // making one rotation step for each planet
    func makeRotationCicle(){
        for planet in planets{
           planet.value.rotationStep(position: planet.value.position, scale: self.scale)
        }
    }
    
}
