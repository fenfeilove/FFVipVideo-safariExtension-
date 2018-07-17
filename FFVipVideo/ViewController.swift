//
//  ViewController.swift
//  FFVipVideo
//
//  Created by francis zhuo on 2018/7/3.
//  Copyright © 2018 zoom. All rights reserved.
//

import Cocoa
import SafariServices

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func onButtonClick(_ sender: Any){
        SFSafariApplication.showPreferencesForExtension(withIdentifier: "us.zoom.FFVipVideo.SafariExtension") { (error) in
            NSLog("\(String(describing: error))")
        }
    }
}

