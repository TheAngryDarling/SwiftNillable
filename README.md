# Nillable
![swift >= 4.0](https://img.shields.io/badge/swift-%3E%3D4.0-brightgreen.svg)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)
![Apache 2](https://img.shields.io/badge/license-Apache2-blue.svg?style=flat)

Protocol attached to Optional and NSNull which allows developers to check if an object is nil or not.
This is good when working with type of Any like in  Mirror, or Dictionaries where optional and NSNull types can be stored in Any

## Usage
```swift
let properties: [String: Any] = [...]
for (k,v) in properties {
    if let vO = v as? Nillable, !vO.isRootNil  {
        //Get the root value, escaping all optionals
        let rValue = vO.unsafeRootUnwrap
    }
}
```

## Authors

* **Tyler Anger** - *Initial work* - [TheAngryDarling](https://github.com/TheAngryDarling)

## License

This project is licensed under Apache License v2.0 - see the [LICENSE.md](LICENSE.md) file for details
