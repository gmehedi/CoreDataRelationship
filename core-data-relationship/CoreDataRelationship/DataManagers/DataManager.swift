//
//  DataManager.swift
//  CoreDataRelationship
//
//  Created by Megi Sila on 2.5.22.
//  Copyright © 2022 Megi Sila. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    
    static let shared = DataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataRelationship")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func singer(name: String) -> Singer {
        let singer = Singer(context: persistentContainer.viewContext)
        singer.name = name
        return singer
    }
    
    func song(title: String, releaseDate: String, singer: Singer) -> Song {
        let song = Song(context: persistentContainer.viewContext)
        song.title = title
        song.releaseDate = releaseDate
        singer.addToSongs(song)
        return song
    }
    
    func singers() -> [Singer] {
        let request: NSFetchRequest<Singer> = Singer.fetchRequest()
        var fetchedSingers: [Singer] = []
        
        do {
            fetchedSingers = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching singers \(error)")
        }
        return fetchedSingers
    }
    
    func songs(singer: Singer) -> [Song] {
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        request.predicate = NSPredicate(format: "singer = %@", singer)
        request.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
        var fetchedSongs: [Song] = []
        
        do {
            fetchedSongs = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching songs \(error)")
        }
        return fetchedSongs
    }
    
    // MARK: - Core Data Saving support
    func save () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("❗️Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteSong(song: Song) {
        let context = persistentContainer.viewContext
        context.delete(song)
        save()
    }
    
    func deleteSinger(singer: Singer) {
        let context = persistentContainer.viewContext
        context.delete(singer)
        save()
    }
}
