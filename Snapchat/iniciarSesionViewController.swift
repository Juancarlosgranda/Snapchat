//
//  iniciarSesionViewController.swift
//  Snapchat
//
//  Created by Juan Carlos Granda Ramos on 14/05/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class iniciarSesionViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){(user, error) in
        print("Intentando Iniciar sesión")
        if error != nil {
            print("Se presento el siguiente error: \(String(describing: error))")
        }else{
            print("Inicio de sesión exitoso")
        }
        }
    }
    

}

