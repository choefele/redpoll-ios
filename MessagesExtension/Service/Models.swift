//
//  Poll.swift
//  Redpoll
//
//  Created by Claus Höfele on 28.08.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import Foundation

struct Poll {
    var id: String
    var title: String
    var options: [PollOption]
    var participants: [PollParticipant]
}

struct PollOption {
    var id: String
    var value: PollOptionValue
}

enum PollOptionValue {
    case string(String)
}

struct PollParticipant {
    var id: String
    var name: String
    var answers: [String: Bool?]
}
