//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Juan Carlos Granda Ramos on 21/05/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit

class SnapsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var cerrarSesionTapped: UIBarButtonItem!
    
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
