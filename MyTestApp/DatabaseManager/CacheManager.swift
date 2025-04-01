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
            let cacheKey = String(describing: T.self)
            // Store encoded data in cache with a key based on the data type.
            cache.setObject(encodedData as NSData, forKey: cacheKey as NSString)
            print("Saved data to Cache Memory with key: \(cacheKey), Data: \(encodedData)")
        } catch {
            print("Failed to cache data: \(error.localizedDescription)")
        }
    }

    /// Retrieves a Decodable object from the cache.
    /// - Parameter type: The expected type of the cached object.
    /// - Returns: The decoded object if available; otherwise, nil.
    func getData<T: Decodable>(ofType type: T.Type) -> T? {
        // Use the same key when retrieving the data.
        let cacheKey = String(describing: T.self)
        
        // Retrieve cached data using the cache key.
        if let cachedData = cache.object(forKey: cacheKey as NSString) as? NSData {
            let data = cachedData as Data
            print("Cache contains data for key: \(cacheKey), Data length: \(data.count) bytes")
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                print("Successfully decoded data: \(decodedData)")
                return decodedData
            } catch {
                print("Failed to decode cached data: \(error.localizedDescription)")
            }
        } else {
            print("No data found in cache for key: \(cacheKey)")
        }
        return nil
    }


}
