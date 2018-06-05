//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Juan Carlos Granda Ramos on 21/05/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Firebase

class SnapsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var snaps:[Snap]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childAdded, with:{(snapshot)in
            let snap = Snap()
            snap.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
            snap.from = (snapshot.value as! NSDictionary)["from"] as! String
            snap.descrip = (snapshot.value as! NSDictionary)["descripcion"] as! String
            snap.imagenID = (snapshot.value as! NSDictionary)["imagenID"] as! String
            snap.id = snapshot.key
            snap.audioURL = (snapshot.value as! NSDictionary)["audioURL"] as! String
            snap.audioID = (snapshot.value as! NSDictionary)["audioID"] as! String
            self.snaps.append(snap)
            self.tableView.reloadData()
        })
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childRemoved, with: {(snapshot) in
            var iterator = 0
            for snap in self.snaps{
                if snap.id == snapshot.key{
                    self.snaps.remove(at: iterator)
                }
                iterator += 1
            }
            self.tableView.reloadData()
        })

    }
    @IBOutlet weak var cerrarSesionTapped: UIBarButtonItem!
    
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0{
            return 1
        }else {
            return snaps.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if snaps.count == 0{
           cell.textLabel?.text = "No tienes Snaps 🤭"
        }else {
            let snap = snaps[indexPath.row]
            cell.textLabel?.text = snap.from
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "versnapsegue", sender: snap)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versnapsegue"{
            let siguienteVC = segue.destination as! VerSnapViewController
            siguienteVC.snap = sender as! Snap
        }
    }
    
}
