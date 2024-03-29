//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Claus Höfele on 28.08.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import UIKit
import Messages
import Charts

class MessagesViewController: MSMessagesAppViewController {
    var pollForm: PollForm?
    
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
            pollViewController.importFormValues(pollForm: pollForm)
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
    
    private func instantiateViewController<ViewController>(storyboardName: String = String(describing: ViewController.self)) -> ViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? ViewController else { fatalError("Unable to instantiate initial view controller from storyboard \(storyboardName).storyboard") }
        
        return controller
    }
}
