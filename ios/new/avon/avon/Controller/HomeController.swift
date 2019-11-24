//
//  ViewController.swift
//  avon
//
//  Created by Mackenzie Boudreau & Jarret Terrio on 2019-11-22.
//  Copyright © 2019 Mackenzie Boudreau. All rights reserved.
//

import UIKit
import Speech
import AVKit

let activators = ["yvonne", "ivan", "van", "even", "avon", "ava"]

class HomeController: UIViewController {
    
    private var recorder: AVAudioRecorder!
    let audioEngine: AVAudioEngine? = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var lastWord: String?
    
    var textView: UILabel?
    
    @IBOutlet weak var siriWave: SiriWaveView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 50, y: 100, width: 100, height: 100))
        textView?.text = ""
        textView?.textAlignment = .center
        textView?.font = UIFont.systemFont(ofSize: 20)
        textView?.alpha = 0.5
        textView?.textColor = .white
        self.view.addSubview(textView!)
        
        lastWord = ""

        self.view.backgroundColor = .black
        addPullUpController(SettingsController(), initialStickyPointOffset: 40, animated: true)
        requestSpeechAuthorization()
    
        setupRecorder()
    }
    
    private func checkActivator(word: String) -> Bool {
        for activator in activators {
            if word.contains(activator) {
                return true
            }
        }
        return false
    }
    
    private func requestSpeechAuthorization() {
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

    private func recordAndRecognizeSpeech() {
        guard let node: AVAudioInputNode? = audioEngine?.inputNode else { return }
        let recordingFormat = node!.outputFormat(forBus: 0)
        node?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine?.prepare()
        do {
            try audioEngine?.start()
        } catch {
            return print(error)
        }

        guard let myRecognizer = SFSpeechRecognizer() else {
            return
        }

        if !myRecognizer.isAvailable {
            return
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { [weak self] (r, error) in
            let result = r!
//            print(lastWord)
//            print(result.bestTranscription.formattedString)
            if result != nil && self!.lastWord != result.bestTranscription.formattedString {
                let bestString = result.bestTranscription.formattedString
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String(bestString[indexTo...])
                }
                
                
                let lastStringLower = lastString.lowercased()
                if (self!.checkActivator(word: lastStringLower)) {
                    self!.textView!.text = "avon"
                    self!.textView!.alpha = 1
                    print("this is a print)")
                } else {
                    self!.textView!.text = lastString
                    self!.textView!.alpha = 0.5
                }
                self!.lastWord = bestString
            } else if let error = error {
                print(error)
            }
        })
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
                print("permission granted")
               startRecording()
           } else {
               print("permission denied")
           }
       }
    
    @objc func updateMeters() {
        var normalizedValue: Float
        recorder.updateMeters()
        normalizedValue = normalizedPowerLevelFromDecibels(decibels: recorder.averagePower(forChannel: 0))
        self.siriWave.update(min(CGFloat(normalizedValue) * 30, 1))
    }
    
    private func normalizedPowerLevelFromDecibels(decibels: Float) -> Float {
           let minDecibels: Float = -60.0
           if (decibels < minDecibels || decibels.isZero) {
               return .zero
           }
           
           let powDecibels = pow(10.0, 0.05 * decibels)
           let powMinDecibels = pow(10.0, 0.05 * minDecibels)
        return pow((powDecibels - powMinDecibels) * (1.0 / (1.0 - powMinDecibels)), 2.0)
           
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
}

