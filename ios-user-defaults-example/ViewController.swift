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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // update labels from NSUserDefaults
        getUserPreferences()
    }
    
// MARK: - Saves/Get NSUserDefaults
    // Launches a UIImagePickerController so the user can select an image from the photo
    // albumn. This doesn't check to see if the application has access, so if things aren't working
    // go into settings and make sure the app has access to photos.
    @IBAction func saveProfilePic(sender: UIButton) {
        print("Save Profile")
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            print("Can't get to the photos")
        }
    }

    // Save the user's favorite beer to the NSUserDefaults
    @IBAction func saveBeer(sender: UIButton) {
        if (favoriteBeerEdit.text!.characters.count > 0) {
            let prefs = NSUserDefaults.standardUserDefaults()
            prefs.setObject(favoriteBeerEdit.text, forKey: ViewController.favoriteBeer)
            saveTimestamp()
        }
        dismissKeyboard()
    }
    
    // Save the selected image to NSUserDefaults
    func saveSelectedImage(image : UIImage) {
        profileImage.image = image
        
        // Save image to NSUserDefaults
        let prefs = NSUserDefaults.standardUserDefaults()
        let imageData = UIImageJPEGRepresentation(image, 100)
        prefs.setObject(imageData, forKey: ViewController.profileImage)
        saveTimestamp()

    }
    
    // Saves the timestamp of when the user has made a change to the NSUserDefaults
    func saveTimestamp() {
        let prefs = NSUserDefaults.standardUserDefaults()
        let timestamp = NSDate()
        prefs.setObject(timestamp, forKey: ViewController.lastUpdate)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = .MediumStyle
        lastUpdateText.text = "Last Update:" + dateFormatter.stringFromDate(timestamp)
    }
    
    // Updates the view with the user values already stored in NSUserDefaults
    func getUserPreferences() {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        // Get Favorite beer
        if let beer = prefs.stringForKey(ViewController.favoriteBeer) {
            favoriteBeerEdit.text = beer
        }
        
        // Get profile image
        if let imageData = prefs.objectForKey(ViewController.profileImage) as? NSData {
            let storedImage = UIImage.init(data: imageData)
            profileImage.image = storedImage
        }
        
        // Get the last time something was stored
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = .MediumStyle
        if let lastUpdateStored = (prefs.objectForKey(ViewController.lastUpdate) as? NSDate) {
            lastUpdateText.text = "Last Update:" + dateFormatter.stringFromDate(lastUpdateStored)
        } else {
            lastUpdateText.text = "Last Update: Never"
        }
    }
   
// MARK: - UIImagePickerControllerDelegate methods
    // Responder for when the user selects an image. If they hit cancel, this isn't called.
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: nil)
        saveSelectedImage(image)
    }
    
// MARK: - Keyboard responders so the keyboard goes away when we're done editing.
    // Dismiss the keyboard when the user is finished editing.
    func dismissKeyboard(){
        // Resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

