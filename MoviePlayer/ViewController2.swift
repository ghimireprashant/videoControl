//
//  ViewController2.swift
//  MoviePlayer
//
//  Created by Prashant Ghimire on 7/25/16.
//  Copyright © 2016 Prashant Ghimire. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
class ViewController2: UIViewController {
    
    let AVPlayerVC = AVPlayerViewController()
    var commmentQueuePlayer = AVQueuePlayer()
    var OverlayView = UIView()
    var prevItem:AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomPlayer()
    }
    
    func setupCustomPlayer() {
        AVPlayerVC.view.frame = self.view.frame
        AVPlayerVC.view.sizeToFit()
        AVPlayerVC.showsPlaybackControls = true
        self.view.addSubview(AVPlayerVC.view)
        
        let videoURL: String = "http://cdnapi.kaltura.com/p/11/sp/11/playManifest/entryId/0_6swapj1k/format/applehttp/protocol/http/a.m3u8"
        let firstItemURL: String = "http://cdnapi.kaltura.com/p/11/sp/11/playManifest/entryId/0_2p3957qy/format/applehttp/protocol/http/a.m3u8"
        let secondItemURL: String = "http://cdnapi.kaltura.com/p/11/sp/11/playManifest/entryId/0_buy5xjol/format/applehttp/protocol/http/a.m3u8"
        
        let firstItem = AVPlayerItem(URL: NSURL(string: firstItemURL)! )
        let secondItem = AVPlayerItem(URL: NSURL(string: secondItemURL)! )
        let playerItem = AVPlayerItem(URL: NSURL(string: videoURL)! )
        let items = [firstItem,secondItem,playerItem]
        
        commmentQueuePlayer = AVQueuePlayer(items: items)
        
        commmentQueuePlayer.actionAtItemEnd = .Advance
        AVPlayerVC.player = commmentQueuePlayer
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(stopedPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        addContentOverlayView()
        AVPlayerVC.player?.play()
    }
    
    func addContentOverlayView() {
        
        OverlayView.frame = CGRectMake(0,30,AVPlayerVC.view.bounds.width, 100)
//        OverlayView.hidden = true
        OverlayView.backgroundColor = UIColor ( red: 0.5, green: 0.5, blue: 0.5, alpha: 0.379 )
        
        let btnNext = UIButton(frame:CGRectMake(AVPlayerVC.view.bounds.width - 60,0,60,44))
        btnNext.setTitle(">>", forState:.Normal)
        btnNext.addTarget(self, action:#selector(ViewController2.playNext), forControlEvents:.TouchUpInside)
        OverlayView.addSubview(btnNext)
        
        let btnReplay = UIButton(frame:CGRectMake((AVPlayerVC.view.bounds.width/2)-40,0,80,44))
        btnReplay.setTitle("Replay", forState:.Normal)
        btnReplay.addTarget(self, action:#selector(ViewController2.replayVideo), forControlEvents:.TouchUpInside)
        OverlayView.addSubview(btnReplay)
        
        let btnPrevious = UIButton(frame:CGRectMake(0,0,80,44))
        btnPrevious.setTitle("<<", forState:.Normal)
        btnPrevious.addTarget(self, action:#selector(ViewController2.previousVideo), forControlEvents:.TouchUpInside)
        OverlayView.addSubview(btnPrevious)
        
        let btnComment = UIButton(frame:CGRectMake((AVPlayerVC.view.bounds.width/2)-70,40,140,44))
        btnComment.setTitle("Comments", forState:.Normal)
        btnComment.addTarget(self, action:#selector(ViewController2.openComments), forControlEvents:.TouchUpInside)
        OverlayView.addSubview(btnComment)
        
        AVPlayerVC.view.addSubview(OverlayView);
        
    }
    
    func playNext() {
        prevItem = AVPlayerVC.player?.currentItem
        OverlayView.hidden = true
        commmentQueuePlayer.advanceToNextItem()
    }
    
    func replayVideo() {
        OverlayView.hidden = true
        AVPlayerVC.player?.currentItem?.seekToTime(kCMTimeZero)
        AVPlayerVC.player?.play()
    }
    
    func previousVideo() {
        OverlayView.hidden = true
        if prevItem != AVPlayerVC.player?.currentItem {
            if (commmentQueuePlayer.canInsertItem(prevItem!, afterItem:AVPlayerVC.player?.currentItem)) {
                //commmentQueuePlayer.insertItem(prevItem!, afterItem:AVPlayerVC.player?.currentItem)
                commmentQueuePlayer.replaceCurrentItemWithPlayerItem(prevItem)
                prevItem = AVPlayerVC.player?.currentItem
                replayVideo()
            }
        } else {
            replayVideo()
            //Else display alert no prev video found
        }
    }
    
    func openComments() {
        //Open the comment View/VC
    }
    
    func stopedPlaying() {
        if prevItem == nil {
            prevItem = AVPlayerVC.player?.currentItem
        }
        OverlayView.hidden = false
    }
    
}
