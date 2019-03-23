import Foundation

// Structure used to lock protocol implementation
public struct _NillableLock {
    internal init() { }
}

// Protocol used when checking objects of Any type to be nilable
public protocol Nillable {
    // Static variable returning the Wrapped type the optional object.
    // Eg. Optional<String> will return String.  Optional<Optional<String>> will return Optional<String>
    // Eg. NSNull will return Any
    static var wrappedType: Any.Type { get }
    // Static variable returning the root Wrapped type of the optional object. This means if its a nested optional eg Optional<Optional<String>>, the return will still be String
    static var wrappedRootType: Any.Type { get }
    
    // A sad way to lock the implementation of this protocol to within its own library.
    // This allows for others to test against OptionalProtocol but does not allow then to create new object types that implement it
    static var _nillableLock: _NillableLock { get }
    
    // Returns the Wrapped type the optional object.  Eg. Optional<String> will return String.  Optional<Optional<String>> will return Optional<String>
    var wrappedType: Any.Type { get }
    // Returns the root Wrapped type of the optional object. This means if its a nested optional eg Optional<Optional<String>>, the return will still be String
    var wrappedRootType: Any.Type { get }
    
    // Indicates if this optional object is nil or not
    var isNil: Bool { get }
    // Indicates if the root optional object is nil or not
    var isRootNil: Bool { get }
    // Unsafely unwrapes the object.  Refer to Optional.unsafelyUnwrapped
    var unsafeUnwrap: Any { get }
    // Unsafely unwrapes the root object.
    var unsafeRootUnwrap: Any { get }
    // Safely unwrapes the object
    var safeUnwrap: Any? { get }
    // Safely unwapes the root object
    var safeRootUnwrap: Any? { get }
    
    // Tests the current wrapped type
    func isWrappedType<T>(_ type: T.Type) -> Bool
    // Test the root wrapped type
    func isRootWrappedType<T>(_ type: T.Type) -> Bool
    
    // Unsafely tries to unwrap the object to specific type.  This could fail on the Optional.unsafelyUnwrapped or the casting from Any to T
    func unsafeUnwrap<T>(usingType type: T.Type) -> T
    // Safely tries to unwrap the object to specific type.  If any value is nil or could not cast to T this method will return nil
    func safeUnwrap<T>(usingType type: T.Type) -> T?
    
    // Unsafely tries to unwrap the root object to specific type.  This could fail on the Optional.unsafelyUnwrapped or the casting from Any to T
    func unsafeRootUnwrap<T>(usingType type: T.Type) -> T
    // Safely tries to unwrap the root object to specific type.  If any value is nil or could not cast to T this method will return nil
    func safeRootUnwrap<T>(usingType type: T.Type) -> T?
}

public extension Nillable {
    
    public var isRootNil: Bool {
        return (self.safeRootUnwrap == nil)
    }
    
    public var safeUnwrap: Any? {
        guard !self.isNil else { return nil }
        return self.unsafeUnwrap
    }
    
    public var wrappedType: Any.Type { return Self.wrappedType }
    public var wrappedRootType: Any.Type { return Self.wrappedRootType }
    
    public func isWrappedType<T>(_ type: T.Type) -> Bool {
        return (type == wrappedType)
    }
    public func isRootWrappedType<T>(_ type: T.Type) -> Bool {
        return (type == self.wrappedRootType)
    }
    public func unsafeUnwrap<T>(usingType type: T.Type) -> T {
        let v = self.unsafeUnwrap
        return v as! T
    }
    
    public func safeUnwrap<T>(usingType type: T.Type) -> T? {
        guard let v = self.safeUnwrap else { return nil }
        return v as? T
    }
    
    public func unsafeRootUnwrap<T>(usingType type: T.Type) -> T {
        let v = self.unsafeRootUnwrap
        return v as! T
    }
    
    public func safeRootUnwrap<T>(usingType type: T.Type) -> T? {
        guard let v = self.safeRootUnwrap else { return nil }
        return v as? T
    }
}




