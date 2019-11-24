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
import Foundation
import Alamofire
import AVFoundation

var player: AVAudioPlayer?
let activators = ["yvonne", "ivan", "van", "even", "avon", "ava"]

class HomeController: UIViewController {
    
    private var recorder: AVAudioRecorder!
    let audioEngine: AVAudioEngine? = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    var request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var lastWord: String?
    var isActiveCommand: Bool?
    var activeCommand: String?
    
    var textView: UILabel?
    
    @IBOutlet weak var siriWave: SiriWaveView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isActiveCommand = false
        activeCommand = ""
        
        textView = UILabel(frame: CGRect(x: 25, y: 100, width: UIScreen.main.bounds.width - 50, height: 100))
        textView?.text = ""
        textView?.numberOfLines = 0
        textView?.lineBreakMode = .byWordWrapping
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
    
    private func resetSpeechRecognition() {
        recognitionTask?.finish()
        recognitionTask = nil
        // stop audio
        request.endAudio()
        request = SFSpeechAudioBufferRecognitionRequest()   // recreates recognitionRequest object.
        audioEngine!.stop()
        audioEngine!.inputNode.removeTap(onBus: 0)
        recordAndRecognizeSpeech()
    }
    
    func debounce(delay: DispatchTimeInterval, queue: DispatchQueue = .main, action: @escaping (() -> Void)) -> () -> Void {
        var currentWorkItem: DispatchWorkItem?
        return {
            currentWorkItem?.cancel()
            currentWorkItem = DispatchWorkItem { action() }
            queue.asyncAfter(deadline: .now() + delay, execute: currentWorkItem!)
        }
    }
    
    private func checkReplace(_ word: String) -> String {
        switch word {
        case "jared":
            return "jarret"
        default:
            return word
        }
    }
    
    private func say(_ word: String) {
        // Line 1. Create an instance of AVSpeechSynthesizer.
            var speechSynthesizer = AVSpeechSynthesizer()
            // Line 2. Create an instance of AVSpeechUtterance and pass in a String to be spoken.
            var speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: word)
            //Line 3. Specify the speech utterance rate. 1 = speaking extremely the higher the values the slower speech patterns. The default rate, AVSpeechUtteranceDefaultSpeechRate is 0.5
            speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 4.0
            // Line 4. Specify the voice. It is explicitly set to English here, but it will use the device default if not specified.
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            // Line 5. Pass in the urrerance to the synthesizer to actually speak.
            speechSynthesizer.speak(speechUtterance)
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
        
        let debounceRestartSpeech = debounce(delay: .milliseconds(3000)) {
            print("reseting speech")
            self.resetSpeechRecognition()
        }

        let debounceReload = debounce(delay: .milliseconds(5000)) {
            // Run command here
            if (self.activeCommand!.contains("text")) {
                if (self.activeCommand!.contains("text")) {
                    let accountSID = "AC0e6d382e50f439bda06432380ca4a933"
                     let authToken = "9b79b21d04f0c145aeb6d5d4a30a032c"

                       let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
                       let parameters = ["From": "19028003422", "To": "19028772889", "Body": "Hello from Swift!"]
                         AF.request(url, method: .post, parameters: parameters).authenticate(username: accountSID, password: authToken)
                         .responseJSON { response in
                           debugPrint(response)
                       }
                } else {
                    self.say("Sorry, I don't know how to text that person yet.")
                }
            } else {
                self.say("Sorry, command not found.")
            }
            
            self.isActiveCommand = false
            self.activeCommand = ""
            self.textView!.text = ""
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { [weak self] (result, error) in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String(bestString[indexTo...])
                }
                let lastStringLower = self!.checkReplace(lastString.lowercased())
                
                if self!.lastWord != lastStringLower {
                    if (self!.checkActivator(word: lastStringLower)) {
                        self!.textView!.text = "avon"
                        self!.playSound()
                        self!.textView!.alpha = 1
                        self!.isActiveCommand = true
                        debounceReload()
                    } else {
                        if (self!.isActiveCommand!) {
                            self!.activeCommand! += lastStringLower + " "
                            self!.textView!.text = self!.activeCommand!
                        } else {
                            self!.textView!.text = lastString
                            self!.textView!.alpha = 0.3
                        }
                    }
                    self!.lastWord = lastStringLower
                } else if let error = error {
                    print(error)
                }
                debounceRestartSpeech()
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
    
    private func playSound() {
        guard let url = Bundle.main.url(forResource: "ConfirmationSound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
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

