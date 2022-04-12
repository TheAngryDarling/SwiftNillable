import XCTest
@testable import Nillable

class NillableTests: XCTestCase {

    func testIsNil() {
        // swiftlint:disable:next redundant_optional_initialization
        var optString: String? = nil
        var optAny: Any = optString as Any
        XCTAssert(optString.isNil, "Optional string was not nil")
        XCTAssert(optAny is Nillable, "optAny does not conform to Nillable")
        if let nillableOpt = optAny as? Nillable {
            XCTAssert(nillableOpt.isNil, "optAny was not nil")
            XCTAssert(nillableOpt.isWrappedType(String.self), "optAny Wrapped element was not of String type")
        }

        optString = "Hello World"
        optAny = optString as Any
        XCTAssert(!optString.isNil, "Optional string was nil")
        XCTAssert(optAny is Nillable, "optAny does not conform to Nillable")
        if let nillableOpt = optAny as? Nillable {
            XCTAssert(!nillableOpt.isNil, "optAny was not nil")
            XCTAssert(nillableOpt.isWrappedType(String.self), "optAny Wrapped element was not of String type")
            _ = nillableOpt.unsafeUnwrap(usingType: String.self)
        }
    }

    func testWrappedTypes() {
        let opt: String? = nil
        XCTAssert(opt.wrappedType == String.self,
                  "Expected wrapped type of '\(String.self)' but returned '\(opt.wrappedType)'")
        let opt2: String?? = "asdf"
        XCTAssert(opt2.wrappedType == Optional<String>.self,
                  "Expected wrapped type of '\(Optional<String>.self)' but returned '\(opt2.wrappedType)'")
        XCTAssert(opt2.wrappedRootType == String.self,
                  "Expected wrapped type of '\(String.self)' but returned '\(opt.wrappedRootType)'")

    }

    func testNilInAny() {
        let nilObj: String? = nil
        let anyObj: Any = nilObj as Any

        if let nilObj = anyObj as? Nillable, !nilObj.isNil {
            XCTFail("Optional String \(anyObj) stored in any object was not found to be optional or not nil")
        }

        let optString: String? = "OptString"
        let anyArray: [Any] = [nilObj as Any, optString as Any]

        for obj in anyArray where !(obj is Nillable) {
            XCTFail("Optional String \(obj) stored in any object was not found to be optional")
        }

    }

    func testIsNilFunc() {
        let nilObj: String? = nil
        let nonNilObj: String? = "Hello World"
        let nullOb = NSNull()

        XCTAssertTrue(isNil(nilObj), "Failed, obj is nil and this should return true")
        XCTAssertFalse(isNil(nonNilObj), "Failed, obj is not nil and this should return false")
        XCTAssertTrue(isNil(nullOb), "Failed, obj is nil and this should return true")
        XCTAssertFalse(isNil(nullOb, treatNSNullAsNil: false), "Failed, obj is nil and this should return false")

    }

    func testIsNilType() {

        XCTAssertTrue(isNilType(NSNull.self, treatNSNullAsNil: true))
        XCTAssertFalse(isNilType(NSNull.self, treatNSNullAsNil: false))
        XCTAssertTrue(isNilType(Optional<String>.self))
        XCTAssertFalse(isNilType(String.self))
    }

    func testOptionalObject() {
        func genFunc<O>(_ object: O) -> O where O: OptionalObject {
            return O.nilValue
        }
        func genFunc2<O, S>(_ object: O, val: S) -> S where O: OptionalObject, O.Wrapped == S {
            return object ?? val
        }
        let val: String? = "Yes"
        let object = genFunc(val)
        XCTAssertTrue(object.isNil)
        let string = genFunc2(object, val: "Yes")
        XCTAssertEqual(string, "Yes")

        let string2 = object ?? "Yes"
        XCTAssertEqual(string2, "Yes")
    }

    static var allTests = [
        ("testIsNil", testIsNil),
        ("testWrappedTypes", testWrappedTypes),
        ("testNilInAny", testNilInAny),
        ("testIsNilFunc", testIsNilFunc),
        ("testIsNilType", testIsNilType),
        ("testOptionalObject", testOptionalObject)
    ]
}
