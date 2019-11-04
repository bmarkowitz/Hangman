//
//  ViewController.swift
//  Hangman
//
//  Created by Brett Markowitz on 11/3/19.
//  Copyright © 2019 Brett Markowitz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var wordToGuessLabel: UILabel!
    var previousGuessesLabel: UILabel!
    var guessField: UITextField!
    var submitButton: UIButton!
    
    var allWords = [String]()
    var wordToGuess: String?
    var obscuredWordToGuess: String?
    var numberOfGuesses = 0
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        wordToGuessLabel = UILabel()
        wordToGuessLabel.text = "Word To Guess"
        wordToGuessLabel.textAlignment = .center
        wordToGuessLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wordToGuessLabel)
        
        previousGuessesLabel = UILabel()
        previousGuessesLabel.text = "Previous guesses go here"
        previousGuessesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(previousGuessesLabel)
        
        guessField = UITextField()
        let sidePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: guessField.frame.height))

        guessField.placeholder = "Placeholder"
        guessField.layer.borderWidth = 0.8
        guessField.layer.borderColor = UIColor.lightGray.cgColor
        guessField.layer.cornerRadius = 4
        guessField.autocapitalizationType = .none
        
        guessField.leftView = sidePaddingView
        guessField.leftViewMode = .always
        guessField.rightView = sidePaddingView
        guessField.rightViewMode = .always

        
        guessField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(guessField)
        
        submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            wordToGuessLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            wordToGuessLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            previousGuessesLabel.topAnchor.constraint(equalTo: wordToGuessLabel.bottomAnchor, constant: 25),
            previousGuessesLabel.centerXAnchor.constraint(equalTo: wordToGuessLabel.centerXAnchor),
            
            guessField.widthAnchor.constraint(equalTo: wordToGuessLabel.widthAnchor),
            guessField.topAnchor.constraint(equalTo: previousGuessesLabel.topAnchor, constant: 75),
            guessField.centerXAnchor.constraint(equalTo: wordToGuessLabel.centerXAnchor),
            guessField.heightAnchor.constraint(equalToConstant: 30),
            
            submitButton.centerXAnchor.constraint(equalTo: wordToGuessLabel.centerXAnchor),
            submitButton.topAnchor.constraint(equalTo: guessField.bottomAnchor, constant: 10)
        ])
        loadWords()
        loadLevel()
    }

    
    func loadWords() {
        if let wordsFileUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let wordsString = try? String(contentsOf: wordsFileUrl) {
                allWords = wordsString.components(separatedBy: "\n")
                allWords.shuffle()
            }
        }
    }
    
    func loadLevel() {
        numberOfGuesses = 0
        if !allWords.isEmpty {
            wordToGuess = allWords[Int.random(in: 0..<allWords.count)]
            obscureWordToGuess()
            wordToGuessLabel.text = obscuredWordToGuess
        }
    }
    
    func obscureWordToGuess() {
        if let obscuredWordToGuess = wordToGuess {

            var chars = Array(obscuredWordToGuess)
            for i in 0..<chars.count {
                chars[i] = "?"
            }
            self.obscuredWordToGuess = String(chars)
        }
    }
    
    @objc func submitTapped() {
        guard let submission = guessField.text else { return }
        guard let wordToGuess = wordToGuess else { return }
        guard let obscuredWordToGuess = obscuredWordToGuess else { return }

        numberOfGuesses += 1
        
        if submission.count == 1 {
            let realChars = Array(wordToGuess)
            var obscuredChars = Array(obscuredWordToGuess)
            for i in 0..<realChars.count {
                if realChars[i] == Character(submission) {
                    obscuredChars[i] = Character(submission)
                }
            }
            self.obscuredWordToGuess = String(obscuredChars)
            wordToGuessLabel.text = String(obscuredChars)
            guessField.text = ""
        }
        if submission.count > 1 && submission == wordToGuess {
            wordToGuessLabel.text = submission
            self.obscuredWordToGuess = submission
            guessField.text = ""
        }
        if(self.obscuredWordToGuess == wordToGuess) {
            var successMessage: String
            if(numberOfGuesses == 1) {
                successMessage = "It took you \(numberOfGuesses) guess to win."
            } else {
                successMessage = "It took you \(numberOfGuesses) guesses to win."
            }
            let ac = UIAlertController(title: "Nice job!", message: successMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Start Over", style: .default) {
                [weak self] _ in
                self?.loadLevel()
            })
            present(ac, animated: true)
        }
    }

}

