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

        // Pie
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let pieChartView = PieChartView(frame: rect)

        let yVals = [BarChartDataEntry(value: 1, xIndex: 0), BarChartDataEntry(value: 2, xIndex: 1), BarChartDataEntry(value: 3, xIndex: 3)]
        let dataSet = PieChartDataSet(yVals: yVals, label: "Label")
        dataSet.colors = ChartColorTemplates.pastel()
        let xVals = ["1", "2", "3"]
        let data = PieChartData(xVals: xVals, dataSet: dataSet)
        pieChartView.data = data
        pieChartView.holeColor = UIColor.clear
        pieChartView.drawSliceTextEnabled = false
        pieChartView.legend.enabled = false

        UIGraphicsBeginImageContextWithOptions(pieChartView.bounds.size, true, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }

        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.red.cgColor)
            context.fill(pieChartView.bounds)
            pieChartView.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            print()
        }

//        NSUIGraphicsBeginImageContextWithOptions(size: bounds.size, isOpaque || !transparent, NSUIMainScreen()?.nsuiScale ?? 1.0)
//        defer { NSUIGraphicsEndImageContext() }
//
//        if let context = NSUIGraphicsGetCurrentContext() {
//            let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: bounds.size)
//
//            if (isOpaque || !transparent)
//            {
//                // Background color may be partially transparent, we must fill with white if we want to output an opaque image
//                context.setFillColor(NSUIColor.white.cgColor)
//                context.fill(rect)
//
//                if (self.backgroundColor !== nil)
//                {
//                    context.setFillColor((self.backgroundColor?.cgColor)!)
//                    context.fill(rect)
//                }
//            }
//            
//            nsuiLayer?.render(in: context)
//            let image = NSUIGraphicsGetImageFromCurrentImageContext()

    }
    
    private func instantiateViewController<ViewController>() -> ViewController {
        let name = String(describing: ViewController.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? ViewController else { fatalError("Unable to instantiate initial view controller from storyboard \(name).storyboard") }
        
        return controller
    }
}
