//
//  MessagesViewController+PollViewControllerDelegate.swift
//  Redpoll
//
//  Created by Claus Höfele on 01/09/16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import Foundation
import Messages
import Charts

extension MessagesViewController: PollViewControllerDelegate {
    func pollViewController(pollViewController: PollViewController, didUpdatePollForm pollForm: PollForm) {
    }

    func pollViewController(pollViewController: PollViewController, didCreatePollForm pollForm: PollForm) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }

        let message = composeMessage(with: pollForm, caption: "Caption", session: conversation.selectedMessage?.session)

        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }

        dismiss()
    }

    private func composeMessage(with pollForm: PollForm, caption: String, session: MSSession? = nil) -> MSMessage {
        let message = MSMessage(session: session ?? MSSession())

        //        var components = URLComponents()
        //        components.queryItems = iceCream.queryItems
        //        message.url = components.url!

        let layout = MSMessageTemplateLayout()
        //        layout.image = iceCream.renderSticker(opaque: true)
        layout.caption = caption
        message.layout = layout

        return message
    }

    private func renderPollForm(pollForm: PollForm) {
        
    }
}
