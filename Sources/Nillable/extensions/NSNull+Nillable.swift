//
//  NSNull+Nillable.swift
//  Nillable
//
//  Created by Tyler Anger on 2019-03-12.
//

import Foundation

extension NSNull: Nillable {
    // swiftlint:disable identifier_name

    /// A sad way to lock the implementation of the Nillable protocol to within its own library.
    /// This allows for others to test against Nillable but does not allow then to create new
    /// object types that implement it
    public static var _nillableLock: _NillableLock { return _NillableLock() }
    // swiftlint:enable identifier_name

    /// Implementation for Nillable.
    /// This will always return Any.self
    public static var wrappedType: Any.Type { return Any.self }
    /// Implementation for Nillable.
    /// This will always return Any.self
    public static var wrappedRootType: Any.Type { return Any.self }

    /// Implementation for Nillable.
    /// Indicates if this optional object is nil or not.
    /// This will always return true
    public var isNil: Bool { return true }

    /// Implementation for Nillable.
    /// This will always cause a preconditionFailure
    public var unsafeUnwrap: Any { preconditionFailure("unsafelyUnwrapped of nil optional") }
    /// Implementation for Nillable.
    /// This will always cause a preconditionFailure
    public var unsafeRootUnwrap: Any { return self.unsafeUnwrap }
    /// Implementation for Nillable.
    /// This will always return nil
    public var safeRootUnwrap: Any? { return nil }
}
