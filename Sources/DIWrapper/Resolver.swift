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
    private var staticDict: [String: Any] = [:]
    private static var singletoneDict: [String: Any] = [:]

    public func add<T>(type: T.Type, _ factory: @escaping () -> T) {
        factoryDict[String(describing: type.self)] = factory
    }

    public func addModuleStatic<T>(type: T.Type, object: T) {
        staticDict[String(describing: type.self)] = object
    }

    public func addSingletone<T>(type: T.Type, object: T) {
        Resolver.singletoneDict[String(describing: type.self)] = object
    }

    @discardableResult
    public func resolve<T>(_ type: T.Type) -> T {
        if let component: T = factoryDict[String(describing: T.self)]?() as? T {
        return component
        } else {
            fatalError("!!!!You has frogot to add \(String(describing: T.self))!!!!")
        }
    }

    @discardableResult
    public func resolveSingletone<T>(_ type: T.Type) -> T {
        if let component: T = Resolver.singletoneDict[String(describing: T.self)] as? T {
        return component
        } else {
            fatalError("!!!!You has frogot to add \(String(describing: T.self))!!!!")
        }
    }

    @discardableResult
    public func resolveModuleStatic<T>(_ type: T.Type) -> T {
        if let component: T = staticDict[String(describing: T.self)] as? T {
        return component
        } else {
            fatalError("!!!!You has frogot to addModuleStatic \(String(describing: T.self))!!!!")
        }
    }
}
