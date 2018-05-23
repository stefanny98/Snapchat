//
//  iniciarSesionController.swift
//  Snapchat
//
//  Created by Mac Tecsup on 16/05/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class iniciarSesionController: UIViewController {

    @IBOutlet weak var tituloText: UILabel!
    @IBOutlet weak var emailTexField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       tituloText.font = tituloText.font.withSize(48)
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTexField.text!, password: passwordTextField.text!, completion: { (user, error) in
            print("Intentamos iniciar sesion")
            if error != nil {
                print("Tenemos el siguiente error:\(error!)")
                Auth.auth().createUser(withEmail: self.emailTexField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    print("Intentamos crear un usuario")
                    if error != nil{
                        print("Tenemos el siguiente error:\(error!)")
                    }else{
                        print("El usuario fue creado exitosamente")
                        Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                        self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                    }
                })
            }else{
                print("Inicio de sesion exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        })
    }
    
}

