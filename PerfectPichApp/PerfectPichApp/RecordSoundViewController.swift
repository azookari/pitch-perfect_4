//
//  RecordSoundViewController.swift
//  PerfectPichApp
//
//  Created by Omar Azookari on 3/28/15.
//  Copyright (c) 2015 Omar Azookari. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder:AVAudioRecorder!
    @IBOutlet weak var startRecordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    var recordedAudio:FileName!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func recording(sender: AnyObject) {
        //show recording lable and set its value to recording
        recordingLabel.hidden=false
        recordingLabel.text = "recording"
        //show stop recording icon and disable the record icon
        stopRecordingButton.hidden=false
        startRecordingButton.enabled=false
        //get the app document directory
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        //get current date and format it as ddMMyyyy-HHmmss
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        //create the unique file name
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        //create the recorded file path and print it to the console for debuging purpose
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        //crdeate record audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        //start recording
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        //if file is recorded correctly
        if(flag){
            //instintiate the file name class and set its variable to the url and title of the recorded file
            recordedAudio = FileName.init(givenPath:recorder.url,givenTitle:recorder.url.lastPathComponent!)
            //invoke the segue to move to the next view
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio )
        }else{
            println("failed to record sound")
            stopRecordingButton.hidden=false
            startRecordingButton.enabled=true
        }
    }
    override  func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="stopRecording"){
            //create an object of the next view and set the file name data to it's recordedAudio object 
            let playSoundVC:PlaySoundViewController = segue.destinationViewController as PlaySoundViewController
            let data = sender as FileName
            playSoundVC.recordedAudio = data
        }
    }
    @IBAction func stopRecording(sender: AnyObject) {
        audioRecorder.stop()
        recordingLabel.hidden=true
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    override func viewWillAppear(animated: Bool) {
        stopRecordingButton.hidden=true
        startRecordingButton.enabled=true
        recordingLabel.text = "Tap to record"
        recordingLabel.hidden=false
    }

}

