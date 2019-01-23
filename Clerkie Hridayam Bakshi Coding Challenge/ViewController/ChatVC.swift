//
//  MainApplicationVC.swift
//  Clerkie Hridayam Bakshi Coding Challenge
//
//  Created by hridayam bakshi on 1/22/19.
//  Copyright © 2019 hridayam bakshi. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var messageFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightOutlet: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var messageTableView: UITableView!
    
    var messagesArray: [Message] = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()

        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableview()
        
        messageTextField.delegate = self
        messageTextField.textColor = UIColor.lightGray
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        view.addGestureRecognizer(tap)
    }
    
    // message field and keyboard related methods
    @objc func keyBoardWillShow(_ notification: NSNotification) {
        if let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.4) {
                let tabBarHeight = self.tabBarController?.tabBar.frame.size.height
                self.heightOutlet.constant = rect.height + self.heightOutlet.constant - tabBarHeight!
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textViewDidBeginEditing(_ textField: UITextView) {
        if textField.textColor!.isEqual(UIColor.lightGray) {
            textField.text = nil
            textField.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Say Something"
            textView.textColor = UIColor.lightGray
        }
    }
    
    @objc func dismissKeyboard(textView: UITextView) {
        UIView.animate(withDuration: 0.4) {
            self.heightOutlet.constant = self.messageFieldHeightConstraint.constant + 15
            self.view.layoutIfNeeded()
            self.view.endEditing(true)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var height = textView.contentSize.height
        if height > 80 {
            height = 80
        } else if height < 35 {
            height = 35
        }
        
        // update the constraint
        heightOutlet.constant = heightOutlet.constant - messageFieldHeightConstraint.constant
        messageFieldHeightConstraint.constant = height
        heightOutlet.constant = heightOutlet.constant + height
        self.view.layoutIfNeeded()
    }
    
    // table view related methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        let message = messagesArray[indexPath.row]
        
        if(message.sender == Auth.email) {
            cell.messageBackground.isHidden = true
            cell.sendMessage.isHidden = false
            cell.sendMessageBody.text = message.message
        } else {
            cell.messageBody.text = message.message
            cell.messageBackground.isHidden = false
            cell.sendMessage.isHidden = true
        }
        
        return cell
    }
    
    @IBAction func logout(_ sender: Any) {
        Auth.logout { (status) in
            if status != .notLoggedIn {
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                let alert = UIAlertController(title: "Error", message: "Unable to logout", preferredStyle: .alert)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            } else {
                let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "auth") as! AuthVC
                self.present(mainView, animated: false, completion: nil)
            }
        }
    }
    
    func configureTableview() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        let message = Message()
        message.message = messageTextField.text
        message.sender = Auth.email!
        
        messagesArray.append(message)
        messageTextField.text = nil
        textViewDidChange(messageTextField)
        reload()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.AutoResponse()
        }
        
    }
    
    func AutoResponse() {
        let respMessages = [
            "Hello, I'm a Chat Bot",
            "Interesting",
            "Anything Else I can help you with?",
            "Hope you're having a nice evening",
            "My functionalities are limited",
            "Well I don't know what to say to that",
            "pardon",
        ]
        
        let message = Message()
        message.message = respMessages[Int.random(in: 0 ..< respMessages.count)]
        message.sender = "bot@bot.com"
        messagesArray.append(message)
        reload()
    }
    
    func reload() {
        self.configureTableview()
        self.messageTableView.reloadData()
    }
}
