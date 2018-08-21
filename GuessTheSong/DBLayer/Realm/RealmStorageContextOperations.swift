//
//  RealmStorageContextOperations.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 31/05/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation
import RealmSwift


//MARK: Extensions to write and update data in Realm

extension RealmStorageContext {
    func save(object: Storable) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        try self.safeWrite {
            realm.add(object as! Object)
        }
    }
    
    func saveAll(objects: [Storable]) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        try self.safeWrite {
            realm.add(objects as! [Object])
        }
    }
    
    func update(block: @escaping () -> Void) throws {
       try self.safeWrite {
            block()
        }
    }
    
    func updateLevel(object: Storable) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        let objects = List<Object>()
        if let level = object as? LevelData {
            level.status = StatusLevel.done.rawValue
            objects.append(level)
            let predicate = NSPredicate(format: "id = %@", level.id + 1 )
            if let nextLevel = fetchNext(LevelData.self, predicate: predicate) {
                nextLevel.status = StatusLevel.running.rawValue
                objects.append(nextLevel)
            }
            try self.safeWrite {
                realm.add(objects, update: true)
            }
        }
    }
}

//MARK: Extensions to delete of data in Realm

extension RealmStorageContext {
    func delete(object: Storable) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        try self.safeWrite {
            realm.delete(object as! Object)
        }
    }
    
    func deleteAll<T : Storable>(_ model: T.Type) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        
        try self.safeWrite {
            let objects = realm.objects(model as! Object.Type)
            
            for object in objects {
                realm.delete(object)
            }
        }
    }
    
    func reset() throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        try self.safeWrite {
            realm.deleteAll()
        }
    }
}

//MARK: Extensions to fetch of data in Realm

extension RealmStorageContext {
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: Sorted? = nil, completion: (([T]) -> ())) {
        var objects = self.realm?.objects(model as! Object.Type)
        
        if let predicate = predicate {
            objects = objects?.filter(predicate)
        }
        
        if let sorted = sorted {
            objects = objects?.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }
        
        var accumulate: [T] = [T]()
        for object in objects! {
            accumulate.append(object as! T)
        }
        
        completion(accumulate)
    }
    
    func fetchNext<T: Storable>(_ model: T.Type, predicate: NSPredicate? = nil) -> T? {
        var objects = self.realm?.objects(model as! Object.Type)
        if let predicate = predicate {
            objects = objects?.filter(predicate)
        }
        let result = objects?.first as! T
        
        return result
        
    }
}

