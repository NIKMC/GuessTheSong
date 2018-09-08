//
//  GamePlayViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 08/08/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit

class GamePlayViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var livesOfGamer: UILives!
    //TODO: I need create a struct which will used to determine singleplay or multyPlay
    @IBOutlet weak var scoreTitleLabelText: UILabel!
    @IBOutlet weak var textLabelText: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textFieldOfAnswers: UIAnswers!
    
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    private let finishGame = "goToFinishGame"
    private let MainMenu = "goToMain"
    private let MenuControllerID = "MenuControllerID"
//    private let loseSinglePlayer = "loseSinglePlayer"
//    private let winMultyPlayer = "winMultyPlayer"
//    private let loseMultyPlayer = "loseMultyPlayer"
    
    private let MAX_COUNT_OF_LIVES = 3
    var viewModel: SinglePlayModelType?
    
    private var timer = Timer()
    private let MAX_SEC = 10
    private lazy var seconds = MAX_SEC
    private var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(self.back(sender:)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        viewModel?.time.bind{ [unowned self] in
            guard let string = $0 else { return }
            self.timerLabel.text = string
        }
        viewModel?.title.bind{ [unowned self] in
            guard let string = $0 else { return }
            self.scoreTitleLabelText.text = string
        }
        viewModel?.text.bind{ [unowned self] in
            guard let string = $0 else { return }
            self.textLabelText.text = string
        }
        viewModel?.lives.bind{ [unowned self] in
            guard let value = $0 else { return }
            self.livesOfGamer.setLives(value)
        }
        textFieldOfAnswers.updateUIAnswers(count: 0)
        viewModel?.lives.value = viewModel?.currentLive()
        prepareRound()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func runTimer() {
        if isTimerRunning == false {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
            isTimerRunning = true
        }
    }
    
    func resetTimer() {
        timer.invalidate()
        seconds = MAX_SEC
        isTimerRunning = false
    }
    
    @objc func back(sender: AnyObject) {
//        guard(navigationController?.popToRootViewController(animated: true)) != nil
//            else {
//                print("No view controllers to pop off")
//                return
//        }
        self.viewModel?.stopGame()
        self.performSegue(withIdentifier: MainMenu, sender: self)
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            let values: [String] = textFieldOfAnswers.getCurrentTextFromTextFields()
            guard let action = self.viewModel?.getBehaviour() else {
                print("Didn't find behaviour")
                return }
            //TODO: - delete this code when Iskandar change response of finishGame Request
            self.viewModel?.setActionToFinishGame(action: .WinSingle)
            self.viewModel?.stopGame()
            self.performSegue(withIdentifier: self.finishGame, sender: self)
            
//            TODO: - add this code when Iskandar change response of finishGame Request
//            viewModel?.compareAnswersWithResults(answers: values, rightAnswersHandler: { [unowned self] in
//                self.prepareRound()
//            }, wrongAnswersHandler: { [unowned self] (live) in
//                self.viewModel?.lives.value = live
//                self.prepareRound()
//            }, winHandler: { [unowned self] (live) in
//                self.viewModel?.lives.value = live
//                switch action {
//                case .Single:
//                    self.viewModel?.setActionToFinishGame(action: .WinSingle)
//                    self.performSegue(withIdentifier: self.finishGame, sender: self)
//                case .Multy:
//                    self.viewModel?.setActionToFinishGame(action: .WinMulty)
//                    self.performSegue(withIdentifier: self.finishGame, sender: self)
//                }
//            }, loseHandler: { [unowned self] (live) in
//                self.viewModel?.lives.value = live
//                switch action {
//                case .Single:
//                    self.viewModel?.setActionToFinishGame(action: .LoseSingle)
//                    self.performSegue(withIdentifier: self.finishGame, sender: self)
//                case .Multy:
//                    self.viewModel?.setActionToFinishGame(action: .LoseMulty)
//                    self.performSegue(withIdentifier: self.finishGame, sender: self)
//                }
//
//            })
        } else {
            seconds -= 1
            viewModel?.time.value = "Timer: \(seconds)"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        guard let viewModel = viewModel else { return }
        
        switch identifier {
        case finishGame:
            guard let dvc = segue.destination as? FinishGameViewController else { return }
            dvc.viewModel = viewModel.goToFinishGame()
        case MainMenu:
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let root = appDelegate.switchRootViewController(nameStoryBoard: "MenuScreen", idViewController: MenuControllerID)
            guard let dvc = root.childViewControllers.first as? MenuViewController else { print("Not found destinationaViewController")
                return }
           
//            let storyboard = UIStoryboard(name: "MenuScreen", bundle: nil)
//            guard let navigationVC = storyboard.instantiateInitialViewController() as? UINavigationController else {
//                print("not found UINavigationController of MenuViewController")
//                return
//
//            }
//            guard let dvc = navigationVC.topViewController as? MenuViewController else {
//                print("not found menuview controller")
//                return
//            }
            dvc.viewModel = viewModel.goToTheMenu()
        default:
            return
        }
    }
    
    func commonInit() {
        containerView.backgroundColor = UIColor.clear

    }
    
    func prepareRound() {
        guard let viewModel = viewModel else { return }
        viewModel.text.value = viewModel.getCurrentText()
        viewModel.title.value = "\(viewModel.currentIndex() + 1) / \(String(describing: viewModel.countOfSongs()))"
        textFieldOfAnswers.updateUIAnswers(count: viewModel.getCurrentCountOfAnswers()!)
        startRound()
    }
    
    func prepareAnswersOfSong() {
        
    }
    
    func startRound() {
        resetTimer()
        runTimer()
        viewModel?.startGame()
    }

     override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}

extension GamePlayViewController: UITextViewDelegate {
    
    //    func showKeyboard() {
    //        emailInputView.becomeFirstResponder()
    //    }
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        guard let userinfo = notification.userInfo,
            let duration = userinfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let finalRect = userinfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        UIView.animate(withDuration: duration) {
            self.constraintContentHeight.constant += finalRect.height
        }
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let userinfo = notification.userInfo,
            let duration = userinfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let finalRect = userinfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        UIView.animate(withDuration: duration) {
            self.constraintContentHeight.constant -= finalRect.height
        }
    }
}

