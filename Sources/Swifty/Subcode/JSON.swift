//
//  JSON.swift
//  PappasSpriteKit
//
//  Created by Jonathan Pappas on 8/4/23.
//

import Foundation

func _encode<T: Codable>(_ value: T) -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    guard let jsonData = try? encoder.encode(value) else { fatalError("Encoding Error") }
    if let jsonString = String(data: jsonData, encoding: .utf8) {
        return jsonString
    }
    fatalError("String error?")
}

func _decode<T: Codable>(_ jsonString: String) -> T {
    do {
        if let jsonData = jsonString.data(using: .utf8),
           case let decodedData = try JSONDecoder().decode(T.self, from: jsonData) {
            //print("Decoded name: \(decodedData.name), age: \(decodedData.age)")
            return decodedData
        }
    } catch let error {
        print(error)
    }
    
    fatalError("Error decoding JSON")
}

extension Encodable where Self: Decodable {
    func encode() -> String {
        return _encode(self)
    }
    static func decode(_ jsonString: String) -> Self {
        _decode(jsonString)
    }
}

typealias JSON = Codable

protocol JSONEnum: Codable {}
    
extension JSONEnum where Self: Codable {
    // Optional: If you want to customize the JSON output format
    func encode() -> String {
        _encode(self)
    }
    static func decode(_ jsonString: String) -> Self {
        _decode(jsonString)
    }
}

