//
//  MultiPlayViewController.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 26/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit



class MultiPlayViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var livesOfGamer: UILives!
    //TODO: I need create a struct which will used to determine singleplay or multyPlay
    @IBOutlet weak var scoreTitleLabelText: UILabel!
    @IBOutlet weak var textLabelText: UILabel!
    @IBOutlet weak var textFieldOfAnswers: UIAnswers!
    @IBOutlet weak var actionButton: UIGSButton!
    @IBOutlet weak var gamersBoard: UIGamers!
    
    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    private let finishGame = "goToFinishGame"
    private let MainMenu = "goToMain"
    private let MenuControllerID = "MenuControllerID"
    
    private let MAX_COUNT_OF_LIVES = 3
    var viewModel: MultiPlayViewModel?
    
    private var timer = Timer()
    private let MAX_SEC = 90
    
    private lazy var seconds = MAX_SEC
    private var isTimerRunning = false
    
    var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(self.back(sender:)))
        
        
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
        textFieldOfAnswers.handlerDone = { [unowned self] in
            self.view.endEditing(true)
        }
        defaultInit()
        viewModel?.lives.value = viewModel?.currentLive()
        prepareRound()
        showKeyboard()
    }
    
    func defaultInit() {
        actionButton.style = .round
        actionButton.text = viewModel?.getButtonTitle()
        actionButton.handler = { [weak self] (button) in
            print("go tapped")
            self?.finishRound()
        }
        gamersBoard.updateUIAnswers(players: (viewModel?.players)!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        observer = NotificationCenter.default.addObserver(forName: .socket, object: nil, queue: .main, using: { [weak self] (notification) in
            let notifier = notification.object as! MultiPlayViewModel
            if notifier.successFinish {
                OperationQueue.main.addOperation {
                    self?.viewModel?.finishGame()
                    self?.viewModel?.lives.value = notifier.currentLive()
                    self?.viewModel?.setActionToFinishGame(action: .WinMulty)
                    self?.performSegue(withIdentifier: (self?.finishGame)!, sender: self)
                }
            } else {
                //TODO: - return score and id other gamers and show their score on the board of gamers
                OperationQueue.main.addOperation {
                    self?.gamersBoard.updateUIAnswers(players: notifier.players)
                }
            }
        })
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
        resetTimer()
        self.viewModel?.stopGame()
        self.performSegue(withIdentifier: MainMenu, sender: self)
    }
    
    func finishRound() {
        timer.invalidate()
        let values: [String] = textFieldOfAnswers.getCurrentTextFromTextFields()
        self.view.endEditing(true)
        
        viewModel?.compareAnswersWithResults(answers: values, rightAnswersHandler: { [unowned self] in
            self.prepareRound()
            }, wrongAnswersHandler: { [unowned self] (live) in
                OperationQueue.main.addOperation {
                    self.viewModel?.lives.value = live
                    self.prepareRound()
                }
                
            }, loseHandler: { [unowned self] (live) in
                OperationQueue.main.addOperation {
                    self.viewModel?.lives.value = live
                    self.viewModel?.setActionToFinishGame(action: .LoseMulty)
                    self.performSegue(withIdentifier: self.finishGame, sender: self)
                }
        })
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            finishRound()
        } else {
            OperationQueue.main.addOperation {
                self.seconds -= 1
                let supportedLanguageCodes = ["en","he"]
                let languageCode = Locale.current.languageCode ?? "en"
                let currentLanguageCode = supportedLanguageCodes.contains(languageCode) ? languageCode : "en"
                if currentLanguageCode == "he" {
                    self.viewModel?.time.value = "\(self.seconds) \(NSLocalizedString("Timer:", comment: ""))"
                } else {
                    self.viewModel?.time.value = "\(NSLocalizedString("Timer:", comment: "")) \(self.seconds)"
                }
                
            }
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
            guard let dvc = root.children.first as? MenuViewController else { print("Not found destinationaViewController")
                return }
            dvc.viewModel = viewModel.goToTheMenu()
        default:
            return
        }
    }
    
    func prepareRound() {
        guard let viewModel = viewModel else { return }
        viewModel.text.value = viewModel.getCurrentText()
        viewModel.title.value = "\(viewModel.currentIndex() + 1) / \(String(describing: viewModel.countOfSongs()))"
        textFieldOfAnswers.updateUIAnswers(count: viewModel.getCurrentCountOfAnswers()!)
        startRound()
    }
    
    func startRound() {
        resetTimer()
        runTimer()
        viewModel?.startGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        guard let observer = observer else { return }
        NotificationCenter.default.removeObserver(observer)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}

extension MultiPlayViewController: UITextViewDelegate {
    
    func showKeyboard() {
        textFieldOfAnswers.becomeFirstResponder()
    }
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        guard let userinfo = notification.userInfo,
            let duration = userinfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let finalRect = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        UIView.animate(withDuration: duration) {
            self.constraintContentHeight.constant = finalRect.height
        }
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let userinfo = notification.userInfo,
            let duration = userinfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let finalRect = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        UIView.animate(withDuration: duration) {
            self.constraintContentHeight.constant -= finalRect.height
        }
    }
}

