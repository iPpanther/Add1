//
//  MainViewController.swift
//  Add1
//
//  Created by Peerapol on 16/3/2562 BE.
//  Copyright © 2562 iPpanther. All rights reserved.
//

import UIKit
import MBProgressHUD

class MainViewController: UIViewController {

    @IBOutlet weak var numbersLabel:UILabel?
    @IBOutlet weak var scoreLabel:UILabel?
    @IBOutlet weak var inputField:UITextField?
    @IBOutlet weak var timeLabel:UILabel?
    
    var score:Int = 0
    
    var hud:MBProgressHUD?
    
    var timer:Timer?
    var seconds:Int = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hud = MBProgressHUD(view:self.view)
        
        if(hud != nil)
        {
            self.view.addSubview(hud!)
        }
        
        setRandomNumberLabel()
        updateScoreLabel()
        
        inputField?.addTarget(self, action: #selector(textFieldDidChange(textField:)), for:UIControl.Event.editingChanged)
    }
    
    @objc func onUpdateTimer() -> Void
    {
        if(seconds > 0 && seconds <= 60)
        {
            seconds -= 1
            
            updateTimeLabel()
        }
        else if(seconds == 0)
        {
            if(timer != nil)
            {
                timer!.invalidate()
                timer = nil
                
                let alertController = UIAlertController(title: "Time Up!", message: "Your time is up! You got a score of: \(score) points. Very good!", preferredStyle: .alert)
                let restartAction = UIAlertAction(title: "Restart", style: .default, handler: nil)
                alertController.addAction(restartAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                score = 0
                seconds = 60
                
                updateTimeLabel()
                updateScoreLabel()
                setRandomNumberLabel()
            }
        }
    }
    
    func updateTimeLabel()
    {
        if(timeLabel != nil)
        {
            let min:Int = (seconds / 60) % 60
            let sec:Int = seconds % 60
            
            let min_p:String = String(format: "%02d", min)
            let sec_p:String = String(format: "%02d", sec)
            
            timeLabel!.text = "\(min_p):\(sec_p)"
        }
    }
    
    func showHUDWithAnswer(isRight:Bool)
    {
        var imageView:UIImageView?
        
        if isRight
        {
            imageView = UIImageView(image: UIImage(named:"thumbs-up"))
        }
        else
        {
            imageView = UIImageView(image: UIImage(named:"thumbs-down"))
        }
        
        if(imageView != nil)
        {
            self.inputField?.text = ""
            
            hud?.mode = MBProgressHUDMode.customView
            hud?.customView = imageView
            
            hud?.show(animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.hud?.hide(animated: true)
            }
        }
    }
    
    @objc func textFieldDidChange(textField:UITextField)
    {
        if(timer == nil)
        {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector:#selector(onUpdateTimer), userInfo:nil, repeats:true)
        }
        
        if inputField?.text?.count ?? 0 < 4
        {
            return
        }
        
        if  let numbers_text    = numbersLabel?.text,
            let input_text      = inputField?.text,
            let numbers = Int(numbers_text),
            let input   = Int(input_text)
        {
            print("Comparing: \(input_text) minus \(numbers_text) == \(input - numbers)")
            
            if(input - numbers == 1111)
            {
                print("Correct!")
                
                showHUDWithAnswer(isRight: true)
                score += 1
            }
            else
            {
                print("Incorrect!")
                
                showHUDWithAnswer(isRight: false)
                if score > 0 {
                    score -= 1
                }                
            }
        }
        
        setRandomNumberLabel()
        updateScoreLabel()
        
    }
    
    func updateScoreLabel()
    {
        scoreLabel?.text = "\(score)"
    }
    
    func setRandomNumberLabel()
    {
        numbersLabel?.text = generateRandomNumber()
    }

    func generateRandomNumber() -> String
    {
        var result:String = ""
        
        for _ in 1...4
        {
            let digit = Int.random(in: 1..<9)
            
            result += "\(digit)"
        }
        
        return result
    }
    
}
