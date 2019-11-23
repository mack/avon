//
//  ViewController.swift
//  avon
//
//  Created by Mackenzie Boudreau on 2019-11-22.
//  Copyright © 2019 Mackenzie Boudreau. All rights reserved.
//

import UIKit
import Speech
import AVKit

class HomeController: UIViewController {
    
    private var recorder: AVAudioRecorder!
    let audioEngine: AVAudioEngine? = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    var textView: UILabel?
    
    var siriWave: SiriWaveView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 100, y: 100, width: 100, height: 100))
        textView?.text = "this is a test"
        textView?.textColor = .white
        self.view.addSubview(textView!)
        

        self.view.backgroundColor = .black
        addPullUpController(SettingsController(), initialStickyPointOffset: 40, animated: true)
        requestSpeechAuthorization()
        
        siriWave = SiriWaveView(frame: CGRect(x: 0, y:(UIScreen.main.bounds.height/2) - 100 , width: UIScreen.main.bounds.width, height: 200))
        
        self.view.addSubview(siriWave)
        setupRecorder()
    }
    
    private func testWithoutMic() {
        var ampl: CGFloat = 1
        let speed: CGFloat = 0.1

        func modulate() {
            ampl = Lerp.lerp(ampl, 1.5, speed)
            self.siriWave.update(ampl * 5)
        }
        
        _ = Timeout.setInterval(TimeInterval(speed)) {
            DispatchQueue.main.async {
                modulate()
            }
        }
    }
    
    private func checkMicPermission() -> Bool {
        var permissionCheck: Bool = false
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            permissionCheck = true
        case AVAudioSession.RecordPermission.denied:
            permissionCheck = false
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                if granted {
                    permissionCheck = true
                } else {
                    permissionCheck = false
                }
            })
        default:
            break
        }
        
        return permissionCheck
    }
    
    /// Recorder Setup Begin
       @objc func setupRecorder() {
           if(checkMicPermission()) {
               startRecording()
           } else {
               print("permission denied")
           }
       }
    
    @objc func updateMeters() {
        var normalizedValue: Float
        recorder.updateMeters()
        normalizedValue = normalizedPowerLevelFromDecibels(decibels: recorder.averagePower(forChannel: 0))
        self.siriWave.update(CGFloat(normalizedValue) * 30)
    }
    
    private func normalizedPowerLevelFromDecibels(decibels: Float) -> Float {
           let minDecibels: Float = -60.0
           if (decibels < minDecibels || decibels.isZero) {
               return .zero
           }
           
           let powDecibels = pow(10.0, 0.05 * decibels)
           let powMinDecibels = pow(10.0, 0.05 * minDecibels)
           return pow((powDecibels - powMinDecibels) * (1.0 / (1.0 - powMinDecibels)), 1.0 / 2.0)
           
       }

    private func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        let recorderSettings = [AVSampleRateKey: NSNumber(value: 44100.0),
                                AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
                                AVNumberOfChannelsKey: NSNumber(value: 2),
                                AVEncoderAudioQualityKey: NSNumber(value: Int8(AVAudioQuality.min.rawValue))]
        
        let url: URL = URL(fileURLWithPath:"/dev/null")
        do {
            
            let displayLink: CADisplayLink = CADisplayLink(target: self,
                                                           selector: #selector(HomeController.updateMeters))
            displayLink.add(to: RunLoop.current,
                            forMode: RunLoop.Mode.common)

            try recordingSession.setCategory(.playAndRecord,
                                             mode: .default)
            try recordingSession.setActive(true)
            self.recorder = try AVAudioRecorder.init(url: url,
                                                     settings: recorderSettings as [String : Any])
            self.recorder.prepareToRecord()
            self.recorder.isMeteringEnabled = true;
            self.recorder.record()
            print("recorder enabled")
        } catch {
            print("recorder init failed")
        }
    }
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    print("authed")
                    self.recordAndRecognizeSpeech()
                case .denied:
                    print("deined")
                case .restricted:
                    print("restricted")
                case .notDetermined:
                    print("not determined")
                @unknown default:
                    return
                }
            }
        }
    }

    func recordAndRecognizeSpeech() {
        guard let node: AVAudioInputNode? = audioEngine?.inputNode else { return }
        let recordingFormat = node!.outputFormat(forBus: 0)
        node?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine?.prepare()
        do {
            try audioEngine?.start()
        } catch {
//            self.sendAlert(title: "Speech Recognizer Error", message: "There has been an audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
//            self.sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not supported for your current locale.")
            return
        }
        if !myRecognizer.isAvailable {
//            self.sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                
                let bestString = result.bestTranscription.formattedString
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String(bestString[indexTo...])
                }
                self.textView!.text = self.textView!.text! + lastString
            } else if let error = error {
//                self.sendAlert(title: "Speech Recognizer Error", message: "There has been a speech recognition error.")
                print(error)
            }
        })
    }
//    func recordAndRecognizeSpeech() {
//        guard let node: AVAudioInputNode? = audioEngine?.inputNode else { return }
//        let recordingFormat = node!.outputFormat(forBus: 0)
//        node?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
//            self.request.append(buffer)
//        }
//    }
}

