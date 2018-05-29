//
//  CrearViewController.swift
//  Snapchat
//
//  Created by Juan Carlos Granda Ramos on 23/05/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Firebase

class CrearViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func creandoUser(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.email.text!, password: self.pass.text!, completion: {(user,error) in
            print("Intentando crear un usuario: \(String(describing: error))")
            if error != nil {
                self.mostrarAlerta(title: "ERROR!!!", message: "Intentelo de nuevo", action: "Ok")
            }else{
                
                Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                self.mostrarAlerta(title: "Registro exitoso!", message: "Presione volver para iniciar sesión", action: "Ok")
                self.email.isEnabled = false
                self.pass.isEnabled = false
            
            }
        })
    }
    func mostrarAlerta(title:String, message: String, action: String) {
        let alertaGuia = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelok = UIAlertAction(title: action, style: .default, handler: nil)
        alertaGuia.addAction(cancelok)
        present(alertaGuia, animated: true, completion: nil)
    }
    
}
