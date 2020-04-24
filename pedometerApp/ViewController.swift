//
//  ViewController.swift
//  pedometerApp
//
//  Created by Yewon Seo on 2020/04/24.
//  Copyright © 2020 Yewon Seo. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var distancesLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var pedometer = CMPedometer()
    var pedometerData = CMPedometerData()
    var numOfSteps:Int! = nil {
        didSet{
            stepsLabel.text = String(format: "%i steps", numOfSteps)
        }
    }
    var timer = Timer()
    var distance = 0.0
    var calories = 0
    var elapsedSeconds = 0.0
    let interval = 0.1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = button.frame.height / 2
        
    }
    
    @IBAction func ButtonClicked(_ sender: UIButton) {
        if button.titleLabel?.text == "Start"{
            button.setTitle("Stop", for: .normal)
            button.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0.15, alpha: 1.0)
            if CMPedometer.isStepCountingAvailable() {
                startTimer()
                pedometer.startUpdates(from: Date()) { (pedometerData, error) in
                    DispatchQueue.main.async {
                        if let pedometerData = pedometerData {
                            self.pedometerData = pedometerData
                            self.numOfSteps = Int(truncating: pedometerData.numberOfSteps)
                        }
                    }
                }
            } else {
                print("Step counting not available")
                
            }
            
        } else {
            pedometer.stopUpdates()
            stopTimer()
            button.setTitle("Start", for: .normal)
            button.backgroundColor = UIColor(red: 0, green: 1.0, blue: 0.15, alpha: 1.0)
        }
        
    }
    
    func startTimer() {
        if !timer.isValid {
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { (timer) in
                self.displayPedometerData()
                self.elapsedSeconds += self.interval
            })
        }
    }
    
    func stopTimer() {
        timer.invalidate()
        displayPedometerData()
    }

    func displayPedometerData() {
        if let numOfSteps = numOfSteps {
            stepsLabel.text = String(format: "%i steps", numOfSteps)
            calories = Int(numOfSteps) * 4
            caloriesLabel.text = String(format: "%i cal", calories)
            timeLabel.text = minutesSeconds(elapsedSeconds)
        }
        
        if let pedDistance = pedometerData.distance {
            distance = pedDistance as! Double
            distancesLabel.text = String(format: "%6.2f", distance)
        }
        
    }
    
    func minutesSeconds(_ seconds: Double) -> String {
        let minutePart = Int(seconds) / 60
        let secondsPart = Int(seconds) % 60
        return String(format: "%02i:%02i", minutePart, secondsPart)
    }
    
}

