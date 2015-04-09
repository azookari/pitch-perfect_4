//
//  PlaySoundViewController.swift
//  PerfectPichApp
//
//  Created by Omar Azookari on 4/5/15.
//  Copyright (c) 2015 Omar Azookari. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    var player:AVAudioPlayer!
    var recordedAudio:FileName!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil)

        player = AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl, error: nil)
        player.enableRate = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlow(sender: AnyObject) {
   
     playAtRate(0.5)
        
    }
    @IBAction func soundEffectChipmunk(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }
    @IBAction func playFast(sender: AnyObject) {
     playAtRate(2.0)
    }
    /*
    function takes in a float value as a rate and plays the audio file
    @arg: rate which represent the rate in which we want to play the sound at 
    return : nil
    */
    func playAtRate(rate: Float) {
        //stop audio engine and reset it
        audioEngine.stop()
        audioEngine.reset()
        //stop any current player and reset start time to 0
        player.stop()
        player.currentTime=0.0
        //set rate to the passed value
        player.rate = rate
        player.play()
        
    }

    @IBAction func stopPlaying(sender: AnyObject) {
        player.stop()
        audioEngine.stop()
        audioEngine.reset()
        player.currentTime=0.0
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        //stop and reset any player and audio engine that might have been started in earlier acitivites
        player.stop()
        audioEngine.stop()
        audioEngine.reset()
        //create audio node and attche it to the engine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        //create a pitch affect and set the pitch to the value that was passed to the function then attache it to the engine
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        //connect the audio player node to the pitch affect node
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        //attach the attached nodes to the engine
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        //play sound 
        audioPlayerNode.play()
    }

    @IBAction func playDarth(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
  

}
