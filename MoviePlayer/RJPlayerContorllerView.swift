//
//  RJPlayerContorllerView.swift
//  T1
//
//  Created by Me on 2016-04-03.
//  Copyright © 2016 Me. All rights reserved.
//

import Foundation
import UIKit

class RJPlayerContorllerView: UIView {
    
    @IBAction func didClickPreviousButton(sender: UIButton) {
        print("Play previous video")
        hidden = true
    }
    @IBAction func didClickNextButton(sender: UIButton) {
        print("Play next video.")
        hidden = true
    }
    @IBAction func didClickReplayButton(sender: UIButton) {
        print("Replay video was clicked.")
        hidden = true
    }
}