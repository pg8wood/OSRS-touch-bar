//
//  KillTouchBarHandler.swift
//  OSRS Touch Bar
//
//  Created by Patrick Gatewood on 5/28/20.
//  Copyright © 2020 Patrick Gatewood. All rights reserved.
//

import Swifter

struct KillTouchBarHandler: RequestHandling {
    func handleRequest(request: HttpRequest) -> HttpResponse {
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
}
