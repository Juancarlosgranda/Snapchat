//
//  VerSnapViewController.swift
//  Snapchat
//
//  Created by Juan Carlos Granda Ramos on 28/05/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import AVFoundation


class VerSnapViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    var snap = Snap()
    var player:AVAudioPlayer?
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text? = snap.descrip
        imageView.sd_setImage(with: URL(string: snap.imagenURL))

    }
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
        
        Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete{
            (error) in
            print("Se elimino la imagen correctamente")
        }
        Storage.storage().reference().child("usuarios").child("\(snap.audioID).m4a").delete{
            (error) in
            print("Se elimino el audio correctamente")
        }
    }
    @IBAction func Reproducir(_ sender: Any) {
        let urlstring = snap.audioURL
        let url = NSURL(string: urlstring)
        print("the url = \(url!)")
        downloadFileFromURL(url: url!)
        
    }
    func downloadFileFromURL(url:NSURL){
        
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
            self?.play(url: URL! as NSURL)
        })
        downloadTask.resume()
        
    }
    func play(url:NSURL) {
        print("playing \(url)")
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url as URL)
            self.player?.prepareToPlay()
            self.player?.volume = 4.0
            self.player?.play()
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        
    }

}
