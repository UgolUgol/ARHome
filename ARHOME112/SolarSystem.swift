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
    var G: Float! = 6.67 * powf(10, -11) // Gravity constant
    var au: Float! = 6.6846e-12  // how much astronimical units in 1 meter
    
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
        self.sunRadius = 0.3
        self.sun = SkyBody(position: posVec, withRad: self.sunRadius,
                           withMass: 1.989E30, withDensity: 12,
                           withTemp: 15, withOrbit: Orbit(majorAxis: 0, eccentricity: 0),
                           withName: "Sun", gravity: self.G)
        self.sun.addMaterial(materialName: "Sun_diffuse")
    }
    
    
    // create planets of solar system
    func createPlanets(posVec: SCNVector3){
        
        // set planets default parameters
        // [name, orbitRadius, selfRadius, mass, density, temperature, materialPath]
        let defaultPlanetsParameters = [
            ["name": "Mercury", "selfRadius": Float(0.05),
             "mass": Float(3.33e23), "density": Float(5.43),
             "majorAxis": Float(0.387), "eccentricity": Float(0.206),
             "temperature": Float(20), "materialPath": "mercury_diffuse_2k"]
        ]
        
        // create planets of scene adding it to planets array
        self.planets = [String:SkyBody]()
        for planet in defaultPlanetsParameters{
            
            // get planet parameters
            let planetName = planet["name"] as! String
            let planetRad = planet["selfRadius"] as! Float
            let planetMass = planet["mass"] as! Float
            let planetDensity = planet["density"] as! Float
            let planetTemp = planet["temperature"] as! Float
            let material = planet["materialPath"] as! String
            let a = planet["majorAxis"] as! Float
            let e = planet["eccentricity"] as! Float
            
            // create planet orbit and position in sky
            let planetOrbit = Orbit(majorAxis: a, eccentricity: e)
            let planetPosition = SCNVector3(posVec.x + self.sunRadius + planetOrbit.perigelion,
                                            posVec.y, posVec.z)
            
            // create planet
            // g = G * au * sunMass - grav parameter in astronomic units (g = GM)
            self.planets[planetName] = SkyBody(position: planetPosition, withRad: planetRad,
                                               withMass: planetMass, withDensity: planetDensity,
                                               withTemp: planetTemp, withOrbit: planetOrbit,
                                               withName: planetName, gravity: self.G * powf(au, 3) * self.sun.mass!)
            
            // set plane material
            self.planets[planetName]!.addMaterial(materialName: material)
            
            // add plane to solar system
            self.sun.addChildNode(self.planets[planetName]!)
        }
    }
    
    func makeRotationCicle(){
        
        // making one rotation step for each planet
        for planet in planets{
            planet.value.rotationStep(position: planet.value.position)
        }
    }
    
}
