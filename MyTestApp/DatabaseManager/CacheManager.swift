//
//  CacheManager.swift
//  MyTestApp
//
//  Created by Tarun Kaiwart on 25/03/25.
//
import Foundation

/// Protocol defining cache operations for storing and retrieving data.
protocol CacheManagerProtocol {
    /// Saves encodable data to cache.
    /// - Parameter data: The data to be encoded and stored.
    func saveData<T: Encodable>(_ data: T)

    /// Retrieves decodable data from cache.
    /// - Parameter type: The expected type of the stored data.
    /// - Returns: The decoded object if found, otherwise nil.
    func getData<T: Decodable>(ofType type: T.Type) -> T?
}

/// A generic cache manager using NSCache for temporary in-memory storage.
class CacheManager: CacheManagerProtocol {
    /// In-memory cache to store encoded data.
    private var cache = NSCache<NSString, NSData>()

    /// Saves an Encodable object to the cache after encoding it into JSON format.
    /// - Parameter data: The object to be cached.
    func saveData<T: Encodable>(_ data: T) {
        do {
            // Encode the data to JSON format.
            let encodedData = try JSONEncoder().encode(data)
            // Store encoded data in cache with a key based on the data type.
            cache.setObject(encodedData as NSData, forKey: String(describing: T.self) as NSString)
        } catch {
            print("Failed to cache data: \(error.localizedDescription)")
        }
    }

    /// Retrieves a Decodable object from the cache.
    /// - Parameter type: The expected type of the cached object.
    /// - Returns: The decoded object if available; otherwise, nil.
    func getData<T: Decodable>(ofType type: T.Type) -> T? {
        // Retrieve cached data using the type's name as the key.
        if let cachedData = cache.object(forKey: String(describing: T.self) as NSString) as Data? {
            // Attempt to decode the retrieved data.
            return try? JSONDecoder().decode(T.self, from: cachedData)
        }
        return nil
    }
}
