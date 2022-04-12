//
//  Optional+Nillable.swift
//  Nillable
//
//  Created by Tyler Anger on 2019-03-12.
//

import Foundation

extension Optional: OptionalObject {

    /// A sad way to lock the implementation of the Nillable protocol to within its own library.
    /// This allows for others to test against Nillable but does not allow then to create new
    /// object types that implement it
    public static var _nillableLock: _NillableLock { return _NillableLock() }
    // swiftlint:disable:previous identifier_name

    /// Static variable returning the Wrapped type the optional object.
    /// Eg. Optional<String> will return String.  Optional<Optional<String>> will return Optional<String>
    /// Eg. NSNull will return Any
    public static var wrappedType: Any.Type { return Wrapped.self }
    /// Static variable returning the root Wrapped type of the optional object.
    /// This means if its a nested optional eg Optional<Optional<String>>, the return will still be String
    public static var wrappedRootType: Any.Type {
        var rtn: Any.Type = Optional.wrappedType
        if let nillableType = rtn as? Nillable.Type {
            rtn = nillableType.wrappedType
        }
        return rtn
    }

    public static var nilAnyValue: Any { return Optional<Wrapped>.none as Any }

    /// Indicates if this optional object is nil or not
    public var isNil: Bool {
        guard case .none = self else {
            return false
        }
        return true
    }
    public var safelyUnwarapped: Wrapped? {
        return self
    }
    /// Unsafely unwraps the object.  Refer to Optional.unsafelyUnwrapped
    public var unsafeUnwrap: Any { return self.unsafelyUnwrapped }
    /// Unsafely unwrapes the root object.
    public var unsafeRootUnwrap: Any {
        var rtn: Any = self.unsafeUnwrap
        if let nillableRtn = rtn as? Nillable {
            rtn = nillableRtn.unsafeRootUnwrap
        }
        return rtn
    }
    /// Safely unwapes the root object
    public var safeRootUnwrap: Any? {
        guard !self.isNil else { return nil }

        if let nillableObject = self.unsafeUnwrap as? Nillable {
            // If our Wrapped type is of optional type, then lets unwrap it
            return nillableObject.safeRootUnwrap
        } else {
            return self.unsafeUnwrap
        }
    }
}
