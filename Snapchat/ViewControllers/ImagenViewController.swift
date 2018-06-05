//
//  ImagenViewController.swift
//  Snapchat
//
//  Created by Juan Carlos Granda Ramos on 21/05/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class ImagenViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    var audioID = NSUUID().uuidString
    var urlaudio = ""
    
    //Variables para subir el audio:
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    
    var audiorecorder:AVAudioRecorder?
    var audioPlayer:AVAudioPlayer?
    
    //implementacion de variables para el tiempo de duracion del audio
    var audioUrl: URL?
    var seconds = 00
    var timer = Timer()
    var isTimerrunning = false
    var audioDuracionFin:TimeInterval?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        imagePicker.delegate = self
        playButton.isEnabled = false
        elegirContactoBoton.isEnabled = false
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirContactoBoton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func mediaTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func elegirContactoTapped(_ sender: Any) {
       // performSegue(withIdentifier: "seleccionarContactoSegue", sender: nil)
        elegirContactoBoton.isEnabled = false
        //Subiendo la imagen
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = UIImageJPEGRepresentation(imageView.image!,0.1)!
        let imagen = imagenesFolder.child("\(imagenID).jpg")
        //Subiendo el audio
        
        let audioFolder = Storage.storage().reference().child("audios")
        let audioData = NSData(contentsOf:audioUrl!)!
        let audio = audioFolder.child("\(audioID).m4a")
        
        
        audio.putData(audioData as Data, metadata:nil){(metadata, error) in
            if error != nil {
                self.mostrarAlerta(title: "Error", message: "Se produjo un error al subir el audio. Vuelva a intentarlo :c", action: "Cancelar")
                self.elegirContactoBoton.isEnabled = true
                print("Ocurrio un error al subir imagen: \(String(describing: error))")
                return
            }else{
                audio.downloadURL(completion:{(url, error) in
                    guard url != nil else{
                        self.mostrarAlerta(title: "Error", message: "Se produjo un error al obtener la informacion del audio", action: "Cancelar")
                        self.elegirContactoBoton.isEnabled = true
                        print("Ocurrio un error al obtener informacion del audio \(String(describing: error))")
                        return
                    }
                    
                    self.urlaudio = (url?.absoluteString)!
                })
            }
        }
        
        imagen.putData(imagenData, metadata:nil){(metadata, error) in
            if error != nil {
                self.mostrarAlerta(title: "Error", message: "Se produjo un error al subir la imagen. Vuelva a intentarlo :c", action: "Cancelar")
                self.elegirContactoBoton.isEnabled = true
                print("Ocurrio un error al subir imagen: \(String(describing: error))")
                return
            }else{
                imagen.downloadURL(completion:{(url, error) in
                    guard url != nil else{
                        self.mostrarAlerta(title: "Error", message: "Se produjo un error al obtener la informacion de imagen", action: "Cancelar")
                        self.elegirContactoBoton.isEnabled = true
                        print("Ocurrio un error al obtener informacion de imagen \(String(describing: error))")
                        return
                        }
                   
                self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url?.absoluteString)
                    })
            }
        }
    }
    
    func mostrarAlerta(title:String, message: String, action: String) {
        let alertaGuia = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelok = UIAlertAction(title: action, style: .default, handler: nil)
        alertaGuia.addAction(cancelok)
        present(alertaGuia, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! EligirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.descrip = descripcionTextField.text!
        siguienteVC.imagenID = imagenID
        siguienteVC.audioURL = self.urlaudio
        siguienteVC.audioID = audioID
        
    }
    
    //Para grabar el audio y guardarlo
    
    func setupRecorder(){
        
        do{
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true).first!
            let pathComponents = [basePath,"audio.m4a"]
            audioUrl = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("**************************")
            print(audioUrl!)
            print("**************************")
            
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            audiorecorder = try AVAudioRecorder(url: audioUrl!, settings: settings)
            audiorecorder!.prepareToRecord()
            
        }catch let error as NSError{
            print(error)
        }
    }
    func runTimmer () {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector (ImagenViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer () {
        seconds += 1
        timeLbl.text = timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
    @IBAction func recordTapped(_ sender: Any) {
        if audiorecorder!.isRecording{
            audiorecorder?.stop()
            recordButton.setTitle("Grabar", for: .normal)
            playButton.isEnabled = true
            elegirContactoBoton.isEnabled = true
            timer.invalidate()
        }else{
            audiorecorder?.record()
            recordButton.setTitle("Detener", for: .normal)
            playButton.isEnabled = false
            runTimmer()
        }
    }
    
    @IBAction func playTapped(_ sender: Any) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: audioUrl!)
            audioPlayer!.play()
        }catch{}
    }
    
    
    
}
