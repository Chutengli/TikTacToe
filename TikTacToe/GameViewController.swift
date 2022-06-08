//
//  GameViewController.swift
//  TikTacToe
//
//  Created by Chuteng Li on 2022/6/6.
//

import UIKit


class GameViewController: UIViewController {
    
    enum Turn {
        case Circle
        case Cross
    }
    
    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    
    var player1Name: String!
    var player2Name: String!
    var gameSize: Int!
    
    var firstTurn = Turn.Circle
    var currentTurn = Turn.Cross
    
    var board: [UIButton] = []
    
    var boardLeft: Int!
    
    var crossState: [UIButton]!
    
    var circleState: [UIButton]!
    
    var winCombination: [[UIButton]]!
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(defaults.string(forKey: "player1")!)
        print(defaults.string(forKey: "player2")!)


        player1Label.text = "Player 1: " + defaults.string(forKey: "player1")!
        player2Label.text = "Player 2: " + defaults.string(forKey: "player2")!
        
        initBoard()
        resetBoard()
        boardLeft = 9
        crossState = []
        circleState = []
        
        winCombination = [[a1, a2, a3], [b1, b2, b3], [c1, c2, c3], [a1, b1, c1], [a2, b2, c2], [a3, b3, c3], [a1, b2, c3], [a3, b2, c1]]
        // Do any additional setup after loading the view.
    }
    
    
    func initBoard() {
        board.append(a1)
        board.append(a2)
        board.append(a3)
        board.append(b1)
        board.append(b2)
        board.append(b3)
        board.append(c1)
        board.append(c2)
        board.append(c3)
    }
    
    func fullBoard() -> Bool {
        return boardLeft == 0
    }
    
    func checkForWin(_ array: [UIButton]) -> Bool {
        for winCombination in winCombination {
            var flag = true

            for button in winCombination {
                if array.contains(button) {
                    continue
                } else {
                    flag = false
                    break
                }
            }
            if (flag) {
                return true
            }
        }
        return false
    }
    

    @IBAction func boardTap(_ sender: UIButton) {
        addToBoard(sender)
        
        if (checkForWin(circleState)) {
            anotherGameQuery("Circle Wins!")
        }
        
        if (checkForWin(crossState)) {
            anotherGameQuery("Cross Wins!")
        }
        
        if (fullBoard()) {
            anotherGameQuery("Draw!")
        }
    }
    
    func anotherGameQuery(_ msg: String) {
        let alertController = UIAlertController(title: msg, message: "Another Game?", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in
            _ = self.navigationController?.popToRootViewController(animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.viewDidLoad()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func resetBoard() {
        for button in board {
            button.setBackgroundImage(nil, for: .normal)
            button.isEnabled = true
        }
        
        crossState = []
        circleState = []
        boardLeft = gameSize * gameSize
    }
    
    func addToBoard(_ sender: UIButton) {
        if (sender.backgroundImage(for: .normal) == nil) {
            if (currentTurn == Turn.Circle) {
                let image = UIImage(named: "cir")
                sender.setBackgroundImage(image, for: .normal)
                currentTurn = Turn.Cross
                circleState.append(sender)
            } else if (currentTurn == Turn.Cross) {
                let image = UIImage(named: "cro")
                sender.setBackgroundImage(image, for: .normal)
                currentTurn = Turn.Circle
                crossState.append(sender)
            }
            sender.isEnabled = false
            boardLeft -= 1
        }
    }
}
