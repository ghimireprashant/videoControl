//
//  AVViewController.swift
//  MoviePlayer
//
//  Created by Prashant Ghimire on 7/27/16.
//  Copyright © 2016 Prashant Ghimire. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class AVViewController: UIViewController {
    var player:AVPlayer?
    var OverlayView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let controller = AVPlayerViewController()
        let videoURL = NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        self.player = AVPlayer(URL: videoURL!)
        controller.player = self.player
        let yourView = controller.view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AVViewController.onCustomTap(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.delegate = self
        yourView.addGestureRecognizer(tapGestureRecognizer)
        
        
        
        OverlayView.frame = CGRectMake(0,30,self.view.frame.size.width, 100)
        
        OverlayView.backgroundColor = UIColor ( red: 0.5, green: 0.5, blue: 0.5, alpha: 0.379 )
        
        let btnNext = UIButton(frame:CGRectMake(self.view.frame.size.width - 60,0,60,44))
        btnNext.setTitle(">>", forState:.Normal)
        btnNext.addTarget(self, action:#selector(ViewController.playNext), forControlEvents:.TouchUpInside)
        OverlayView.addSubview(btnNext)
        
        let btnReplay = UIButton(frame:CGRectMake((self.view.frame.size.width/2)-40,0,80,44))
        btnReplay.setTitle("Replay", forState:.Normal)
        btnReplay.addTarget(self, action:#selector(ViewController.replayVideo), forControlEvents:.TouchUpInside)
        OverlayView.addSubview(btnReplay)
        
        let btnPrevious = UIButton(frame:CGRectMake(0,0,80,44))
        btnPrevious.setTitle("<<", forState:.Normal)
        btnPrevious.addTarget(self, action:#selector(ViewController.previousVideo), forControlEvents:.TouchUpInside)
        OverlayView.addSubview(btnPrevious)
                controller.view.addSubview(OverlayView)
        parentViewController!.modalPresentationStyle = .FullScreen;
        parentViewController!.presentViewController(controller, animated: false, completion: nil)
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
    func onSelect(tap:UITapGestureRecognizer){
        print("this is select gesture handler method");
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
}
extension AVViewController: UIGestureRecognizerDelegate {
    
    func onCustomTap(sender: UITapGestureRecognizer) {
        
        if OverlayView.alpha > 0{
            UIView.animateWithDuration(0.5, animations: {
                self.OverlayView.alpha = 0;
            })
            
        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.OverlayView.alpha = 1;
            })
        }
    }
    
    internal func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if let _touchView = touch.view {
            
            let screenRect:CGRect = UIScreen.mainScreen().bounds
            let screenWidth :CGFloat = screenRect.size.width;
            let screenHeight:CGFloat  = screenRect.size.height;
            
            if _touchView.bounds.height == screenHeight && _touchView.bounds.width == screenWidth{
                return true
            }
            
        }
        return false
    }
    
    internal func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
