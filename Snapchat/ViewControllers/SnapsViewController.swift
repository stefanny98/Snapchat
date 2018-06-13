//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Mac Tecsup on 23/05/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import AVFoundation
import AVKit
class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var snaps : [Snap] = []
    var player = AVPlayer()
    //var audioPlayer: AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        Database.database().reference().child("usuarios").child(Auth.auth().currentUser!.uid).child("snaps").observe(DataEventType.childAdded, with: {(snapshot) in
            let snap = Snap()
            snap.from = (snapshot.value as! NSDictionary)["from"] as! String
            snap.descrip = (snapshot.value as! NSDictionary)["descripcion"] as! String
            snap.id = snapshot.key
            if snapshot.hasChild("imagenURL"){
            snap.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
            snap.imagenID = (snapshot.value as! NSDictionary)["imagenID"] as! String
            } else {
            snap.sonidoURL = (snapshot.value as! NSDictionary)["sonidoURL"] as! String
            snap.sonidoID = (snapshot.value as! NSDictionary)["sonidoID"] as! String
            }
            self.snaps.append(snap)
            self.tableView.reloadData()
        })
        
        Database.database().reference().child("usuarios").child(Auth.auth().currentUser!.uid).child("snaps").observe(DataEventType.childRemoved, with: {(snapshot) in
            var iterador = 0
            for snap in self.snaps{
                if snap.id == snapshot.key{
                    self.snaps.remove(at: iterador)
                }
                iterador += 1
            }
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0 {
            return 1
        }else {
        return snaps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if snaps.count == 0 {
        cell.textLabel?.text = "No tienes SNAPS 😔"
        }else{
            let snap = snaps[indexPath.row]
            cell.textLabel?.text = snap.from
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        if (snap.imagenURL == ""){
        performSegue(withIdentifier: "sonidosnapsegue", sender: snap)
            /*
            let url = NSURL(string: snap.sonidoURL)
            let playerItem = AVPlayerItem(url: url! as URL)
            player = AVPlayer(playerItem:playerItem)
            player.rate = 1.0;
            player.play()*/
        } else {
        performSegue(withIdentifier: "versnapsegue", sender: snap)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versnapsegue"{
            let siguienteVC = segue.destination as! VerSnapViewController
            siguienteVC.snap = sender as! Snap
        } else if segue.identifier == "sonidosnapsegue" {
            let siguienteVC = segue.destination as! SonidoSnapViewController
            siguienteVC.snap = sender as! Snap
        }
    }
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
