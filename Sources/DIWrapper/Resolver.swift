//
//  File.swift
//  
//
//  Created by Andrey Petrovskiy on 02.12.2021.
//

import Foundation
import UIKit

public enum ResolverRegistrationType {
    case singleton
    case newInstance
    case moduleSingleton
}

public class Resolver {

    public static let shared = Resolver()
    private var factoryDict: [Bundle : [String: () -> Any]] = [:]
    private var staticDict: [Bundle : [String: Any]] = [:]
    private var singletonDict: [String: Any] = [:]


    /// Register dependencies
    /// bundle = unoque identifier for dictionaries if you are working with ModuleArchitecture, by default is .main
    /// registration type = instance type registration
    public func add<T>(bundle: Bundle = .main,
                       registrationType: ResolverRegistrationType = .newInstance,
                       type: T.Type, _ factory: @escaping () -> T) {
        switch registrationType {
        case .newInstance:
            if factoryDict[bundle] != nil {
                factoryDict[bundle]?[String(describing: type.self)] = factory
            } else {
                factoryDict[bundle] = [String(describing: type.self) : factory]
            }
            factoryDict[bundle]?[String(describing: type.self)] = factory
        case .moduleSingleton:
            let object = factory()
            addModuleStatic(bundle: bundle, type: type, object: object)
        case .singleton:
            let shareObject = factory()
            addSingleton(type: type, object: shareObject)
        }
    }

    private func addModuleStatic<T>(bundle: Bundle, type: T.Type, object: T) {
        if staticDict[bundle] != nil {
            staticDict[bundle]?[String(describing: type.self)] = object
        } else {
            staticDict[bundle] = [String(describing: type.self) : object]
        }
    }

    private func addSingleton<T>(type: T.Type, object: T) {
        Resolver.singletonDict[String(describing: type.self)] = object
    }


    public func resolve<T>(_ type: T.Type, registrationType: ResolverRegistrationType) -> T {
        switch registrationType {
        case .singleton:
            return resolveSingletone(type)
        case .newInstance:
            return resolveDynamic(type)
        case .moduleSingleton:
            return resolveModuleStatic(type)
        }

    }

    @discardableResult
    private func resolveDynamic<T>(_ type: T.Type) -> T {
        var component: T?
        factoryDict.forEach {
            if let object: T = $0.value[String(describing: T.self)]?() as? T {
                component = object
                return
            }
        }
        if let component = component {
            return component
        } else {
            fatalError("!!!!You has frogot to add \(String(describing: T.self))!!!!")
        }
    }

    @discardableResult
    private func resolveSingletone<T>(_ type: T.Type) -> T {
        if let component: T = Resolver.singletonDict[String(describing: T.self)] as? T {
        return component
        } else {
            fatalError("!!!!You has frogot to add \(String(describing: T.self))!!!!")
        }
    }

    @discardableResult
    private func resolveModuleStatic<T>(_ type: T.Type) -> T {
        var component: T?
        staticDict.forEach {
            if let object: T = $0.value[String(describing: T.self)] as? T {
                component = object
            }
        }
        if let component = component {
            return component
        } else {
            fatalError("!!!!You has frogot to add \(String(describing: T.self))!!!!")
        }
    }

    // MARK: - Clear module dependencies
    public func clearModuleDependecies(bundle: Bundle = .main) {
        staticDict[bundle] = [:]
        factoryDict[bundle] = [:]
    }

    public func clearSharedDependecies() {
        singletonDict = [:]
    }
}
