import SwiftUI
import Speech

class JournalEntryViewModel: ObservableObject {
    @Published var journalText = ""
    @Published var isRecording = false
    @Published var showingPermissionAlert = false
    
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    let currentPrompt: String
    private let moodViewModel: MoodViewModel
    
    init(moodViewModel: MoodViewModel, initialPrompt: String? = nil) {
        self.moodViewModel = moodViewModel
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        currentPrompt = initialPrompt ?? StoicPrompts.prompts.randomElement() ?? "What's on your mind?"
        requestSpeechAuthorization()
    }
    
    private func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    break
                case .denied, .restricted, .notDetermined:
                    self.showingPermissionAlert = true
                @unknown default:
                    break
                }
            }
        }
    }
    
    func startRecording(completion: ((String) -> Void)? = nil) {
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            return
        }
        
        // Cancel any existing task
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            // Create recognition request
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else { return }
            recognitionRequest.shouldReportPartialResults = true
            
            // Start recognition task
            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
                guard let self = self else { return }
                
                if let result = result {
                    let text = result.bestTranscription.formattedString
                    if let completion = completion {
                        completion(text)
                    } else {
                        self.journalText += text
                    }
                }
                
                if error != nil {
                    self.stopRecording()
                }
            }
            
            // Configure audio engine
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.recognitionRequest?.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            isRecording = true
            
        } catch {
            print("Audio session setup failed: \(error)")
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        isRecording = false
    }
    
    func saveEntry(mood: MoodType, intensity: Int, content: String? = nil) {
        let entryContent = content ?? journalText
        JournalManager.shared.addEntry(
            mood: mood.toMood,
            intensity: Double(intensity) / 10.0, // Convert 1-10 scale to 0.0-1.0
            content: entryContent
        )
        moodViewModel.loadData() // Refresh the view model's data
    }
} 