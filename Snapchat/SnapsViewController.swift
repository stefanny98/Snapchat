//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Mac Tecsup on 23/05/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import Foundation
import UIKit
class SnapsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
