//
//  CacheManager.swift
//  MyTestApp
//
//  Created by Tarun Kaiwart on 25/03/25.
//

import Foundation

protocol CacheManagerProtocol {
    func saveData<T: Encodable>(_ data: T)
    func getData<T: Decodable>(ofType type: T.Type) -> T?
}


class CacheManager: CacheManagerProtocol {
    private var cache = NSCache<NSString, NSData>()

    func saveData<T: Encodable>(_ data: T) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            cache.setObject(encodedData as NSData, forKey: String(describing: T.self) as NSString)
        } catch {
            print("Failed to cache data: \(error.localizedDescription)")
        }
    }

    func getData<T: Decodable>(ofType type: T.Type) -> T? {
        if let cachedData = cache.object(forKey: String(describing: T.self) as NSString) as Data? {
            return try? JSONDecoder().decode(T.self, from: cachedData)
        }
        return nil
    }
}

