//
//  Singer+CoreDataProperties.swift
//  CoreDataRelationship
//
//  Created by Megi Sila on 2.5.22.
//  Copyright © 2022 Megi Sila. All rights reserved.
//

import Foundation
import CoreData


extension Singer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Singer> {
        return NSFetchRequest<Singer>(entityName: "Singer")
    }

    @NSManaged public var name: String?
    @NSManaged public var songs: NSSet?
}

// MARK: Generated accessors for songs
extension Singer {

    @objc(addSongsObject:)
    @NSManaged public func addToSongs(_ value: Song)

    @objc(removeSongsObject:)
    @NSManaged public func removeFromSongs(_ value: Song)

    @objc(addSongs:)
    @NSManaged public func addToSongs(_ values: NSSet)

    @objc(removeSongs:)
    @NSManaged public func removeFromSongs(_ values: NSSet)

}

extension Singer : Identifiable {

}
