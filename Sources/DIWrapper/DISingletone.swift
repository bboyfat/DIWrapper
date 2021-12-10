//
//  DISingletone.swift
//  
//
//  Created by Andrey Petrovskiy on 10.12.2021.
//

import Foundation

@propertyWrapper
/// Use this wrapper when you need property singletone
public struct DISingletone<Dependecy> {
    private(set) var dependecy: Dependecy

    public init(){
        self.dependecy = Resolver.shared.resolveSingletone(Dependecy.self)
    }

    public var wrappedValue: Dependecy {
        get { return dependecy}
        mutating set { dependecy = newValue }
    }
}
