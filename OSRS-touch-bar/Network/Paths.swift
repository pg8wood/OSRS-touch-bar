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
    case presentFKeyTouchBar = "/presentfkeytouchbar"
    case customizeFKeyTouchBar = "/customizeFKeyTouchBar"
    
    var requestHandler: RequestHandling {
        switch self {
        case .killTouchBar:
            return KillTouchBarHandler()
        case .presentFKeyTouchBar:
            return PresentFKeyTouchBarHandler()
        case .customizeFKeyTouchBar:
            return CustomizeFKeyTouchBarHandler()
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
