//
//  ViewController.swift
//  AntonioNunes
//
//  Created by Mariana Lima on 17/06/19.
//  Copyright © 2019 Mariana Lima. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation
class ViewController: UIViewController {
    
    @IBOutlet weak var poow: UIImageView!
    var referenceAttitude:CMAttitude?
    var music: AVAudioPlayer = AVAudioPlayer()
    let motion = CMMotionManager()
    var player: AVAudioPlayer?

    var lastXUpdate = 0
    var lastYUpdate = 0
    var lastZUpdate = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAccelerometers()
        poow.isHidden = true
        
    }
    
    func audio(){
        guard let url = Bundle.main.url(forResource: "audio", withExtension: "m4a") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func startAccelerometers() {
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0
            self.motion.startAccelerometerUpdates()
            
            var timer = Timer(fire: Date(), interval: (1.0 / 60.0), repeats: true,
                              block: { (timer) in
                                if let data = self.motion.accelerometerData {
                                    let x = data.acceleration.x
                                    let y = data.acceleration.y
                                    let z = data.acceleration.z
                                    
                                    print(z)
                                    
                                    if (z>1) {
                                        self.audio()
                                    }
                                }
                                })
                                RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        }
    }
}
