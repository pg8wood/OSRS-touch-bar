//
//  ToggleControlStripHandler.swift
//  OSRS Touch Bar
//
//  Created by Patrick Gatewood on 5/28/20.
//  Copyright © 2020 Patrick Gatewood. All rights reserved.
//

import Swifter

struct ToggleControlStripHandler: RequestHandling {
    func handleRequest(request: HttpRequest) -> HttpResponse {
        let queryParameters = request.queryParams
        
        guard let enableControlStripParameter = queryParameters.first(where: { (parameter, value) in parameter == "enabled" }),
            let enableControlStrip = Bool(enableControlStripParameter.1) else {
                
            return .badRequest(.text("Missing required query parameter 'enabled' (boolean)"))
        }
        
        DispatchQueue.main.async {
            if enableControlStrip {
                ScriptRunner.restoreControlStrip()
            } else {
                ScriptRunner.hideControlStrip()
            }
        }
        
        return HttpResponse.ok(.json(""))
    }
}
