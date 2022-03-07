//
//  DataEntry.swift
//  Saving
//
//  Created by Richard Ristic on 2021-06-29.
//

struct DataEntry {
    let value: Double
    let upperBound: Double
    let lowerBound: Double
    let date: String
}

extension DataEntry: Comparable {
    static func < (lhs: DataEntry, rhs: DataEntry) -> Bool {
        return lhs.value < rhs.value
    }

    static func == (lhs: DataEntry, rhs: DataEntry) -> Bool {
        return lhs.value == rhs.value
    }
}
