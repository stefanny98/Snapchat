//
//  SonidoSnapViewController.swift
//  Snapchat
//
//  Created by Mac Tecsup on 13/06/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import AVKit
class SonidoSnapViewController: UIViewController {

    @IBOutlet weak var descripcionTextField: UILabel!
    var player = AVPlayer()
    var snap = Snap()
    override func viewDidLoad() {
        super.viewDidLoad()
        descripcionTextField.text? = snap.descrip
    }
    @IBAction func playTapped(_ sender: Any) {
        let url = NSURL(string: snap.sonidoURL)
        let playerItem = AVPlayerItem(url: url! as URL)
        player = AVPlayer(playerItem:playerItem)
        player.rate = 1.0;
        player.play()
    }
    
}
