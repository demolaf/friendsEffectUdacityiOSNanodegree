//
//  ViewController.swift
//  friendsEffect
//
//  Created by Ademola Fadumo on 29/03/2023.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI(isRecording: false)
    }
    
    func configureUI(isRecording: Bool) {
        if isRecording {
            recordingLabel.text = "Recording in Progress"
            recordButton.tag = 0
            recordButton.setImage(UIImage(named: "Stop.png"), for: .normal)
        } else {
            recordingLabel.text = "Tap to Record"
            recordButton.tag = 1
            recordButton.setImage(UIImage(named: "Record.png"), for: .normal)
        }
    }
    
    // This method takes the responsibility from AVAudioRecorder and will be called when
    // audioRecorder finished saving the recorded file
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            // This navigates/segues to the screen attached to the identifier "stopRecording" in
            // this case PlaySoundsViewController and passes the saved path of the recorded audio file
            performSegue(withIdentifier: "recordingFinished", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    // This method handles and prepares the segue, it's called after the "performSegue" method is
    // fired
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recordingFinished" {
            let playSoundsEffectVC = segue.destination as! PlaySoundsEffectViewController
            let recordedAudioURL = sender as! URL
            playSoundsEffectVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        sender.tag == 1 ? recordAudio() : stopRecording()
        
    }
    
    func stopRecording() {
        configureUI(isRecording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func recordAudio() {
        configureUI(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
    }
}

