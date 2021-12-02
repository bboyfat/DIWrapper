//
//  File.swift
//  
//
//  Created by Andrey Petrovskiy on 02.12.2021.
//

import Foundation

public class Resolver {

    public static let shared = Resolver()
    private var factoryDict: [String: () -> Any] = [:]

    public func add<T>(type: T.Type, _ factory: @escaping () -> T) {
        factoryDict[String(describing: type.self)] = factory
    }

    @discardableResult
    public func resolve<T>(_ type: T.Type) -> T {
        if let component: T = factoryDict[String(describing: T.self)]?() as? T {
        return component
        } else {
            fatalError("!!!!You has frogot to add \(String(describing: T.self))!!!!")
        }
    }
}
