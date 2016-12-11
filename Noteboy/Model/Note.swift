//
//  Note.swift
//  Noteboy
//
//  Created by Lubarda, Miso on 27/11/2016.
//  Copyright © 2016 Noteboy. All rights reserved.
//

import Foundation

struct Note {
    enum State {
        case Editing, Selected, None
    }

    var state: State = .None
    var text: String = ""
}
