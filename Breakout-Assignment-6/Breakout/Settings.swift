//
//  Settings.swift
//  Breakout
//
//  Copyright (c) 2015 private. All rights reserved.
//

import Foundation

class Settings {
   struct Defaults {
        static let Level = 2
        static let BallSpeedModifier = Float(0.05)
        static let MaxBalls: Int = 3
        static let PaddleWidth = PaddleWidthPercentage.Large
        static let ControlWithTilt = false
        static let RealGravity = false
        static let GravityMagnitudeModifier = Float(0.00)
    }
    
    private struct Keys {
        static let Level = "Settings.Level"
        static let BallSpeedModifier = "Settings.BallSpeedModifier"
        static let MaxBalls = "Settings.BallCount"
        static let PaddleWidth = "Settings.PaddleWidth"
        static let RealGravity = "Settings.RealGravity"
        static let GravityMagnitudeModifier = "Settings.GravityMagnitudeModifier"
    }
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // gameplay settings
    
    var level: Int {
        get { return (userDefaults.objectForKey(Keys.Level) as? Int) ?? Defaults.Level}
        set { userDefaults.setObject(newValue, forKey: Keys.Level) }
    }
    
    var ballSpeedModifier: Float {
        get { return userDefaults.objectForKey(Keys.BallSpeedModifier) as? Float ?? Defaults.BallSpeedModifier}
        set { userDefaults.setFloat(newValue, forKey: Keys.BallSpeedModifier) }
    }
    
    var maxBalls: Int
    {
        get { return userDefaults.objectForKey(Keys.MaxBalls)  as? Int ?? Defaults.MaxBalls }
        set { userDefaults.setInteger(newValue, forKey: Keys.MaxBalls) }
    }
    
    var paddleWidth: Int
    {
        get{ return userDefaults.objectForKey(Keys.PaddleWidth) as? Int ?? Defaults.PaddleWidth}
        set{ userDefaults.setInteger(newValue, forKey: Keys.PaddleWidth)}
        
    }
    
    var realGravity: Bool
        {
        get{ return userDefaults.objectForKey(Keys.RealGravity)  as? Bool ?? Defaults.RealGravity}
        set{ userDefaults.setBool(newValue, forKey: Keys.RealGravity)}
    }
    
    var gravityMagnitudeModifier: Float
        {
        get { return userDefaults.objectForKey(Keys.GravityMagnitudeModifier) as? Float ?? Defaults.GravityMagnitudeModifier}
        set { userDefaults.setFloat(newValue, forKey: Keys.GravityMagnitudeModifier) }

    }

}

struct PaddleWidthPercentage {
    static let Small = 20
    static let Medium = 35
    static let Large = 50
}
