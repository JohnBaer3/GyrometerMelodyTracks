//
//  ViewController.swift
//  GyrometerMelodyTracks
//
//  Created by John Baer on 7/1/20.
//  Copyright © 2020 John Baer. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

var goingUp = false
var timer = Timer()
var time: Double = 0


class ViewController: UIViewController {

    @IBOutlet weak var angleGyro: UITextField!
    @IBOutlet weak var xGyro: UITextField!
    @IBOutlet weak var yGyro: UITextField!
    @IBOutlet weak var zGyro: UITextField!
    
    var motion = CMMotionManager()
    var mp3File: AVAudioPlayer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTime()
        
        myGyroscope()
    }
    
    
    func myGyroscope(){
        motion.gyroUpdateInterval = 1
        
        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 0.01
            motion.startDeviceMotionUpdates(to: .main) {
                [weak self] (data, error) in

                guard let data = data, error == nil else {
                    return
                }
                
                let rotation = atan2(data.gravity.x,
                data.gravity.y) - .pi
                                
                self!.angleGyro.text = "angle: \(Double(rotation).rounded(toPlaces: 3))"
                
                
                
                //-5.5 ~ -6 is phone at 90* upwards
                //-4.5 ~ -4.0 is phone extended backwards
                
                print(rotation, " ", goingUp, " ", time)
                
                if rotation > -6 && rotation < -5.5 && time > 0.3{
                    if goingUp == true{
                        self!.playSound()
                    }
                    
                }else if rotation > -4.5 && rotation < -4 && time > 0.3{
                    if goingUp == false{
                        self!.playSound()
                    }
                }
                

            }
        }
    }
    
    
    func playSound(){
        time = 0
        goingUp = !goingUp
        let path = Bundle.main.path(forResource: "drum.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            mp3File = try AVAudioPlayer(contentsOf: url)
            mp3File?.play()
        } catch {
            print("Something happened with audio...")
        }
    }
    
    
    func startTime(){
        timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(self.addTime), userInfo: nil, repeats: true)
    }
    
    @objc func addTime(){
        time += 0.03
    }
}


extension Double{
    func rounded(toPlaces places: Int) -> Double{
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


