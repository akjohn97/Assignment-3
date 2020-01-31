//
//  CityManager.swift
//  City2City-J22
//
//  Created by mac on 1/28/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import CoreData

struct CityManager {
    
    
    //give us ability to save/modify Core Entities
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //place where all the core entities are stored
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "City2City_J22")
        container.loadPersistentStores { (storeDescrip, err) in
            if let error = err {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
    
    //MARK: Core - Getters
    static func load() -> [City] {
        
        let fetchRequest = NSFetchRequest<CoreCity>(entityName: "CoreCity")
        var cities = [City]()
        
        do {
            let coreCities = try context.fetch(fetchRequest)
            coreCities.forEach({
                if let city = City(core: $0) {
                    cities.append(city)
                }
            })
        } catch {
            print(error.localizedDescription)
        }
        
        return cities
    }
    
    
    //MARK: Core - Setters
    static func save(_ city: City) {
        let entity = NSEntityDescription.entity(forEntityName: "CoreCity", in: context)!
        let coreCity = CoreCity(entity: entity , insertInto: context)
        coreCity.name = city.name
        coreCity.lat = city.latitude
        coreCity.long = city.longitude
        coreCity.state = city.state
        coreCity.population = city.population
        
        saveContext() //if you don't save, it doesn't persist
    }
    

    //MARK: Core - Helper
    static func saveContext() {
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    //MARK: Get Cities
    
    static func getCities(completion: @escaping ([City]) -> Void ) {
        //convert path into url
        guard let path = Bundle.main.path(forResource: "cities", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        //use GCD to go to background thread
        DispatchQueue.global().async {
            var cities = [City]() //container
            do {
                //get data from url path
                let data = try Data(contentsOf: url)
                //serialize data into data strucuture
                let response = try JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
                for dict in response {
                    if let city = City(dict: dict) {
                        cities.append(city)
                    }
                }
              
                //pass all cities into completion
                completion(cities)
                
            } catch {
                print("Couldn't Get Cities: \(error.localizedDescription)")
            }
        }
    }
    
}
