//
//  SignUpViewController.swift
//  RiddumProject
//
//  Created by Med Kaikai on 2017-04-08.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    
    let picker = UIImagePickerController()
    
    var userStorage: FIRStorageReference!
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self

        let storage = FIRStorage.storage().reference(forURL: "gs://riddum-streaming-app.appspot.com")
        // reference to firebase storage
        
        ref = FIRDatabase.database().reference()
        // reference to firebase database
        
        userStorage = storage.child("users")
        // reference to firebase storage
    }
    

    @IBAction func selectImagePressed(_ sender: Any) {
        
        // presents picker showcasing images from user photo library
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true , completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = image
            nextBtn.isHidden = false
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func nextPressed(_ sender: Any) {
        
        // checks for user input in text fields when next button activated
        guard nameField.text != "", emailField.text != "", passwordField.text != "", confirmPassField.text != "" else {
                print("User not entered any information")
            return
            }
        
        // creates user account in firebase authentication once fields are entered correctly
        if passwordField.text == confirmPassField.text {
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let user = user {
                    
                     let changeRequest = FIRAuth.auth()!.currentUser!.profileChangeRequest()
                     changeRequest.displayName = self.nameField.text!
                     changeRequest.commitChanges(completion: nil)
                    
                    
                     // stores profile image into firebase storage
                     let imageRef = self.userStorage.child("\(user.uid).jpg ")
                    
                     let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                    
                     let uploadTask = imageRef.put(data!, metadata: nil, completion: { (metadata, err) in
                        if err != nil {
                            print(err!.localizedDescription)
                        }
                        
                        // retrieves url of profile image
                        imageRef.downloadURL(completion: { (url, er) in
                            if er != nil {
                                print (er!.localizedDescription)
                            }
                            
                            if let url = url {
                                
                                let userInfo: [String : Any] = ["uid" : user.uid,
                                                                "username" : self.nameField.text!,
                                                                "urlToImage" : url.absoluteString ]
                                
                                // stores value of userInfo array into users into Firebase Database
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                
                                // present tab bar controller
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabVC")
                                
                                self.present(vc, animated: true, completion: nil)
                            }
                        })
                     })
                    uploadTask.resume()
                }
            })
        } else {
            print("Password does not match")
        }
    }
}
