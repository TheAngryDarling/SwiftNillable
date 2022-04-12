//
//  OptionalObject.swift
//  
//
//  Created by Tyler Anger on 2022-04-12.
//

import Foundation

public protocol OptionalObject: Nillable, ExpressibleByNilLiteral {
    associatedtype Wrapped

    /// Static variable returning the root Wrapped type of the optional object.
    /// This means if its a nested optional eg Optional<Optional<String>>, the return will still be String
    static var wrappedRootType: Any.Type { get }

    /// A sad way to lock the implementation of this protocol to within its own library.
    /// This allows for others to test against Nillable but does not allow then to create
    /// new object types that implement it
    static var _nillableLock: _NillableLock { get }
    // swiftlint:disable:previous identifier_name

    /// A nil value of the given type
    /// Eg. Optional<...>.none, NSNull()
    static var nilAnyValue: Any { get }

    /// A nil value of the given type
    /// Eg. Optional<...>.none
    static var nilValue: Self { get }

    /// Returns the root Wrapped type of the optional object.
    /// This means if its a nested optional eg Optional<Optional<String>>, the return will still be String
    var wrappedRootType: Any.Type { get }

    /// Indicates if this optional object is nil or not
    var isNil: Bool { get }
    /// Indicates if the root optional object is nil or not
    var isRootNil: Bool { get }
    /// The wrapped value of this instance or nil of no value found
    var safelyUnwarapped: Wrapped? { get }
    /// The wrapped value of this instance, unwrapped without checking whether the instance is nil.
    var unsafelyUnwrapped: Wrapped { get }
    /// Unsafely unwrapes the root object.
    var unsafeRootUnwrap: Any { get }
    /// Safely unwapes the root object
    var safeRootUnwrap: Any? { get }

    /// Test the root wrapped type
    ///
    /// - Parameter type: the type to test against
    /// - Returns: Returns true if the type provided is the same as the root wraped type otherwise false
    func isRootWrappedType<T>(_ type: T.Type) -> Bool

    /// Unsafely tries to unwrap the root object to specific type.
    /// This could fail on the Optional.unsafelyUnwrapped or the casting from Any to T
    ///
    /// - Parameter type: The type to force unwrap to
    /// - Returns: Returns the root wrapped object as the type provided or will fail because it was nil or casting error
    func unsafeRootUnwrap<T>(usingType type: T.Type) -> T

    /// Safely tries to unwrap the root object to specific type.
    /// If any value is nil or could not cast to T this method will return nil
    ///
    /// - Parameter type: type: The type to unwrap to
    /// - Returns: Returns the root wrapped object as the type provided or nil on any failures
    func safeRootUnwrap<T>(usingType type: T.Type) -> T?

    /// Creates an instance that stores the given value.
    init(_ some: Wrapped)
}

public extension OptionalObject {
    static var nilValue: Self { return .init(nilLiteral: ()) }
}

public func ?? <O, T>(optional: O, defaultValue: @autoclosure () throws -> T) rethrows -> T
where O: OptionalObject, O.Wrapped == T {
    guard let rtn = optional.safelyUnwarapped else {
        return try defaultValue()
    }
    return rtn
}
public func ?? <O>(optional: O, defaultValue: @autoclosure () throws -> O) rethrows -> O
where O: OptionalObject {
    guard let rtn = optional.safelyUnwarapped else {
        return try defaultValue()
    }
    return .init(rtn)
}
