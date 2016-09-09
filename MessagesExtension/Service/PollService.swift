//
//  PollService.swift
//  Redpoll
//
//  Created by Claus Höfele on 09.09.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(NSError)
}

class PollService {
    init(participantId: String) {
    }
    
    func createPoll(with pollForm: PollForm, completionHandler: (Result<Poll>)) {
        // POST form
    }
    
    func retrievePolls(completionHandler: (Result<[Poll]>)) {
        // GET polls for id
    }
    
    func updateAnswer(with participantForm: PollParticipantForm, for pollId: String, completionHandler: (Result<Poll>)) {
        // PATCH with participant form as JSON Patch
    }
}
