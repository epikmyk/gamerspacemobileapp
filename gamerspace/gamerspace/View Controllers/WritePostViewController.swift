//
//  WritePostViewController.swift
//  gamerspace
//
//  Created by Michael Morales on 5/2/21.
//

import UIKit

class WritePostViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var postText: UITextView!
    
    @IBAction func exit(_ sender: UIButton) {
        print("exiting")
        dismiss(animated: true, completion: nil)
    }

    var postString: String = ""
    var postWords: [String] = []
    var newWord: String = ""
    var htmlString = ""
    var postReceiverId = Int()
    
    override func viewDidLoad() {
        self.postText.delegate = self
        super.viewDidLoad()
    }
    
    @IBAction func createPost(_ sender: Any) {
        
        let postData = PostResponses()
        
        if let postInput:String = postText.text {
            postData.createPost(post: postInput, html: htmlString, userReceiverId: postReceiverId) { (PostConfirmation) in
                print(PostConfirmation)
            }
        }
    
        dismiss(animated: true) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "writePostModalDismissed"), object: nil)
        }
    }
    
    func textView(_ postContent: UITextView, shouldChangeTextIn  range: NSRange, replacementText text: String) -> Bool {
        postString += text
        
        if text != " " && text != "\n" {
            newWord += text
        } else {
            newWord = ""
        }
        
        if checkURL(url: newWord) {
            postString += "\n"
            
            if let postInput:String = postContent.text {
                postContent.resignFirstResponder()
                let myImage = newWord
                
                htmlString = "<html><body><p style=\"font-size:12pt;\">\(postInput)<img src=\"\(myImage)\" width=\"360\"></p></body></html>"
                postContent.attributedText = htmlString.convertToAttributedFromHTML()
            }
            newWord = " "
          }
          return true
    }
    
    func checkURL(url: String) -> Bool {
        let validImageText: [String] = [".jpeg", ".jpg", ".gif", ".png"]
        for imageText in validImageText {
            if url.contains(imageText) {
                return true
            }
        }
        return false
    }
}
