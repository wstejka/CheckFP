//
//  Enum+Extensions.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 31/05/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//


extension RawRepresentable where Self: Hashable {
    
    // Returns the number of elements in a RawRepresentable data structure
    static var elementsCount: Int {
        var i = 1
        while (withUnsafePointer(to: &i, {
            return $0.withMemoryRebound(to: self, capacity: 1, { return
                $0.pointee })
        }).hashValue != 0) {
            i += 1
        }
        return i
    }
    
    // Iterate enumarator value
    func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
        var i = 0
        return AnyIterator {
            let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
            if next.hashValue != i { return nil }
            i += 1
            return next
        }
    }
}
