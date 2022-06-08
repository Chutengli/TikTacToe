//
//  ViewController.swift
//  TikTacToe
//
//  Created by Chuteng Li on 2022/6/6.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var play1Name: UILabel!
    @IBOutlet weak var play2Name: UILabel!
    @IBOutlet weak var gameSize: UILabel!
    @IBOutlet weak var oldGameButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if (isKeyPresentInUserDefaults(key: "player1") &&
            isKeyPresentInUserDefaults(key: "player2") &&
            isKeyPresentInUserDefaults(key: "size")) {
            oldGameButton.isEnabled = true
        } else {
            oldGameButton.isEnabled = false
        }
        
        if (!isKeyPresentInUserDefaults(key: "player1")) {
            play1Name.text = "PLEASE INPUT PLAYER NAME"
        } else {
            play1Name.text = defaults.string(forKey: "player1")
        }
        
        if (!isKeyPresentInUserDefaults(key: "player2")) {
            play2Name.text = "PLEASE INPUT PLAYER NAME"
        } else {
            play2Name.text = defaults.string(forKey: "player2")
        }
        
        if (!isKeyPresentInUserDefaults(key: "size")) {
            gameSize.text = "PLEASE INPUT SIZE"
        } else {
            gameSize.text = String(defaults.integer(forKey: "size"))

        }
        
        UserDefaults.resetStandardUserDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        if (isKeyPresentInUserDefaults(key: "player1") &&
            isKeyPresentInUserDefaults(key: "player2") &&
            isKeyPresentInUserDefaults(key: "size")) {
            oldGameButton.isEnabled = true
        } else {
            oldGameButton.isEnabled = false
        }
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

    @IBAction func oldGameClicked(_ sender: Any) {
        let size = Int(gameSize.text!)
        let play1 = play1Name.text
        let play2 = play2Name.text
        
        if ((play1!.isEmpty) || (play2!.isEmpty)) {
            self.alertMessage("Must have two players' names!")
            return ;
        }
        
        if ((play1!.count > 10) || (play2!.count > 10)) {
            self.alertMessage("Player's name length cannot exceed 10 characters")
            return ;
        }
        
        if (!self.isValidNumber(string: gameSize.text!)) {

            self.alertMessage("The board size must be 3 or 4!")
            return ;
        }
        
        self.defaults.set(play1, forKey: "player1")
        self.defaults.set(play2, forKey: "player2")
        self.defaults.set(size, forKey: "size")
        
        if (size == 3) {
            self.performSegue(withIdentifier: "showGame", sender: self)
            self.viewDidLoad()
        }
        
        if (size == 4) {
            self.performSegue(withIdentifier: "show4Game", sender: self)
            self.viewDidLoad()
        }
    }
    
    @IBAction func newGameClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Input Play Names", message: "Enter URL", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField{ textField in textField.placeholder = "Player1 Name"}
        alert.addTextField{ textField in textField.placeholder = "Player2 Name"}
        alert.addTextField{ textField in textField.placeholder = "Input Size of board (3 or 4)"}
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create Game", style: .default, handler: { action in
            guard let play1 = alert.textFields?.first?.text else {
                return ;
            }
            
            guard let play2 = alert.textFields?[1].text else {
                return ;
            }
            
            guard let size = alert.textFields?.last?.text else {
                return ;
            }
            
            print(play1, play2, size)
            
            if ((play1.isEmpty) || (play2.isEmpty)) {
                self.alertMessage("Must have two players' names!")
                return ;
            }
            
            if ((play1.count > 10) || (play2.count > 10)) {
                self.alertMessage("Player's name length cannot exceed 10 characters")
                return ;
            }
            
            if (!self.isValidNumber(string: size)) {

                self.alertMessage("The board size must be 3 or 4!")
                return ;
            }
            
            self.defaults.set(play1, forKey: "player1")
            self.defaults.set(play2, forKey: "player2")
            self.defaults.set(size, forKey: "size")
            
            if (Int(size)! == 3) {
                self.performSegue(withIdentifier: "showGame", sender: self)
                self.viewDidLoad()
            } else if (Int(size)! == 4) {
                self.performSegue(withIdentifier: "show4Game", sender: self)
                self.viewDidLoad()
            } else {
                self.alertMessage("The board size must be 3 or 4!")
                return ;
            }
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameViewController {
            destination.player1Name = self.defaults.string(forKey: "player1")
            destination.player2Name = self.defaults.string(forKey: "player2")
            destination.gameSize = self.defaults.integer(forKey: "size")
        }
    }
    
    func alertMessage(_ msg: String) {
        let alertController = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isValidNumber(string: String) -> Bool {
        for char in string {
            let scalarValues = String(char).unicodeScalars
            let charAscii = scalarValues[scalarValues.startIndex].value
            if charAscii < 48 || charAscii > 57 {
                return false
            }
        }
        return true
    }
}

