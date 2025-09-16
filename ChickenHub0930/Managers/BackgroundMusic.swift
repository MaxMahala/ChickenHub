import AVFoundation
import os.log

final class BackgroundMusic {
    static let shared = BackgroundMusic()

    private var player: AVAudioPlayer?
    private let ud = UserDefaults.standard
    private let log = Logger(subsystem: "chickenhub", category: "audio")

    private var soundOn: Bool { ud.object(forKey: "set.sound") as? Bool ?? true }

    private init() {
        configureSession(playThroughSilentSwitch: true)
    }

    func start(filename: String = "background", ext: String = "mp3", volume: Float = 0.15) {
        guard soundOn else {
            log.debug("Sound disabled -> not starting BGM")
            return
        }
        guard let url = Bundle.main.url(forResource: filename, withExtension: ext) else {
            log.error("Missing \(filename).\(ext) in bundle or not in target membership")
            return
        }
        if player == nil {
            do {
                let p = try AVAudioPlayer(contentsOf: url)
                p.numberOfLoops = -1
                p.volume = max(0, min(1, volume))
                p.prepareToPlay()
                player = p
            } catch {
                log.error("Failed to create AVAudioPlayer: \(error.localizedDescription)")
                return
            }
        }
        player?.play()
        log.debug("BGM started (playing: \(self.player?.isPlaying ?? false, privacy: .public))")
    }

    func stop() {
        player?.stop()
        player?.currentTime = 0
    }

    func pause() { player?.pause() }

    func resume() {
        guard soundOn else { return }
        player?.play()
    }

    func applySetting(isOn: Bool) {
        isOn ? start() : stop()
    }

    func setVolume(_ v: Float, fade: TimeInterval = 0.2) {
        player?.setVolume(max(0, min(1, v)), fadeDuration: fade)
    }

    private func configureSession(playThroughSilentSwitch: Bool) {
        let session = AVAudioSession.sharedInstance()
        do {
            if playThroughSilentSwitch {
                try session.setCategory(.playback, options: [.mixWithOthers])
            } else {
                try session.setCategory(.ambient, options: [.mixWithOthers])
            }
            try session.setActive(true, options: [])
        } catch {
            log.error("Audio session config failed: \(error.localizedDescription)")
        }
    }
    
    func resumeOrStart() {
        if player == nil { start() } else { resume() }
    }
}
