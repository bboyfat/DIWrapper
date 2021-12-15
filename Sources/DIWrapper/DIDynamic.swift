//
//  DIDynamic.swift
//  
//
//  Created by Andrey Petrovskiy on 02.12.2021.
//

import Foundation

@propertyWrapper
public struct DIDynamic<Dependecy> {
    private(set) var dependecy: Dependecy
    
    public init(){
        self.dependecy = Resolver.shared.resolve(Dependecy.self,
                                                 registrationType: .dynamic)
    }
    
    public var wrappedValue: Dependecy {
        get { return dependecy}
        mutating set { dependecy = newValue }
    }
}
