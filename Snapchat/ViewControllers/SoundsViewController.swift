//
//  SoundsViewController.swift
//  Snapchat
//
//  Created by Mac Tecsup on 13/06/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import AVFoundation
class SoundsViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var contactoButton: UIButton!
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var audioURL : URL?
   var sonidoID = NSUUID().uuidString
    override func viewDidLoad() {
        super.viewDidLoad()
         setupRecorder()
        contactoButton.isEnabled = false
    }
    
    func setupRecorder(){
        do{
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, sonidoID+".m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            print("****************")
            print(audioURL!)
            print("****************")
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] =  Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        } catch let error as NSError {
            print(error)
        }
    }
    @IBAction func recordTapped(_ sender: Any) {
        if audioRecorder!.isRecording{
            audioRecorder?.stop()
            recordButton.setTitle("Record", for: .normal)
            contactoButton.isEnabled = true
        } else {
            audioRecorder?.record()
            recordButton.setTitle("Stop", for: .normal)
        }
    }
    @IBAction func contactoTapped(_ sender: Any) {
        contactoButton.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("sonidos")
        let sonidoData = NSData(contentsOf: audioURL!) as Data?
        imagenesFolder.child(sonidoID+".m4a").putData(sonidoData!, metadata: nil, completion: {(metadata, error) in
            print("Intentando subir el sonido")
            if error != nil {
                print("Ocurrió un error:\(error!)")
            }else{
            self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: metadata?.downloadURL()!.absoluteString)
            }
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.tipo = "sonido"
        siguienteVC.sonidoURL = sender as! String
        siguienteVC.descrip = descripcionTextField.text!
        siguienteVC.sonidoID = sonidoID
    }
    
}
