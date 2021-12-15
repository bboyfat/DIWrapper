//
//  File.swift
//  
//
//  Created by Andrey Petrovskiy on 02.12.2021.
//

import Foundation
import UIKit

public enum ResolverRegistrationType {
    case shared
    case dynamic
    case module
}

public class Resolver {

    public static let shared = Resolver()
    private var factoryDict: [Bundle : [String: () -> Any]] = [:]
    private var staticDict: [Bundle : [String: Any]] = [:]
    private static var singletoneDict: [String: Any] = [:]

    public func add<T>(bundle: Bundle = .main,
                       registrationType: ResolverRegistrationType = .dynamic,
                       type: T.Type, _ factory: @escaping () -> T) {
        switch registrationType {
        case .dynamic:
            factoryDict[bundle]?[String(describing: type.self)] = factory
        case .module:
            let object = factory()
            addModuleStatic(bundle: bundle, type: type, object: object)
        case .shared:
            let shareObject = factory()
            addSingletone(type: type, object: shareObject)
        }
    }

    private func addModuleStatic<T>(bundle: Bundle, type: T.Type, object: T) {
        staticDict[bundle]?[String(describing: type.self)] =  object
    }

    private func addSingletone<T>(type: T.Type, object: T) {
        Resolver.singletoneDict[String(describing: type.self)] = object
    }


    public func resolve<T>(_ type: T.Type, registrationType: ResolverRegistrationType) -> T {
        switch registrationType {
        case .shared:
            return resolveSingletone(type)
        case .dynamic:
            return resolveDynamic(type)
        case .module:
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
        if let component: T = Resolver.singletoneDict[String(describing: T.self)] as? T {
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
        Resolver.singletoneDict = [:]
    }
}
