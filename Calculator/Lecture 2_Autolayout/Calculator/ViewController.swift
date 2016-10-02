//
//  ViewController.swift
//  Calculator
//
//  Created by Tatiana Kornilova on 5/7/16.
//  Copyright © 2016 Tatiana Kornilova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var display: UILabel!
    
    @IBOutlet weak var stack0: UIStackView!
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    @IBOutlet weak var stack3: UIStackView!
    @IBOutlet weak var stack4: UIStackView!
    
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping{
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue : Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let methematicalSymbol = sender.currentTitle{
            brain.performOperation(methematicalSymbol)
        }
        displayValue = brain.result
    }
    override func willTransitionToTraitCollection(newCollection: UITraitCollection,
                                                  withTransitionCoordinator coordinator:UIViewControllerTransitionCoordinator) {
        
        super.willTransitionToTraitCollection(newCollection,
                                              withTransitionCoordinator: coordinator)
        configureView(newCollection.verticalSizeClass)
    }
    
    private func configureView(verticalSizeClass: UIUserInterfaceSizeClass) {
        if (verticalSizeClass == .Compact)  {
            stack1.insertArrangedSubview(multiplyButton, atIndex: 0)
            stack2.insertArrangedSubview(divideButton, atIndex: 0)
            stack3.insertArrangedSubview(plusButton, atIndex: 0)
            stack4.insertArrangedSubview(minusButton, atIndex: 0)
            stack0.hidden = true
        } else {
            stack0.hidden = false
            stack0.addArrangedSubview(multiplyButton)
            stack0.addArrangedSubview(divideButton)
            stack0.addArrangedSubview(plusButton)
            stack0.addArrangedSubview(minusButton)
           
        }
    }

}

