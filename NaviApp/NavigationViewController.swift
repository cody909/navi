//
//  NavigationViewController.swift
//  NaviApp
//
//  Created by Cody Mercadante on 11/29/21.
//

import UIKit
import AVFoundation
import CoreMotion

class NavigationViewController: UIViewController {
    var player: AVAudioPlayer?
    var dropDetected = false
    @IBOutlet weak var imageView: UIImageView!
    var runCount = 0
    let synthesizer = AVSpeechSynthesizer()
    let motionManager = CMMotionManager()
    var myTimer = Timer()

    @objc func doubleTapped(){
        player?.stop()
        dropDetected = false
        self.startTimer()
    }
    
    func phoneDropped(){
        self.pauseTimer()
        let utterance = AVSpeechUtterance(string: "Drop detected, double tap to dismiss")
//        utterance.voice = AVSpeechSynthesisVoice(language: "fr-FR")
//        utterance.rate = 0.5
        self.synthesizer.speak(utterance)
        let soundURL = Bundle.main.url(forResource: "zapsplat_multimedia_alert_ping_mallet_chime_warm_soft_two_tone_002_73153", withExtension: "mp3")
        do
        {
            try player = AVAudioPlayer(contentsOf: soundURL!)
            player?.numberOfLoops = -1
        } catch {
            print(error)
        }
        player?.play()
    }
    
    func phoneIsDropped() {
        if dropDetected == false{
            dropDetected = true
            phoneDropped()
        }
    }
    
    // Start the timer, which will call the timerTick() method every second.
    func startTimer() {
      myTimer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerTick),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func timerTick() {
        self.runCount += 1
        if self.runCount == 1 {
            let utterance = AVSpeechUtterance(string: "Navigating to room 302. Walk forward 100 feet.")
//            let utterance = AVSpeechUtterance(string: "Avancez de 100 pieds.")
//            utterance.voice = AVSpeechSynthesisVoice(language: "fr-FR")
            self.synthesizer.speak(utterance)
        }
        if self.runCount == 8 {
            let utterance = AVSpeechUtterance(string: "In 50 feet, turn left.")
            self.synthesizer.speak(utterance)
        }
        if self.runCount == 13 {
            let utterance = AVSpeechUtterance(string: "In 10 feet, turn left.")
            self.synthesizer.speak(utterance)
        }
        
        if self.runCount == 18 {
            self.imageView.image = UIImage(named: "left")
            let utterance = AVSpeechUtterance(string: "Turn left.")
            self.synthesizer.speak(utterance)
        }
        if self.runCount == 21 {
            self.imageView.image = UIImage(named: "forward")
            let utterance = AVSpeechUtterance(string: "Walk forward 50 feet.")
            self.synthesizer.speak(utterance)
        }
        if self.runCount == 26 {
            let utterance = AVSpeechUtterance(string: "In 10 feet, turn right.")
            self.synthesizer.speak(utterance)
        }
        if self.runCount == 31 {
            self.imageView.image = UIImage(named: "right")
            let utterance = AVSpeechUtterance(string: "Turn right.")
            self.synthesizer.speak(utterance)
        }
        if self.runCount == 34 {
            self.imageView.image = UIImage(named: "forward")
            let utterance = AVSpeechUtterance(string: "Walk forward 50 feet and the destination will be on your right.")
            self.synthesizer.speak(utterance)
        }
        if self.runCount == 39 {
            self.imageView.image = UIImage(named: "destination")
            let utterance = AVSpeechUtterance(string: "You have reached your destination.")
            self.synthesizer.speak(utterance)
        }
   }

  func pauseTimer() {
    myTimer.invalidate()
  }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        motionManager.startAccelerometerUpdates()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let data = self.motionManager.accelerometerData {
                let x = data.acceleration.x
                let y = data.acceleration.y
                let z = data.acceleration.z
                let a = sqrt(x*x + y*y + z*z)
                
                print(a)
                if (a > 2){
                    self.phoneIsDropped()
                }
            }
        }
        imageView.image = UIImage(named: "forward")
        self.startTimer()
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        self.runCount = 0
        self.pauseTimer()
    }

    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destination.
         Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.pauseTimer()
    }

}
