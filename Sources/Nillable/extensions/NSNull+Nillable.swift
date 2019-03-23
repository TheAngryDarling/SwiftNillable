//
//  NSNull+Nillable.swift
//  Nillable
//
//  Created by Tyler Anger on 2019-03-12.
//

import Foundation

extension NSNull: Nillable {
    public static var _nillableLock: _NillableLock { return _NillableLock() }
    public static var wrappedType: Any.Type { return Any.self }
    public static var wrappedRootType: Any.Type { return Any.self }
    
    public var isNil: Bool { return true }
    
    public var unsafeUnwrap: Any { preconditionFailure("unsafelyUnwrapped of nil optional") }
    public var unsafeRootUnwrap: Any { return self.unsafeUnwrap }
    
    public var safeRootUnwrap: Any? { return nil }
}
