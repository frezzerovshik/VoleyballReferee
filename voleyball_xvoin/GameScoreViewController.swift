//
//  GameS.swift
//  voleyball_xvoin
//
//  Created by Артем Шарапов on 20.08.2020.
//  Copyright © 2020 Artem Sharapov. All rights reserved.
//

import UIKit

class GameScoreViewController: UIViewController {
    
    var timeLabel = UILabel() //Лейбл для отображения текущего времени
    
    var timer = Timer() //Объект-таймер
    
    var startButton = UIButton() // Кнопка начала партии
    
    var isGameStarted: Bool = false // Признак того, что партия началась
    
    var leftTeamButton = UIButton() //Кнопка добавления очка к счёту левой команды
    
    var leftUndoButton = UIButton() //Кнопка отмены добавления очка к счёту левой команды
    
    var leftTeamNameChangeButton = UIButton() // Кнопка, позволяющая сменить наименование команды
    
    var leftScoreLabel = UILabel() //Объект, отображающий счёт левой команды
    
    //Аналогичные объекты для правой команды (порядок сохранён)
    var rightTeamButton = UIButton()
    
    var rightUndoButton = UIButton()
    
    var rightTeamNameChangeButton = UIButton()
    
    var rightScoreLabel = UILabel()
    
    //Счётчики для хранения количества очков, заработанных командой
    var leftTeamScore: UInt = 0
    
    var rightTeamScore: UInt = 0
    
    var leftTeamName = "Левая"
    
    var rightTeamName = "Правая"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Цвет кнопок +\-
        let buttonColor = UIColor(red: 51/255,
                                  green: 1,
                                  blue: 1,
                                  alpha: 1)
        //Добавляю на экран статичный заголовок
        let header = UILabel()
        header.text = "Волейбол в Хвойном"
        header.frame = CGRect(origin: CGPoint(x: view.center.x - (view.frame.width-30) / 4,
                                              y: navigationController?.navigationBar.frame.maxY ?? 0),
                              size: CGSize(width: view.frame.width-30,
                                           height: view.frame.height * 0.05)) //Фрейм заголовка
        header.textColor = .black
        //Первоначальные настройки лейблов
        leftScoreLabel.isHidden = false
        rightScoreLabel.isHidden = false
        leftScoreLabel.text = "0"
        rightScoreLabel.text = "0"
        leftScoreLabel.textAlignment = .center
        rightScoreLabel.textAlignment = .center
        leftScoreLabel.frame = CGRect(origin: CGPoint(x: view.frame.maxX * 0.2,
                                                      y: view.center.y - view.frame.maxY * 0.25),
                                      size: CGSize(width: 50,
                                                   height: 25)) //Фрейм счёта левой команды
        rightScoreLabel.frame = CGRect(origin: CGPoint(x: view.frame.maxX * 0.85 - view.frame.maxX * 0.2,
                                                       y: view.center.y - view.frame.maxY * 0.25),
                                       size: CGSize(width: 50,
                                                    height: 25)) //Фрейм счёта правой команды
        leftScoreLabel.textColor = .black
        rightScoreLabel.textColor = .black
        
        //Настройки кнопок
        //Установка тайтлов
        leftTeamButton.setTitle("+", for: .normal)
        rightTeamButton.setTitle("+", for: .normal)
        leftUndoButton.setTitle("-", for: .normal)
        rightUndoButton.setTitle("-", for: .normal)
        leftTeamNameChangeButton.setTitle(leftTeamName, for: .normal)
        rightTeamNameChangeButton.setTitle(rightTeamName, for: .normal)
        //Установка цветов
        leftTeamButton.setTitleColor(.black, for: .normal)
        rightTeamButton.setTitleColor(.black, for: .normal)
        leftUndoButton.setTitleColor(.black, for: .normal)
        rightUndoButton.setTitleColor(.black, for: .normal)
        leftTeamButton.backgroundColor = buttonColor
        rightTeamButton.backgroundColor = buttonColor
        leftUndoButton.backgroundColor = buttonColor
        rightUndoButton.backgroundColor = buttonColor
        leftTeamNameChangeButton.backgroundColor = UIColor(red: 1,
                                                           green: 102/255,
                                                           blue: 1,
                                                           alpha: 1)
        rightTeamNameChangeButton.backgroundColor = UIColor(red: 1,
                                                            green: 102/255,
                                                            blue: 1,
                                                            alpha: 1)
        //Привязка выполняемого кода
        leftTeamButton.addTarget(self, action: #selector(plusScore(sender:)), for: .touchUpInside)
        leftUndoButton.addTarget(self, action: #selector(minusScore(sender:)), for: .touchUpInside)
        rightTeamButton.addTarget(self, action: #selector(plusScore(sender:)), for: .touchUpInside)
        rightUndoButton.addTarget(self, action: #selector(minusScore(sender:)), for: .touchUpInside)
        leftTeamNameChangeButton.addTarget(self, action: #selector(setTeamName(sender:)), for: .touchUpInside)
        rightTeamNameChangeButton.addTarget(self, action: #selector(setTeamName(sender:)), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startGame(sender:)), for: .touchUpInside)
        
        //Разметка кнопок управления левой командой
        //+
        leftTeamButton.frame = CGRect(origin: CGPoint(x: view.frame.maxX * 0.1, y: view.center.y - view.frame.maxY * 0.25),
                                      size: CGSize(width: 25, height: 25))
        let deltaButtonLabel = leftScoreLabel.frame.minX - leftTeamButton.frame.maxX //Расстояние между кнопкой и лейблом сч    та
        //-
        leftUndoButton.frame = CGRect(x: leftScoreLabel.frame.maxX + deltaButtonLabel,
                                      y: view.center.y - view.frame.maxY * 0.25,
                                      width: 25,
                                      height: 25)
        //Смена названия
        leftTeamNameChangeButton.frame = CGRect(x: leftTeamButton.frame.minX,
                                                y: view.center.y - view.frame.maxY * 0.2,
                                                width: 125,
                                                height: 25)

        //Разметка кнопок управления правой командой
        //+
        rightTeamButton.frame = CGRect(x: rightScoreLabel.frame.minX - 25 - deltaButtonLabel,
                                       y: view.center.y - view.frame.maxY * 0.25,
                                       width: 25,
                                       height: 25)
        //-
        rightUndoButton.frame = CGRect(x: rightScoreLabel.frame.maxX + deltaButtonLabel,
                                       y: view.center.y - view.frame.maxY * 0.25,
                                       width: 25,
                                       height: 25)
        //Смена названия
        rightTeamNameChangeButton.frame = CGRect(x: rightTeamButton.frame.minX,
                                                 y: view.center.y - view.frame.maxY * 0.2,
                                                 width: 125,
                                                 height: 25)
        //Настройка элементов отображения и управления отсчётом времени
        timeLabel.text = "0:0"
        timeLabel.textAlignment = .center
        timeLabel.frame = CGRect(x: view.center.x - 62.5,
                                 y: view.frame.maxY * 0.8,
                                 width: 125,
                                 height: 25)
        timeLabel.textColor = .black
        startButton.frame = CGRect(x: view.center.x - 62.5,
                                   y: view.frame.maxY * 0.85,
                                   width: 125,
                                   height: 25)
        startButton.backgroundColor = buttonColor
        startButton.setTitle("Начать", for: .normal)
        
        //Добавление элементов на вью
        view.addSubview(header)
        view.addSubview(leftScoreLabel)
        view.addSubview(rightScoreLabel)
        view.addSubview(timeLabel)
        view.addSubview(rightTeamButton)
        view.addSubview(rightUndoButton)
        view.addSubview(rightTeamNameChangeButton)
        view.addSubview(leftTeamButton)
        view.addSubview(leftUndoButton)
        view.addSubview(leftTeamNameChangeButton)
        view.addSubview(startButton)
    }
    
    @objc private func setTeamName(sender: UIButton) {
            let alert = UIAlertController(title: "Изменение названия команды", message: "Введите новое название", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = "Например, Ландыши"
            }
            let action = UIAlertAction(title: "OK", style: .default) { [weak alert](_) in
                sender.titleLabel?.text = alert?.textFields![0].text
            }
            alert.addAction(action)
            self.present(alert, animated: true)
        if sender == leftTeamNameChangeButton {
            leftTeamName = sender.titleLabel?.text ?? leftTeamName
        }
        else {
            rightTeamName = sender.titleLabel?.text ?? rightTeamName
        }
    }
    
    @objc private func startGame(sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(timerUpdate),
                                     userInfo: NSDate(),
                                     repeats: true)
        startButton.isHidden = true
    }
    
    @objc private func timerUpdate() {
        isGameStarted = true
        let elapsed = -(self.timer.userInfo as! NSDate).timeIntervalSinceNow
        if elapsed < 60 {
            timeLabel.text = "0:" + String(format: "%.0f", elapsed)
        }
        else {
            timeLabel.text = String(format: "%.0f:%.0f", elapsed / 60, elapsed.truncatingRemainder(dividingBy: 60))
        }
    }
    
    //MARK: - Methods when buttons is pressed
    @objc private func plusScore(sender: UIButton) {
        if isGameStarted == true {
            if sender == leftTeamButton {
                leftTeamScore += 1
                if leftTeamScore < 10 {
                    leftScoreLabel.text = "0\(leftTeamScore)"
                }
                else {
                    leftScoreLabel.text = "\(leftTeamScore)"
                }
            }
            else {
                rightTeamScore += 1
                if rightTeamScore < 10 {
                    rightScoreLabel.text = "0\(rightTeamScore)"
                }
                else {
                    rightScoreLabel.text = "\(rightTeamScore)"
                }
            }
            gameOverCheck()
        }
    }
    
    @objc private func minusScore(sender: UIButton) {
        if isGameStarted == true {
            if sender == leftUndoButton {
                if leftTeamScore != 0 {
                    leftTeamScore -= 1
                    if leftTeamScore < 10 {
                        leftScoreLabel.text = "0\(leftTeamScore)"
                    }
                    else {
                        leftScoreLabel.text = "\(leftTeamScore)"
                    }
                }
            }
            else {
                if rightTeamScore != 0 {
                    rightTeamScore -= 1
                    if rightTeamScore < 10 {
                        rightScoreLabel.text = "0\(rightTeamScore)"
                    }
                    else {
                        rightScoreLabel.text = "\(rightTeamScore)"
                    }
                }
            }
        }
    }
    //MARK: - Game flow checker
    private func gameOverCheck() {
        var winnerMessage = ""
        if leftTeamScore == 24 && rightTeamScore == 24 {
            navigationController?.pushViewController(EqualScoreViewController(), animated: false)
        }
        if leftTeamScore == 25 || rightTeamScore == 25 {
            if leftTeamScore == 25 {
                winnerMessage = "левая команда"
            }
            else {
                winnerMessage = "правая команда"
            }
            timer.invalidate()
            timeLabel.text = "0:0"
            isGameStarted = false
            let resultAlertController = UIAlertController(title: "Внимание!", message: "Игра окончена, победила \(winnerMessage)", preferredStyle: .actionSheet)
            let resultAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
            resultAlertController.addAction(resultAction)
            self.present(resultAlertController, animated: false, completion: nil)
            leftTeamScore = 0
            rightTeamScore = 0
            leftScoreLabel.text = "0"
            rightScoreLabel.text = "0"
            startButton.isHidden = false
        }
    }
}
