import UIKit
import AVKit
import AVFoundation

public class ModalMoviePlayerViewController: UIViewController {

//    private let fileName: String = ""
    private let loop: Bool = true

    private var item: AVPlayerItem!
    private var player: AVPlayer!
    internal private(set) var playerVC: AVPlayerViewController!
    private var waitingToAutostart = true

//    public init(fileName: String, loop: Bool = true) {
//        self.fileName = fileName
//        self.loop = loop
//        super.init(nibName: nil, bundle: nil)
//    }



    public override func viewDidLoad() {
        super.viewDidLoad()

//        let url = NSBundle.mainBundle().URLForResource(fileName, withExtension: nil)!
                let videoURL = NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")

        item = AVPlayerItem(URL: videoURL!)

        player = AVPlayer(playerItem: item)
        player.actionAtItemEnd = .None
        player.addObserver(self, forKeyPath: "status", options: [], context: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ModalMoviePlayerViewController.didPlayToEndTime), name: AVPlayerItemDidPlayToEndTimeNotification, object: item)

        playerVC = AVPlayerViewController()
        playerVC.player = player
        playerVC.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerVC.showsPlaybackControls = false

        let playerView = playerVC.view
        addChildViewController(playerVC)
        view.addSubview(playerView)
        playerView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        playerView.frame = view.bounds
        playerVC.didMoveToParentViewController(self)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ModalMoviePlayerViewController.handleTap))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    deinit {
        player.pause()
        player.removeObserver(self, forKeyPath: "status")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    func restart() {
        seekToStart()
        play()
    }

    func play() {
        if player.status == .ReadyToPlay {
            player.play()
        } else {
            waitingToAutostart = true
        }
    }

    func pause() {
        player.pause()
        waitingToAutostart = false
    }

    var isPlaying: Bool {
        return (player.rate > 1 - 1e-6) || waitingToAutostart
    }

    private func performStateTransitions() {
        if waitingToAutostart && player.status == .ReadyToPlay {
            player.play()
        }
    }

    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        performStateTransitions()
    }

    @objc func didPlayToEndTime() {
        if isPlaying && loop {
            seekToStart()
        }
    }

    private func seekToStart() {
        player.seekToTime(CMTimeMake(0, 10))
    }

    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !playerVC.showsPlaybackControls {
            playerVC.showsPlaybackControls = true
        }
        super.touchesBegan(touches, withEvent: event)
    }

}

extension ModalMoviePlayerViewController: UIGestureRecognizerDelegate {

    @IBAction func handleTap(sender: UIGestureRecognizer) {
        if !playerVC.showsPlaybackControls {
            playerVC.showsPlaybackControls = true
        }
    }

    /// Prevents delivery of touch gestures to AVPlayerViewController's gesture recognizer,
    /// which would cause controls to hide immediately after being shown.
    ///
    /// `-[AVPlayerViewController _handleSingleTapGesture] goes like this:
    ///
    ///     if self._showsPlaybackControlsView() {
    ///         _hidePlaybackControlsViewIfPossibleUntilFurtherUserInteraction()
    ///     } else {
    ///         _showPlaybackControlsViewIfNeededAndHideIfPossibleAfterDelayIfPlaying()
    ///     }
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if !playerVC.showsPlaybackControls {
            // print("\nshouldBeRequiredToFailByGestureRecognizer? \(otherGestureRecognizer)")
            if let tapGesture = otherGestureRecognizer as? UITapGestureRecognizer {
                if tapGesture.numberOfTouchesRequired == 1 {
                    return true
                }
            }
        }
        return false
    }

}
