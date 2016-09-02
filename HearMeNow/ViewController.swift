//
//  ViewController.swift
//  HearMeNow
//
//  Created by Paul Treadwell on 27/08/2016.
//  Copyright © 2016 Paul Treadwell. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    var hasRecording: Bool = false
    var soundPlayer: AVAudioPlayer?
    var soundRecorder: AVAudioRecorder?
    var session: AVAudioSession?
    var soundPath: String?
    
    
    @IBOutlet weak var recordButton: UIButton!

    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func recordPressed(sender: AnyObject) {
        if (soundRecorder?.recording == true){
            soundRecorder?.stop()
            recordButton.setTitle("record", forState: UIControlState.Normal)
            hasRecording = true
            
        }
        
        else {
            session?.requestRecordPermission(){
                granted in
                if (granted == true){
                    
                    self.soundRecorder?.record()
                    self.recordButton.setTitle("Stop", forState: UIControlState.Normal)
                    
                }
                
                else {
                    print("unable to record")
                    
                }
            }
            
        }
        
        
    }
    
    @IBAction func playPressed(sender: AnyObject) {
        if (soundPlayer?.playing) == true {
            soundPlayer?.pause()
            playButton.setTitle ("Play", forState: UIControlState.Normal)
            
        }
        else if (hasRecording == true) {
            let url = NSURL(fileURLWithPath: soundPath!)
            var error: NSError?
            
            try! soundPlayer = AVAudioPlayer (contentsOfURL: url)
            
            if error == nil {
                soundPlayer?.delegate = self
                soundPlayer?.enableRate = true
                soundPlayer?.rate = 0.5
                soundPlayer?.play()
            }
            
            else {
                
                print("Error initializing player \(error)")
            }
            
            playButton.setTitle("Pause", forState: UIControlState.Normal)
            hasRecording = false
            
        }
        
        else if (soundPlayer != nil){
            soundPlayer?.play()
            playButton.setTitle ("Pause", forState: UIControlState.Normal)
            
        }
        
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool)
    {
        recordButton.setTitle("Record", forState: UIControlState.Normal)
    }
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        playButton.setTitle("Play", forState: UIControlState.Normal)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundPath = "\(NSTemporaryDirectory())hearmenow.wav"
        let url = NSURL(fileURLWithPath: soundPath!)
        session = AVAudioSession.sharedInstance()
        
        //this code is different to teh book
                do {
            try session?.setActive(true)
            print("successful")
        }
        catch{
            print("not successful")
        }
        
        
        var error : NSError?
        
        
            try! session?.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
     
        
        //soundRecorder = AVAudioRecorder(URL: url, settings: nil)
        
        
        
        try! soundRecorder = AVAudioRecorder(URL: url, settings: [:] )
        
    
       
        
        
        if(error != nil)
        {
            print("Error initializing the recorder: \(error)")
        }
        soundRecorder?.delegate = self
        soundRecorder?.prepareToRecord()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

