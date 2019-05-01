//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mohamed Mohsen on 4/5/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    //MARK: Enums
    enum segueIdentifier: String {
        case PlaybackSounds = "stopRecording"
    }
    //MARK: Internal Local Attributes
    var audioRecorder: AVAudioRecorder!
    
    //MARK: Outlets
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var tapToRecordLbl: UILabel!
    
    //MARK: Storyboard Functions
    /**fired by pressing the recording button.*/
    @IBAction func recordAudio() {
        stopRecordingView()
        let urlFilePath = constructURLFor(fileName: "recordingVoice.wav")
        //print(urlFilePath)
        recordVoice(savedLocation: urlFilePath)
    }
    
    /**
     fired by pressing the stop recording button.
     */
    @IBAction func stopRecording() {
        recordingView()
        stopRecordingVoice()
    }

    //MARK: ViewController Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recordingView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier.PlaybackSounds.rawValue{
            if let playSoundsVC = segue.destination as? PlaySoundsViewController{
                if let urlFilePath = sender as? URL{
                    playSoundsVC.recordedAudioURL = urlFilePath
                }
            }
        }
    }
    
    //MARK: AVAudioRecorderDelegate Override Functions
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else {
            print("Audio dosen't saved successfully.")
        }
    }
    
    //MARK: Internal Local Methods
    /**
    showing the recording view.
     
    stop recording button is disabled, record button is enabled and tap to record text is set to "Tap to Record" as it is the original view
     */
    func recordingView(){
        self.stopRecordingBtn.isEnabled = false
        self.recordBtn.isEnabled = true
        self.tapToRecordLbl.text = "Tap to record..."
    }
    
    /**
     showing the recording view.
     
     stop recording button is enabled, record button is disabled and tap to record text is set to "Recording..."
     */
    func stopRecordingView(){
        self.recordBtn.isEnabled = false
        self.stopRecordingBtn.isEnabled = true
        self.tapToRecordLbl.text = "Recording..."
    }
    
    /**
     construct URL Path for the sending file name.
     
     - get the directory path of the user Document Directory.
     - append on it the file name.
     - convert it to be suitable as a URL.
     - return the constructed URL.
     */
    func constructURLFor(fileName: String) -> URL{
        var directoryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String //get the directory path of the user Document Directory
        directoryPath += "/" + fileName //fullPath
        return URL(fileURLWithPath: directoryPath)
    }
    
    /**
     start recording the audio.
     - set the file path of this recording audio to the sending - urlFilePath
     - open session for recording.
     - prepare the environment for the recording.
     - start recrding.
     */
    func recordVoice(savedLocation urlFilePath: URL) {
        let session = AVAudioSession.sharedInstance()
        //try to set the category as a play & record if not throw an exception with crashing the app
        //try! will crash if it thorws an exception unlike the try? it will do nothing by ignoring the returned exceptions to nil
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        //url
        //The file system location to record to.
        //The file type to record to is inferred from the file extension included in this parameter’s value.
        try! audioRecorder = AVAudioRecorder(url: urlFilePath, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true //what this ?!
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    /**
     stop recording the audio.
     - close the opened session for recording.
     - stop recrding.
     */
    func stopRecordingVoice() {
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
}

