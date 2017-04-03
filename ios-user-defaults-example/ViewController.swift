//
//  ViewController.swift
//  ios-user-defaults-example
//
//  Created by Daniel Spiess on 9/15/15.
//  Copyright © 2015 Daniel Spiess. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var favoriteBeerEdit: UITextField!
    @IBOutlet weak var lastUpdateText: UILabel!
    
    // Constant keys for NSUserDefaults look ups
    static let favoriteBeer = "FAVORITE_BEER"
    static let lastUpdate = "LAST_UPDATE"
    static let profileImage = "PROFILE_IMAGE"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Uncomment these if you want to clear out the saved defaults
        //let appDomain = NSBundle.mainBundle().bundleIdentifier!
        //NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // update labels from NSUserDefaults
        getUserPreferences()
    }
    
// MARK: - Saves/Get NSUserDefaults
    // Launches a UIImagePickerController so the user can select an image from the photo
    // albumn. This doesn't check to see if the application has access, so if things aren't working
    // go into settings and make sure the app has access to photos.
    @IBAction func saveProfilePic(_ sender: UIButton) {
        print("Save Profile")
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Can't get to the photos")
        }
    }

    // Save the user's favorite beer to the NSUserDefaults
    @IBAction func saveBeer(_ sender: UIButton) {
        if (favoriteBeerEdit.text!.characters.count > 0) {
            let prefs = UserDefaults.standard
            prefs.set(favoriteBeerEdit.text, forKey: ViewController.favoriteBeer)
            saveTimestamp()
        }
        dismissKeyboard()
    }
    
    // Save the selected image to NSUserDefaults
    func saveSelectedImage(_ image : UIImage) {
        profileImage.image = image
        
        // Save image to NSUserDefaults
        let prefs = UserDefaults.standard
        let imageData = UIImageJPEGRepresentation(image, 100)
        prefs.set(imageData, forKey: ViewController.profileImage)
        saveTimestamp()

    }
    
    // Saves the timestamp of when the user has made a change to the NSUserDefaults
    func saveTimestamp() {
        let prefs = UserDefaults.standard
        let timestamp = Date()
        prefs.set(timestamp, forKey: ViewController.lastUpdate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = .medium
        lastUpdateText.text = "Last Update:" + dateFormatter.string(from: timestamp)
    }
    
    // Updates the view with the user values already stored in NSUserDefaults
    func getUserPreferences() {
        let prefs = UserDefaults.standard
        
        // Get Favorite beer
        if let beer = prefs.string(forKey: ViewController.favoriteBeer) {
            favoriteBeerEdit.text = beer
        }
        
        // Get profile image
        if let imageData = prefs.object(forKey: ViewController.profileImage) as? Data {
            let storedImage = UIImage.init(data: imageData)
            profileImage.image = storedImage
        }
        
        // Get the last time something was stored
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = .medium
        if let lastUpdateStored = (prefs.object(forKey: ViewController.lastUpdate) as? Date) {
            lastUpdateText.text = "Last Update:" + dateFormatter.string(from: lastUpdateStored)
        } else {
            lastUpdateText.text = "Last Update: Never"
        }
    }
   
// MARK: - UIImagePickerControllerDelegate methods
    // Responder for when the user selects an image. If they hit cancel, this isn't called.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            saveSelectedImage(image)
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            saveSelectedImage(image)
        } else{
            print("Bad things happened")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
// MARK: - Keyboard responders so the keyboard goes away when we're done editing.
    // Dismiss the keyboard when the user is finished editing.
    func dismissKeyboard(){
        // Resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

