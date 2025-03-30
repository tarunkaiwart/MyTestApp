//
//  JailbreakDetectionManager.swift
//  MyTestApp
//
//  Created by Tarun Kaiwart on 30/03/25.
//

import Foundation

// Define the protocol
protocol JailbreakDetectionManagerProtocol {
    /// Checks whether the device is jailbroken.
    /// - Returns: A Boolean value indicating if the device is jailbroken.
    func isDeviceJailbroken() -> Bool
}
// MARK: - Jailbreak Detection
final class JailbreakDetectionManager : JailbreakDetectionManagerProtocol {
    
    // Singleton instance
    static let shared = JailbreakDetectionManager()
    
    private init() {} // Prevent direct instantiation
    
    /// Checks if the device is jailbroken
    func isDeviceJailbroken() -> Bool {
        // 1. Check for known jailbreak file paths
        let jailbreakPaths = [
            "/Applications/Cydia.app",
            "/Applications/FakeCarrier.app",
            "/Applications/SBSettings.app",
            "/Applications/WinterBoard.app",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/",
            "/private/var/stash"
        ]
        
        for path in jailbreakPaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        
        // 2. Check if the app can write to system directories
        let testWritePath = "/private/jailbreakTest.txt"
        do {
            try "Test".write(toFile: testWritePath, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: testWritePath)
            return true  // Jailbreak detected since writing was successful
        } catch {
            #if DEBUG
            print("Jailbreak test failed to write: \(error.localizedDescription)")
            #endif
        }
        
        // 3. Check for suspicious dynamic libraries
        let suspiciousLibraries = [
            "SubstrateLoader.dylib",
            "cyinject.dylib",
            "libcycript.dylib"
        ]
        
        for library in suspiciousLibraries {
            if let _ = dlsym(UnsafeMutableRawPointer(bitPattern: -2), library) {
                return true
            }
        }
        
        return false
    }
}
