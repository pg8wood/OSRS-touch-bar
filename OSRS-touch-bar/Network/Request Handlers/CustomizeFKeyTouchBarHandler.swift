//
//  CustomizeFKeyTouchBarHandler.swift
//  OSRS Touch Bar
//
//  Created by Patrick Gatewood on 5/28/20.
//  Copyright © 2020 Patrick Gatewood. All rights reserved.
//

import Swifter

struct CustomizeFKeyTouchBarHandler: RequestHandling {
    func handleRequest(request: HttpRequest) -> HttpResponse {
        DispatchQueue.main.async {
            TouchBarManager.shared.presentFKeyTouchBarCustomizationWindow()
        }
        
        return HttpResponse.ok(.json(""))
    }
}
