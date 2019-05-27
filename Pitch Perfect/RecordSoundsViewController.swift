//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ranusha samararatne on 2018-02-06.
//  Copyright © 2018 Ranusha De Silva. All rights reserved.
//

import UIKit
import AVFoundation //import statement, the AVFoundation framework contains
// the AVAudioRecorder this way we are able to use functions contain in this framework

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    //AuidoRecorder property, property gives this ViewController the ability to use and reference the audioRecorder in multiple places. This is really useful we will want to reference the audioRecorder in different functions. One for beginning recording and one when we're stopping recording

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "Tap to Record"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
    }



    @IBAction func Record_Audio(_ sender: AnyObject) {
        recordingLabel.text = "Recoding in Progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        
        // Used to get the directory Path, grabs the application's documentDirectory and stores it as a string in the dirPath consant. This gives it a place to store the audio recording which is the documents directory
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        
        // directory path then get combined with a filename for the recording
        let recordingName = "recordedVoice.wav"
        
        // these two lines combine the directory Patha nd the recording name to a full path to our file
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
       // print(filePath!)
        
        //This is needed to record and playback the audio, this part is connected to the Audio Hardware of the system. Since there is only one Adio Hadware on every device, there is only one instance of AVAudioSession. The session by default is shared through all the apps, hence the sharedInstance.
        let session = AVAudioSession.sharedInstance()
        
        //this line sets up the session to record and play audio, it is part of a try statement which uses an ! mark. this means it does not handle any errors if this code fails
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
    
        // telling RecordSoundsViewController to act as AVAudioRecorder's delegate
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func Stop_Recording(_ sender: AnyObject) {
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
             
        }
    }
}

