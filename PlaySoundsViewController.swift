//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Fred Waltman on 3/5/15.
//  Copyright (c) 2015 Fred Waltman. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var error:NSError?
    var recordedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var slowRate:Float!
    var fastRate:Float!
    var highPitch:Float!
    var lowPitch:Float!
    
    @IBOutlet weak var sliderSlow: UISlider!
    @IBOutlet weak var sliderFast: UISlider!
    @IBOutlet weak var sliderHigh: UISlider!
    @IBOutlet weak var sliderLow: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil)
        
        audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl, error: &error)
        audioPlayer.enableRate = true

        slowRate = 0.5
        fastRate = 1.5
        lowPitch = -1000
        highPitch = 1000
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        sliderFast.value = fastRate
        sliderSlow.value = slowRate
        sliderHigh.value = highPitch
        sliderLow.value = lowPitch
    }
    
    @IBAction func playSlow(sender: UIButton) {
        playAudio(slowRate)    }

    @IBAction func playFast(sender: UIButton) {
        playAudio(fastRate)
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(highPitch)
    }
    
    @IBAction func playDarth(sender: UIButton) {
        playAudioWithVariablePitch(lowPitch)
    }
    @IBAction func stopPlay(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func adjustSlow(sender: UISlider) {
        slowRate = sender.value
    }
    
    @IBAction func adjustFast(sender: UISlider) {
        fastRate = sender.value
    }
    
    @IBAction func adjustHigh(sender: UISlider) {
        highPitch = sender.value
    }
    
    @IBAction func adjustLow(sender: UISlider) {
        lowPitch = sender.value
    }
    
    func playAudio(rate : Float) {
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

}
