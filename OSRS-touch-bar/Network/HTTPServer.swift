//
//  HTTPServer.swift
//  OSRS Touch Bar
//
//  Created by Patrick Gatewood on 5/28/20.
//  Copyright © 2020 Patrick Gatewood. All rights reserved.
//

import Swifter

enum HTTPServer {
    private static let server = HttpServer()
    
    @discardableResult
    static func start(port: in_port_t = 8080) -> Result<Int, Error> {
        defer {
            setupPaths()
        }
        
        do {
            try server.start(port, forceIPv4: false, priority: .userInteractive)
            return .success(try server.port())
        } catch {
            if case .bindFailed = error as? SocketError {
                print("Address already in use: trying to start on port \(port + 1)")
                return start(port: port + 1)
            }
            return .failure(error)
        }
    }
    
    private static func setupPaths() {
        ServerPath.allCases.forEach { path in
            server[path] = path.requestHandler
        }
    }
}
