//
//  StorageContext.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 31/05/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import Foundation

struct Sorted {
    var key: String
    var ascending: Bool = true
}


protocol StorableContext {
    //    MARK: Save an object that is conformed to the 'Storable' protocol
    func save(object: Storable) throws

    //    MARK: update an object that is conformed to the 'Storable' protocol
    func update(block: @escaping () -> ()) throws
    
    //    MARK: delete an object that is conformed to the 'Storable' protocol
    func delete(object: Storable) throws
    
    //    MARK: Delete all objects that are conformed to the `Storable` protocol
    func deleteAll<T: Storable>(_ model: T.Type) throws

    //    MARK: fetch an object that is conformed to the 'Storable' protocol
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, completion: (([T]) -> ()))
}
