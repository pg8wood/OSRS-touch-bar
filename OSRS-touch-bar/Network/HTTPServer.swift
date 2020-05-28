//
//  HTTPServer.swift
//  OSRS Touch Bar
//
//  Created by Patrick Gatewood on 5/28/20.
//  Copyright © 2020 Patrick Gatewood. All rights reserved.
//

import Swifter

enum HTTPServerError: LocalizedError {
    case serverAlreadyRunning
    case `internal`(Error)
    
    var localizedDescription: String {
        switch self {
        case .serverAlreadyRunning:
            return "The HTTPServer has already been started."
        case .internal(let error):
            return error.localizedDescription
        }
    }
}

enum HTTPServer {
    private static let server = HttpServer()
    
    static func start() -> Result<Int, HTTPServerError> {
        guard !server.operating else {
            return .failure(.serverAlreadyRunning)
        }
        
        setupPaths()
        
        do {
            try server.start(8080, forceIPv4: false, priority: .userInteractive)
            return .success(try server.port())
        } catch {
            print("error starting server: \(error)")
            return .failure(.internal(error))
        }
    }
    
    private static func setupPaths() {
        server["/hello"] = { .ok(.htmlBody("You asked for \($0)"))  }
        server["/killtouchbar"] = { request in
            DispatchQueue.main.async {
                // TODO: - add availability check to runelite plugin if possible
                if #available(OSX 10.14, *) {
                    TouchBarManager.shared.dismissModalTouchBar()
                } else {
                    // Fallback on earlier versions
                }
            }
            return HttpResponse.ok(.htmlBody("1-tick AGS spec-ing that touch bar"))
        }
        server["/newtouchbar"] = { request in
            DispatchQueue.main.async {
                TouchBarManager.shared.presentModalTouchBar()
            }
            
            return HttpResponse.ok(.htmlBody("new touch bar coming up!"))
        }
    }
}
