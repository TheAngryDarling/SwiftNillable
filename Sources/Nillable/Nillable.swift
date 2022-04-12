import Foundation

/// Structure used to lock protocol implementation
public struct _NillableLock {
    // swiftlint:disable:previous type_name
    internal init() { }
}

/// Protocol used when checking objects of Any type to be nilable
public protocol Nillable {

    /// Static variable returning the Wrapped type the optional object.
    /// Eg. Optional<String> will return String.  Optional<Optional<String>> will return Optional<String>
    /// Eg. NSNull will return Any
    static var wrappedType: Any.Type { get }

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

    /// Returns the Wrapped type the optional object.
    /// Eg. Optional<String> will return String.  Optional<Optional<String>> will return Optional<String>
    var wrappedType: Any.Type { get }

    /// Returns the root Wrapped type of the optional object.
    /// This means if its a nested optional eg Optional<Optional<String>>, the return will still be String
    var wrappedRootType: Any.Type { get }

    /// Indicates if this optional object is nil or not
    var isNil: Bool { get }
    /// Indicates if the root optional object is nil or not
    var isRootNil: Bool { get }
    /// Unsafely unwraps the object.  Refer to Optional.unsafelyUnwrapped
    var unsafeUnwrap: Any { get }
    /// Unsafely unwrapes the root object.
    var unsafeRootUnwrap: Any { get }
    /// Safely unwrapes the object
    var safeUnwrap: Any? { get }
    /// Safely unwapes the root object
    var safeRootUnwrap: Any? { get }

    /// Tests the current wrapped type
    ///
    /// - Parameter type: the type to test against
    /// - Returns: Returns true if the type provided is the same as the wraped type otherwise false
    func isWrappedType<T>(_ type: T.Type) -> Bool

    /// Test the root wrapped type
    ///
    /// - Parameter type: the type to test against
    /// - Returns: Returns true if the type provided is the same as the root wraped type otherwise false
    func isRootWrappedType<T>(_ type: T.Type) -> Bool

    /// Unsafely tries to unwrap the object to specific type.
    /// This could fail on the Optional.unsafelyUnwrapped or the casting from Any to T
    ///
    /// - Parameter type: The type to force unwrap to
    /// - Returns: Returns the wrapped object as the type provided or will fail because it was nil or casting error
    func unsafeUnwrap<T>(usingType type: T.Type) -> T

    /// Safely tries to unwrap the object to specific type.
    /// If any value is nil or could not cast to T this method will return nil
    ///
    /// - Parameter type: The type to unwrap to
    /// - Returns: Returns the wrapped object as the type provided or nil on any failures
    func safeUnwrap<T>(usingType type: T.Type) -> T?

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
}

public extension Nillable {

    /// Indicates if the root optional object is nil or not
    var isRootNil: Bool {
        return (self.safeRootUnwrap == nil)
    }

    /// Safely unwrapes the object
    var safeUnwrap: Any? {
        guard !self.isNil else { return nil }
        return self.unsafeUnwrap
    }

    /// Returns the Wrapped type the optional object.
    /// Eg. Optional<String> will return String.  Optional<Optional<String>> will return Optional<String>
    var wrappedType: Any.Type { return Self.wrappedType }
    /// Static variable returning the root Wrapped type of the optional object.
    /// This means if its a nested optional eg Optional<Optional<String>>, the return will still be String
    var wrappedRootType: Any.Type { return Self.wrappedRootType }

    /// Tests the current wrapped type
    ///
    /// - Parameter type: the type to test against
    /// - Returns: Returns true if the type provided is the same as the wraped type otherwise false
    func isWrappedType<T>(_ type: T.Type) -> Bool {
        return (type == wrappedType)
    }
    /// Test the root wrapped type
    ///
    /// - Parameter type: the type to test against
    /// - Returns: Returns true if the type provided is the same as the root wraped type otherwise false
    func isRootWrappedType<T>(_ type: T.Type) -> Bool {
        return (type == self.wrappedRootType)
    }
    /// Unsafely tries to unwrap the object to specific type.
    /// This could fail on the Optional.unsafelyUnwrapped or the casting from Any to T
    ///
    /// - Parameter type: The type to force unwrap to
    /// - Returns: Returns the wrapped object as the type provided or will fail because it was nil or casting error
    func unsafeUnwrap<T>(usingType type: T.Type) -> T {
        let val = self.unsafeUnwrap
        // swiftlint:disable:next force_cast
        return val as! T
    }

    /// Safely tries to unwrap the object to specific type.
    /// If any value is nil or could not cast to T this method will return nil
    ///
    /// - Parameter type: The type to unwrap to
    /// - Returns: Returns the wrapped object as the type provided or nil on any failures
    func safeUnwrap<T>(usingType type: T.Type) -> T? {
        guard let val = self.safeUnwrap else { return nil }
        return val as? T
    }

    /// Unsafely tries to unwrap the root object to specific type.
    /// This could fail on the Optional.unsafelyUnwrapped or the casting from Any to T
    ///
    /// - Parameter type: The type to force unwrap to
    /// - Returns: Returns the root wrapped object as the type provided or will fail because it was nil or casting error
    func unsafeRootUnwrap<T>(usingType type: T.Type) -> T {
        let val = self.unsafeRootUnwrap
        // swiftlint:disable:next force_cast
        return val as! T
    }

    /// Safely tries to unwrap the root object to specific type.
    /// If any value is nil or could not cast to T this method will return nil
    ///
    /// - Parameter type: type: The type to unwrap to
    /// - Returns: Returns the root wrapped object as the type provided or nil on any failures
    func safeRootUnwrap<T>(usingType type: T.Type) -> T? {
        guard let val = self.safeRootUnwrap else { return nil }
        return val as? T
    }

}

/// A Simple method to check if any object is nil or not.
/// Greate when working with objects stored in Any
///
/// - Parameters:
///   - value: value to check if it is nil or not
///   - treatNSNullAsNil: Bool indicator to tell if the method should treat NSNull as nil
/// - Returns: returns true if the value is actually nil otherwise false
public func isNil<V>(_ value: V, treatNSNullAsNil: Bool = true) -> Bool {
    guard let val = value as? Nillable else { return false }
    // If value is NSNull and not treatNSNullAsNil then we shouuld return false
    guard !(!treatNSNullAsNil && value is NSNull) else { return false }
    return val.isNil
}

/// AnyNil: Pure swift variant of NSNull.  real definition is Optional<Any>.none
/// Great when working with arrays and dictionaries that can contain Any as a value type
public let AnyNil: Any = (Optional<Any>.none as Any)
// swiftlint:disable:previous identifier_name

/// A Simple method to check to see if any Object Type is nillable
///
/// - Parameters:
///   - typ: Object type to check
///   - treatNSNullAsNil: Bool indicator to tell if the method should treat NSNull as nil
/// - Returns: returns true if the type is actually nillable otherwise false
public func isNilType<V>(_ typ: V.Type, treatNSNullAsNil: Bool = true) -> Bool {
    guard typ is Nillable.Type else { return false }
    // If type is NSNull and not treatNSNullAsNil then we shouuld return false
    guard !(!treatNSNullAsNil && typ == NSNull.self) else { return false }
    return true
}
