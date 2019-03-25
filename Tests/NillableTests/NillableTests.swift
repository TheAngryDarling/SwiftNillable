import XCTest
@testable import Nillable

class NillableTests: XCTestCase {
    func testIsNil() {
        var optString: String? = nil
        var optAny: Any = optString as Any
        XCTAssert(optString.isNil, "Optional string was not nil")
        XCTAssert(optAny is Nillable, "optAny does not conform to Nillable")
        if let op = optAny as? Nillable {
            XCTAssert(op.isNil, "optAny was not nil")
            XCTAssert(op.isWrappedType(String.self), "optAny Wrapped element was not of String type")
        }
        
        optString = "Hello World"
        optAny = optString as Any
        XCTAssert(!optString.isNil, "Optional string was nil")
        XCTAssert(optAny is Nillable, "optAny does not conform to Nillable")
        if let op = optAny as? Nillable {
            XCTAssert(!op.isNil, "optAny was not nil")
            XCTAssert(op.isWrappedType(String.self), "optAny Wrapped element was not of String type")
            _ = op.unsafeUnwrap(usingType: String.self)
        }
    }
    
    func testWrappedTypes() {
        let opt: String? = nil
        XCTAssert(opt.wrappedType == String.self, "Expected wrapped type of '\(String.self)' but returned '\(opt.wrappedType)'")
        let opt2: String?? = "asdf"
        XCTAssert(opt2.wrappedType == Optional<String>.self, "Expected wrapped type of '\(Optional<String>.self)' but returned '\(opt2.wrappedType)'")
        XCTAssert(opt2.wrappedRootType == String.self, "Expected wrapped type of '\(String.self)' but returned '\(opt.wrappedRootType)'")
        
    }
    
    func testNilInAny() {
        let nilObj: String? = nil
        let anyObj: Any = nilObj as Any
        
        if let nl = anyObj as? Nillable, nl.isNil {} else {
            XCTFail("Optional String \(anyObj) stored in any object was not found to be optional or not nil")
        }
        
        let optString: String? = "OptString"
        let anyArray: [Any] = [nilObj as Any, optString as Any]
        
        for v in anyArray {
            if let _ = v as? Nillable {} else {
                XCTFail("Optional String \(v) stored in any object was not found to be optional")
            }
        }
        
    }
    
    func testIsNilFunc() {
        let nilObj: String? = nil
        let nonNilObj: String? = "Hello World"
        let nullOb = NSNull()
        
        XCTAssert(isNil(nilObj), "Failed, obj is nil and this should return true")
        XCTAssert(!isNil(nonNilObj), "Failed, obj is not nil and this should return false")
        XCTAssert(isNil(nullOb), "Failed, obj is nil and this should return true")
        XCTAssert(!isNil(nullOb, treatNSNullAsNil: false), "Failed, obj is nil and this should return false")
        
    }
    
    
    static var allTests = [
        ("testIsNil", testIsNil),
        ("testWrappedTypes", testWrappedTypes),
        ("testNilInAny", testNilInAny),
        ("testIsNilFunc", testIsNilFunc)
    ]
}
