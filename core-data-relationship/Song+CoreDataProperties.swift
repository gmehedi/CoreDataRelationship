//
//  Song+CoreDataProperties.swift
//  CoreDataRelationship
//
//  Created by Megi Sila on 2.5.22.
//  Copyright © 2022 Megi Sila. All rights reserved.
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var singer: Singer?
}

extension Song : Identifiable {

}
