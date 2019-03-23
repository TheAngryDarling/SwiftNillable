//
//  Optional+Nillable.swift
//  Nillable
//
//  Created by Tyler Anger on 2019-03-12.
//

import Foundation

extension Optional: Nillable {
    public static var _nillableLock: _NillableLock { return _NillableLock() }
    
    public static var wrappedType: Any.Type { return Wrapped.self }
    public static var wrappedRootType: Any.Type {
        var rtn: Any.Type = Optional.wrappedType
        if let t = rtn as? Nillable.Type {
            rtn = t.wrappedType
        }
        return rtn
    }
    
    public var isNil: Bool {
        switch self {
        case .none:  return true
        default:  return false
        }
    }
    
    public var unsafeUnwrap: Any { return self.unsafelyUnwrapped }
    
    public var unsafeRootUnwrap: Any {
        var rtn: Any = self.unsafeUnwrap
        if let r = rtn as? Nillable {
            rtn = r.unsafeRootUnwrap
        }
        return rtn
    }
    
    public var safeRootUnwrap: Any? {
        guard !isNil else { return nil }
        
        if let r = self.unsafeUnwrap as? Nillable {
            // If our Wrapped type is of optional type, then lets unwrap it
            return r.safeRootUnwrap
        } else {
            return self.unsafeUnwrap
        }
    }
}
