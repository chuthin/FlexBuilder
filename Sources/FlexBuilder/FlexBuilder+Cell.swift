//
//  FlexBuilder+Cell.swift
//  FlexBuilder
//
//  Created by Chu Thin on 14/07/2023.
//

import Foundation
import UIKit
import FlexLayout
public typealias CellAction = (CellDataContext?) -> Void
public typealias DataContext = (CellDataContext?) -> ((IndexPath?,Identifier?,Int) -> Void)?
public protocol AnyCell {
    associatedtype C:CellDataContext
    var classType: C.Type {set get}
    var identifier: String {set get}
    var cellAction: CellAction? {set get}
    var dataContext: DataContext? {set get}
    func register(_ view: any ItemsScrollView) -> Void
}


public struct FCell<C:CellDataContext,I:Identifier> : AnyCell{
    public func register(_ view: any ItemsScrollView) {
        view.register(self.classType as? AnyClass, kind: self.kind, reuseIdentifier: self.identifier)
    }
    
    public var classType: C.Type
    public var identifier: String
    public var cellAction: CellAction?
    public var dataContext: DataContext?
    public var kind:String?
    public init(_ kind:String? = nil) {
        self.kind = kind
        self.classType = C.self
        self.identifier = I.identifier
    }
    
    public func action<A>(_ cellAction: @escaping (A) -> Void) -> Self where C : ActionCollectionViewCell<A> {
        var result = self
        result.cellAction = { value in
            if let cell = value as? C {
                cell.handle = { action in
                    cellAction(action)
                }
            }
        }
        return result
    }
    
    public func action<A>(_ cellAction: @escaping (A) -> Void) -> Self where C : ActionTableViewCell<A> {
        var result = self
        result.cellAction = { value in
            if let cell = value as? C {
                cell.handle = { action in
                    cellAction(action)
                }
            }
            
        }
        return result
    }
    
    public func action<A>(_ cellAction: @escaping (A) -> Void) -> Self where C : ActionSupplementaryView<A> {
        var result = self
        result.cellAction = { value in
            if let cell = value as? C {
                cell.handle = { action in
                    cellAction(action)
                }
            }
            
        }
        return result
    }
    
    public func dataContext(_ dataContext: @escaping (C?,IndexPath,I,Int) -> Void) -> Self {
        var result = self
        result.dataContext = { cell in
            return { index, item, count in
                if let itemValue:I = item?.asType(), let indexPath = index {
                    dataContext(cell as? C,indexPath,itemValue, count)
                }
            }
        }
        return result
    }
}

extension Collection where Element == any AnyCell {
    public func getCell(_ identifier: String) -> (any AnyCell)? {
        return self.filter{ $0.identifier == identifier}.first
    }
}

@resultBuilder public struct AnyCellBuilder {
    public static func buildBlock() -> [FView] {
        []
    }
    public static func buildBlock(_ values: any AnyCell...) -> [any AnyCell] {
        values
    }
}

public protocol CellDataContext {
    var data:Identifier? {get set}
    func setDataContext(indexPath:IndexPath,data:Identifier, numberOfItems: Int)
}

public protocol Identifier  {
    var identifier: String {get}
    func asType<T>() -> T?
}

extension Identifier {
    public var identifier: String {
        return "\(Self.self)"
    }
    
    public static var identifier : String {
        return "\(Self.self)"
    }
    
    public func asType<T>() -> T? {
        return self as? T
    }
}

public struct CellContext {
    public var data: Identifier?
    public let indexPath: IndexPath
    public init(data: Identifier? = nil, indexPath: IndexPath) {
        self.data = data
        self.indexPath = indexPath
    }
}

public typealias SelectionHandler = (CellContext) -> Void
public typealias PageHandler = (Int) -> Void
