//
//  File.swift
//  
//
//  Created by Andrey Petrovskiy on 02.12.2021.
//

import Foundation

@propertyWrapper
public struct DIWrapper<Dependecy> {
    private(set) var dependecy: Dependecy
    
    public init(){
        self.dependecy = Resolver.shared.resolve(Dependecy.self)
    }
    
    public var wrappedValue: Dependecy {
        get { return dependecy}
        mutating set { dependecy = newValue }
    }
}
