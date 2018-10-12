//
//  UIAnswers.swift
//  GuessTheSong
//
//  Created by Ivan Nikitin on 03/09/2018.
//  Copyright © 2018 Иван Никитин. All rights reserved.
//

import UIKit
@IBDesignable
final class UIAnswers: UIView {

    private var textFields: [UITextField] = []
    private var labels: [UILabel] = []
    private var bottomLines: [UIView] = []
//    enum TypeLive: Int {
//        case empty = 0
//        case custom
//    }
//
    var count: Int = 0 {
        didSet { applyStyle(count: count) }
    }
    
//    @IBInspectable var countTextField: Int = 0{
//        didSet{
//            applyStyle(count: countTextField)
//        }
//    }
    
    var handlerDone: (() -> ())?
    
    
    @IBInspectable var countTextField: Int {
        get { return count }
        
        set { count = newValue }
        
    }
    
    
    init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
        applyStyle(count: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        applyStyle(count: 0)
    }
    
    init(frame: CGRect = CGRect.zero, count: Int) {
        super.init(frame: frame)
        commonInit()
        self.count = count
        applyStyle(count: count)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        applyStyle(count: 0)
    }
    
    private func commonInit() {
        clipsToBounds = true
        layer.cornerRadius = 5
        backgroundColor = UIColor.black.withAlphaComponent(0.4)

    }
    
    
    
    private func applyStyle(count: Int) {
        
        for index in 0..<count {
            let answerTextField = UITextField()
            let answerLabel = UILabel()
            let container = UIView()
            let bottomLine = UIView()
            
            let topConstraint = CGFloat((index * 35) + 10 + (10 * index))
            
            addSubview(container)
            container.translatesAutoresizingMaskIntoConstraints = false
            container.topAnchor.constraint(equalTo: topAnchor, constant: topConstraint).isActive = true
            container.heightAnchor.constraint(equalToConstant: 35).isActive = true
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
            container.backgroundColor = .rich

            
            addSubview(answerLabel)
            answerLabel.text = String(describing: index + 1)
            answerLabel.textColor = .rich
            answerLabel.font = UIFont.systemFont(ofSize: 15)
//            answerLabel.textAlignment = .center

            answerLabel.translatesAutoresizingMaskIntoConstraints = false
            answerLabel.topAnchor.constraint(equalTo: topAnchor, constant: topConstraint).isActive = true
            answerLabel.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
//            answerLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
            answerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
            answerLabel.trailingAnchor.constraint(equalTo: container.leadingAnchor, constant: -5).isActive = true

            container.addSubview(answerTextField)
//            answerTextField.attributedPlaceholder = NSAttributedString(string: "Answer # \(index+1)", attributes: [
//                .foregroundColor: UIColor.weakrich
//                ])
            answerTextField.font = UIFont.boldSystemFont(ofSize: 15)
            answerTextField.textColor = .rich
            answerTextField.backgroundColor = UIColor.black
//            answerTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//            answerTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            answerTextField.autocorrectionType = .no
            answerTextField.returnKeyType = UIReturnKeyType.done
            answerTextField.borderStyle = .line
//            answerTextField.clearButtonMode = UITextFieldViewMode.whileEditing
            answerTextField.delegate = self
            answerTextField.borderStyle = .none
            answerTextField.keyboardType = .default
            if #available(iOS 11, *) {
                answerTextField.textContentType = nil
            }

            answerTextField.translatesAutoresizingMaskIntoConstraints = false
            answerTextField.topAnchor.constraint(equalTo: container.topAnchor, constant: 0).isActive = true
//            answerTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
//            answerTextField.widthAnchor.constraint(equalTo: answerTextField.heightAnchor).isActive = true
//            answerTextField.centerYAnchor.constraint(equalTo: answerLabel.centerYAnchor).isActive = true
            answerTextField.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -1).isActive = true
            answerTextField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
            answerTextField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true

//            container.addSubview(bottomLine)
//            bottomLine.backgroundColor = .rich
//            bottomLine.topAnchor.constraint(equalTo: answerTextField.bottomAnchor, constant: 0).isActive = true
//            bottomLine.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
////            bottomLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
//
//            bottomLine.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
//            bottomLine.centerXAnchor.constraint(equalTo: answerTextField.centerXAnchor).isActive = true
//            bottomLine.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
//            bottomLine.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true
//
            textFields.append(answerTextField)
            labels.append(answerLabel)
            bottomLines.append(bottomLine)
            
        }
    }
    
    func getCurrentTextFromTextFields() -> [String] {
        return textFields.map{ $0.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) ?? "" }
    }
    
    func updateUIAnswers(count value: Int) {
        textFields.removeAll()
        labels.removeAll()
        bottomLines.removeAll()
        for view in self.subviews{
            view.removeFromSuperview()
        }
        applyStyle(count: value)
    }
    
    
}
extension UIAnswers: UITextFieldDelegate {
    
    
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        self.handlerPrinting?(textField.text)
//
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handlerDone?()
        return false
        
    }
    
}





