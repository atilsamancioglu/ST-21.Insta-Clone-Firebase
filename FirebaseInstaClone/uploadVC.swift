//
//  SecondViewController.swift
//  FirebaseInstaClone
//
//  Created by Atil Samancioglu on 6.10.2018.
//  Copyright © 2018 Atil Samancioglu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class uploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentText: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadVC.selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)

    }
    
    @objc func selectImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    

    @IBAction func postClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("media")
        
        
        //swift 4
        //if let data = UIImageJPEGRepresentation(imageView.image!, 0.5) {
            
        //}
        
        //swift 4.2
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = NSUUID().uuidString
            
            let mediaImagesRef = mediaFolder.child("\(uuid).jpg")
            mediaImagesRef.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    
                    mediaImagesRef.downloadURL(completion: { (url, error) in
                        if error == nil {
                            
                            //database
                            
                            let imageURL = url?.absoluteString
                            
                            let databaseReference = Database.database().reference()
                            
                            let post = ["image" : imageURL!, "postedby" : Auth.auth().currentUser!.email!, "posttext" : self.commentText.text!, "uuid" : uuid] as [String : Any]
                            databaseReference.child("users").child((Auth.auth().currentUser?.uid)!).child("post").childByAutoId().setValue(post)
                            
                            self.imageView.image = UIImage(named: "image.png")
                            self.commentText.text = ""
                            self.tabBarController?.selectedIndex = 0
                            
                        }
                    })
                    
                    //
                }
            }
            
            
        }
        
        
    }
    
}

