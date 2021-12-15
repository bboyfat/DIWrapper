//
//  DIStatic.swift
//  
//
//  Created by Andrey Petrovskiy on 10.12.2021.
//

import Foundation

@propertyWrapper
/// Use this wrapper when you need property which  must be created only one time
///  in module
public struct DIStatic<Dependecy> {
    private(set) var dependecy: Dependecy

    public init(){
        self.dependecy = Resolver.shared.resolve(Dependecy.self,
                                                 registrationType: .module)
    }

    public var wrappedValue: Dependecy {
        get { return dependecy}
        mutating set { dependecy = newValue }
    }
}
