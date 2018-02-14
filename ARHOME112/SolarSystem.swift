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
    
    convenience init(sunPosition posVec: SCNVector3){
        self.init()
        
        
        // set planets default parameters
        // [name, orbitRadius, selfRadius, mass, density, temperature, materialPath]
        var defaultPlanetsParameters = [
            ["name": "Mercury", "orbitRadius":0, "selfRadius": Float(0.1),
             "mass": Float(3.28), "density": Float(5.43), "temperature": Float(20),
             "materialPath": "mercury_diffuse_2k"]
        ]
        
        for i in 0...defaultPlanetsParameters.count-1 {
            defaultPlanetsParameters[i]["orbitRadius"] = TiciusBode(planetNumber: i)
        }
        
        
        // create sun and it's material
        self.sunRadius = 0.5
        self.sun = SkyBody(position: posVec, withRad: self.sunRadius,
                           withMass: 200, withDensity: 12,
                           withTemp: 15, withName: "Sun")
        self.sun.addMaterial(materialName: "Sun_diffuse")
        self.planets = [String:SkyBody]()
        
        // create planets of scene
        for planet in defaultPlanetsParameters{
            
            // get planet parameters
            let planetName = planet["name"] as! String
            let planetOrbitRad = planet["orbitRadius"] as! Float
            let planetRad = planet["selfRadius"] as! Float
            let planetMass = planet["mass"] as! Float
            let planetDensity = planet["density"] as! Float
            let planetTemp = planet["temperature"] as! Float
            let material = planet["materialPath"] as! String
            let planetPos = SCNVector3(posVec.x-self.sunRadius - planetOrbitRad,
                                       posVec.y, posVec.z)
            
            // create plane
            self.planets[planetName] = SkyBody(position: planetPos, withRad: planetRad,
                                                withMass: planetMass, withDensity: planetDensity,
                                                withTemp: planetTemp, withName: planetName)
            
            // set plane material
            self.planets[planetName]!.addMaterial(materialName: material)
            
            // add plane to solar system
            self.sun.addChildNode(self.planets[planetName]!)
        }
        
    
        /*
        // create mercury as sun's child
        let mercPos = SCNVector3(posVec.x-0.4
            , posVec.y, posVec.z)
        self.mercury = SkyBody(position: mercPos, withRad: 0.1,
                           withMass: 200, withDensity: 12,
                           withTemp: 15, withName: "Mercury")
        self.mercury.addMaterial(materialName: "mercury_diffuse_2k")
        self.sun.addChildNode(self.mercury)*/
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
    
}
