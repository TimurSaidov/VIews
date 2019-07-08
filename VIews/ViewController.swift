//
//  ViewController.swift
//  VIews
//
//  Created by Timur Saidov on 08/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    // MARK: Outlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var gameFieldView: GameFieldView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    // MARK: Private Properties
    
    private var isGameActive = false
    private var gameTimeLeft: TimeInterval = 0
    private var gameTimer: Timer?
    private var timer: Timer?
    private let displayDuration: TimeInterval = 2
    private var score = 0
    
    
    // MARK: Actions
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        updateUI()
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        isGameActive ? stopGame() : startGame()
    }
    
//            @IBAction func objectTapped(_ sender: UITapGestureRecognizer) { // gameObject - это UIImageView; UITapGestureRecognizer -> gameObject (в Storyboard); @IBAction для TapGestureRecognizer; gameObject -> Attributes Inspector -> User Interaction Enabled = true, иначе пользовательский ввод будет проигнорирован и перенаправлен объектам, расположенным под нажимаемым (пользовательский ввод проигнорирован для всех наследников UIView, кроме UIControl).
//        guard isGameActive else { return }
//        repositionImageWithTimer()
//        score += 1
//    }
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActionButton()
        setupGameFieldView()
        updateUI()
    }
    
    
    // MARK: Private
    
    private func setupActionButton() {
        actionButton.layer.cornerRadius = 5
    }
    
    private func setupGameFieldView() {
        gameFieldView.layer.borderWidth = 1
        gameFieldView.layer.borderColor = UIColor.gray.cgColor
        gameFieldView.layer.cornerRadius = 5
        gameFieldView.shapeHitHandler = { [weak self] in
            self?.objectTapped()
        }
    }
    
    private func objectTapped() {
        guard isGameActive else { return }
        repositionImageWithTimer()
        score += 1
    }
    
    private func startGame() {
        score = 0
        repositionImageWithTimer()
        gameTimer?.invalidate()
        let gameTimer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(gameTimerTick), // Концепция селектор используется для того, чтобы указать функцию, которую необходимо вызвать у объекта когда-то позже.
                                         userInfo: nil,
                                         repeats: true)
        RunLoop.current.add(gameTimer, forMode: .common)
        gameTimer.tolerance = 0.1
        self.gameTimer = gameTimer
        gameTimeLeft = stepper.value
        isGameActive = true
        updateUI()
    }
    
    @objc private func moveImage() {
        gameFieldView.randomizeShapes()
    }
    
    @objc private func gameTimerTick() {
        gameTimeLeft -= 1
        gameTimeLeft <= 0 ? stopGame() : updateUI()
    }
    
    private func stopGame() {
        isGameActive = false
        updateUI()
        gameTimer?.invalidate()
        timer?.invalidate()
        scoreLabel.text = "Счет: \(score)"
    }
    
    private func updateUI() {
        gameFieldView.isShapeHidden = !isGameActive
        stepper.isEnabled = !isGameActive
        scoreLabel.isHidden = isGameActive
        if isGameActive {
            timeLabel.text = "Осталось: \(Int(gameTimeLeft)) сек."
            actionButton.setTitle("Остановить", for: .normal)
        } else {
            timeLabel.text = "Время: \(Int(stepper.value)) сек."
            actionButton.setTitle("Начать", for: .normal)
        }
    }
    
    private func repositionImageWithTimer() {
        timer?.invalidate()
        let timer = Timer.scheduledTimer(timeInterval: displayDuration,
                                         target: self,
                                         selector: #selector(moveImage),
                                         userInfo: nil,
                                         repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        timer.tolerance = 0.1
        timer.fire()
        self.timer = timer
    }
}
