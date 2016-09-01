//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Claus Höfele on 28.08.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        guard let conversation = activeConversation else { fatalError("Expected an active conversation") }
        
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        let controller: UIViewController
        
        if presentationStyle == .compact {
            let pollListViewController: PollListViewController = instantiateViewController()
            controller = pollListViewController
        } else {
            let pollViewController: PollViewController = instantiateViewController()
            pollViewController.delegate = self
            controller = pollViewController
            
//            let iceCream = IceCream(message: conversation.selectedMessage) ?? IceCream()
//            
//            if iceCream.isComplete {
//                controller = instantiateCompletedIceCreamController(with: iceCream)
//            } else {
//                controller = instantiateBuildIceCreamController(with: iceCream)
//            }
        }
        
        // Remove any existing child controllers.
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        // Embed the new controller.
        addChildViewController(controller)
        
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        controller.didMove(toParentViewController: self)
    }
    
    func instantiateViewController<ViewController>() -> ViewController {
        let name = String(describing: ViewController.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? ViewController else { fatalError("Unable to instantiate initial view controller from storyboard \(name).storyboard") }
        
        return controller
    }
}

extension MessagesViewController: PollViewControllerDelegate {
    func pollViewController(pollViewController: PollViewController, didUpdatePollForm pollForm: PollForm) {
    }
    
    func pollViewController(pollViewController: PollViewController, didCreatePollForm pollForm: PollForm) {
        requestPresentationStyle(.compact)
    }
}
