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
            self.mostrarAlerta(title: "Usuario no registrado", message: "Si no posee una cuenta registrese en Snapchat", action: "Ok")
            
        }else{
            print("Inicio de sesión exitoso")
            self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            print("Iniciando sesion user: \(self.emailTextField.text!) pass: \(self.passwordTextField.text!)")
        }
        }
    }
    func mostrarAlerta(title:String, message: String, action: String) {
        let alertaGuia = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelok = UIAlertAction(title: action, style: .default, handler: nil)
        alertaGuia.addAction(cancelok)
        present(alertaGuia, animated: true, completion: nil)
    }
    

}

