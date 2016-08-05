//
//  ViewController.swift
//  MoviePlayer
//
//  Created by Prashant Ghimire on 7/14/16.
//  Copyright © 2016 Prashant Ghimire. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
//    var playerItem:AVPlayerItem?
//    var player:AVPlayer?
    
        let playerAV = AVPlayerViewController()
        var OverlayView = UIView()
    var player = AVPlayer()
    


    @IBOutlet weak var playbutton: UIButton!
    @IBOutlet weak var movieView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let videoURL = NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
//        let player = AVPlayer(URL: videoURL!)
//        let playerLayer = AVPlayerLayer(player: player)
////        player.actionAtItemEnd = .Advance
//        playerLayer.frame = self.movieView.bounds
//        self.movieView.layer.addSublayer(playerLayer)
//        player.play()
        
//        let url = NSURL(string: "url of the audio or video")
        
        
//        playerItem = AVPlayerItem(URL: videoURL!)
//        player=AVPlayer(playerItem: playerItem!)
//        let playerLayer=AVPlayerLayer(player: player!)
//        playerLayer.frame = movieView.frame
////        playerLayer.frame=CGRectMake(0, 0, 300, 300)
//        self.view.layer.addSublayer(playerLayer)
        
//        playbutton.addTarget(self, action: #selector(ViewController.playButtonTapped(_:)), forControlEvents: .TouchUpInside)
//
//        player.player =  AVPlayer(URL: videoURL!)
////        player.view.frame = self.movieView.frame
//        player.view.sizeToFit()
//        player.showsPlaybackControls = true
////        self.movieView.addSubview(player.view)
//        self.movieView.layer.addSublayer(player)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(stopedPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)\
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.onSelect))
        tapGesture.allowedPressTypes = [NSNumber(integer: UIPressType.Select.rawValue)]
        self.view.addGestureRecognizer(tapGesture);
        
        
        let viewNext = UIView()
        viewNext.backgroundColor = UIColor .redColor()
        viewNext.frame.size = CGSize(width: 100, height: 100)
        viewNext.frame.origin = CGPoint(x: self.view.frame.origin.x/2-50, y:self.movieView.frame.size.height/2+50)
    
        playerAV.view.addGestureRecognizer(tapGesture)
         player = AVPlayer(URL:videoURL!)
        viewNext.center = playerAV.view.center
  
        playerAV.player = player
        playerAV.view.frame = self.movieView.frame
        self.addChildViewController(playerAV)
    
        self.movieView.addSubview(playerAV.view)
        playerAV.didMoveToParentViewController(self)
        
        playerAV.contentOverlayView?.addSubview(viewNext)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.notificationObserver(_:)), name:AVPlayerItemDidPlayToEndTimeNotification , object: player.currentItem)
        
        player.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.New, context: nil)
        _ = UIDevice.beginGeneratingDeviceOrientationNotifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.deviceOrientationDidChange(_:)) , name:
            UIDeviceOrientationDidChangeNotification, object: nil)
        
               addContentOverlayView()
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.onSelect))
//        tapGesture.allowedPressTypes = [NSNumber(integer: UIPressType.Select.rawValue)]
//        self.view.addGestureRecognizer(tapGesture);
//        playerAV.view.addGestureRecognizer(tapGesture)


    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "rate" {
            if let rate = change?[NSKeyValueChangeNewKey] as? Float {
                if rate == 0.0 {
                    print("playback stopped")
                }
                if rate == 1.0 {
                    print("normal playback")
                }
                if rate == -1.0 {
                    print("reverse playback")
                }
            }
        }
        print("you are here")
    }
    override func viewDidAppear(animated: Bool) {
     super.viewDidAppear(animated)


    }
    func onSelect(){
        print("this is select gesture handler method");
    }


    func deviceOrientationDidChange(notify: NSNotification){
        
        let orientation:UIDeviceOrientation = UIDevice.currentDevice().orientation
        switch (orientation) {
        case .LandscapeLeft:
            //self.view.autoresizingMask = (.FlexibleWidth | .FlexibleHeight | .FlexibleLeftMargin | .FlexibleRightMargin | .FlexibleTopMargin | .FlexibleBottomMargin)
            
            
            self.playerAV.view.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
            break
        case .LandscapeRight:
            self.playerAV.view.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
            
            break
        case .PortraitUpsideDown:
            
            break
        case .Portrait:
            playerAV.view.frame = self.movieView.frame
            break
        default:
            print("Unknown orientation: \(orientation)")
        }
        
    }
    
    func addContentOverlayView() {
        
        OverlayView.frame = CGRectMake(0,30,UIScreen.mainScreen().bounds.size.width, 100)
  
        OverlayView.backgroundColor = UIColor ( red: 0.5, green: 0.5, blue: 0.5, alpha: 0.379 )
        
        let btnNext = UIButton(frame:CGRectMake(UIScreen.mainScreen().bounds.size.width - 60,0,60,44))
        btnNext.setTitle(">>", forState:.Normal)
        btnNext.addTarget(self, action:#selector(ViewController.playNext), forControlEvents:.TouchUpInside)
        OverlayView.addSubview(btnNext)
        
        let btnReplay = UIButton(frame:CGRectMake((UIScreen.mainScreen().bounds.size.width/2)-40,0,80,44))
        btnReplay.setTitle("Replay", forState:.Normal)
        btnReplay.addTarget(self, action:#selector(ViewController.replayVideo), forControlEvents:.TouchUpInside)
        OverlayView.addSubview(btnReplay)
        
        let btnPrevious = UIButton(frame:CGRectMake(0,0,80,44))
        btnPrevious.setTitle("<<", forState:.Normal)
        btnPrevious.addTarget(self, action:#selector(ViewController.previousVideo), forControlEvents:.TouchUpInside)
        OverlayView.addSubview(btnPrevious)
        
        let btnComment = UIButton(frame:CGRectMake((UIScreen.mainScreen().bounds.size.width/2)-70,40,140,44))
        btnComment.setTitle("Comments", forState:.Normal)
        btnComment.addTarget(self, action:#selector(ViewController.openComments), forControlEvents:.TouchUpInside)
        OverlayView.addSubview(btnComment)
        
        playerAV.view.addSubview(OverlayView);
        playerAV.contentOverlayView?.addSubview(self.OverlayView)


        
    }
    

    
    func playNext() {
        print("next")

    }
    
    func replayVideo() {
         print("Replay")

    }
    
    func previousVideo() {
         print("previous")

    }
    
    func openComments() {
        //Open the comment View/VC
        print("comment")
    }
    
    func stopedPlaying() {
        print("stop")

    }
    

    
    func notificationObserver(notification:NSNotification) {
        print("finish playing")

    }
    @IBAction func btnPlayAction(sender: AnyObject) {
//        player?.play()
    }



}
//http://stackoverflow.com/questions/33677527/avplayer-with-playback-controls-of-avplayerviewcontroller

//http://stackoverflow.com/questions/29559014/avplayer-custom-button-full-screen-in-swift

