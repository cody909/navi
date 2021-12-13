//
//  ViewController.swift
//  NaviApp
//
//  Created by Cody Mercadante on 11/27/21.
//

import UIKit
import CoreMotion
import AVFoundation

class ViewController: UIViewController {
    let motionManager = CMMotionManager()
    var player: AVAudioPlayer?

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let synthesizer = AVSpeechSynthesizer()
        button1.backgroundColor = .systemRed
        button2.backgroundColor = .systemTeal
        button3.backgroundColor = .systemGreen
        button4.backgroundColor = .systemYellow

        let topStack = UIStackView(arrangedSubviews: [button1, button2])
        topStack.axis = .horizontal
        topStack.distribution = .fillEqually

        let bottomStack = UIStackView(arrangedSubviews: [button3, button4])
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fillEqually

        let stackView = UIStackView(arrangedSubviews: [topStack, bottomStack])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually

        stackView.frame = view.bounds
        stackView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        view.addSubview(stackView);       motionManager.startAccelerometerUpdates()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let data = self.motionManager.accelerometerData {
                let x = data.acceleration.x
                let y = data.acceleration.y
                let z = data.acceleration.z
                let a = sqrt(x*x + y*y + z*z)
                
                print(a)
                if (a > 2){                }
            }
        }

    }
}
