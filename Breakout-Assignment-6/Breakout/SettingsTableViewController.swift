//
//  SettingsTableViewController.swift
//  Breakout
//
//  Copyright (c) 2015 private. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var levelSegmentedControl: UISegmentedControl!
    @IBOutlet weak var paddleWidthSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ballCountLabel: UILabel!
    @IBOutlet weak var ballCountStepper: UIStepper!
    @IBOutlet weak var ballSpeedModifierSlider: UISlider!
    @IBOutlet weak var realGravitySwtch: UISwitch!
    @IBOutlet weak var gravityMagnitudeModifierSlider: UISlider!
    
     private let settings = Settings()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ballSpeedModifierSlider.value = settings.ballSpeedModifier
        ballCountStepper.value = Double(settings.maxBalls)
        ballCountLabel.text = "\(Int(ballCountStepper.value))"
        levelSegmentedControl.selectedSegmentIndex = settings.level
        realGravitySwtch.on = settings.realGravity
        gravityMagnitudeModifierSlider.value = settings.gravityMagnitudeModifier
        
        switch(settings.paddleWidth){
        case PaddleWidths.Small: paddleWidthSegmentedControl.selectedSegmentIndex = 0
        case PaddleWidths.Medium: paddleWidthSegmentedControl.selectedSegmentIndex = 1
        case PaddleWidths.Large: paddleWidthSegmentedControl.selectedSegmentIndex = 2
        default: paddleWidthSegmentedControl.selectedSegmentIndex = 1
        }
    }
    
    @IBAction func PaddleWidthChanged(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0: settings.paddleWidth = PaddleWidths.Small
        case 1: settings.paddleWidth = PaddleWidths.Medium
        case 2: settings.paddleWidth = PaddleWidths.Large
        default: settings.paddleWidth = PaddleWidths.Medium
        }
    }
    
    @IBAction func levelChanged(sender: UISegmentedControl) {
        settings.level = sender.selectedSegmentIndex
    }
    
    @IBAction func ballCountChanged(sender: UIStepper){
        settings.maxBalls = Int(ballCountStepper.value)
        ballCountLabel.text = "\(Int(ballCountStepper.value))"
    }
    
    @IBAction func realGravity(sender: UISwitch) {
        settings.realGravity = sender.on
    }
    
    @IBAction func ballSpeedModifierChanged(sender: UISlider){
        settings.ballSpeedModifier = ballSpeedModifierSlider.value
    }
    
    @IBAction func gravityMagnitudeModifierChanged(sender: UISlider) {
        settings.gravityMagnitudeModifier = gravityMagnitudeModifierSlider.value
    }
    private struct PaddleWidths {
        static let Small = 20
        static let Medium = 33
        static let Large = 50
    }
}

