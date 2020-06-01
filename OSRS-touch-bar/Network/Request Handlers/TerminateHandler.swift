//
//  TerminateHandler.swift
//  OSRS Touch Bar
//
//  Created by Patrick Gatewood on 6/1/20.
//  Copyright © 2020 Patrick Gatewood. All rights reserved.
//

import Swifter

struct TerminateHandler: RequestHandling {
    func handleRequest(request: HttpRequest) -> HttpResponse {
        DispatchQueue.main.async {
            NSApplication.shared.terminate(self)
        }
        
        return .accepted
    }
}
