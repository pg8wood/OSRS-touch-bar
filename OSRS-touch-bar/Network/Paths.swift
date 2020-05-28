//
//  Paths.swift
//  OSRS Touch Bar
//
//  Created by Patrick Gatewood on 5/28/20.
//  Copyright © 2020 Patrick Gatewood. All rights reserved.
//

import Swifter

enum ServerPath: String, CaseIterable {
    case killTouchBar = "/killtouchbar"
    case newTouchBar = "/presentfkeytouchbar"
    
    var requestHandler: RequestHandling {
        switch self {
        case .killTouchBar:
            return KillTouchBarHandler()
        case .newTouchBar:
            return PresentFKeyTouchBarHandler()
        }
    }
}

protocol RequestHandling {
    func handleRequest(request: HttpRequest) -> HttpResponse
}

extension HttpServer {
    subscript(path: ServerPath) -> RequestHandling? {
        set {
            self[path.rawValue] = newValue?.handleRequest
        }
        get { return nil }
    }
}
