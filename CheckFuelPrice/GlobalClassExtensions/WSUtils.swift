//
//  WSUtils.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 14/04/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import Foundation



// Swift 3
func synchronized<T>(_ lock: AnyObject, _ body: () throws -> T) rethrows -> T {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    return try body()
}

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}

