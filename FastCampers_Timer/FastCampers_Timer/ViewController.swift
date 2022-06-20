//
//  ViewController.swift
//  FastCampers_Timer
//
//  Created by Woong on 2022/06/20.
//

import UIKit
import AudioToolbox

enum TimerStatue {
    case start
    case pause
    case end
}

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var toggleBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    // 시간 -> 초
    var duration =  60
    var timerStatus : TimerStatue = .end
    
    var timer : DispatchSourceTimer?
    var currentSeconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureToggleBtn()
    }

    
    
    @IBAction func cancelBtnEvent(_ sender: Any) {
        
        switch self.timerStatus {
        
        case .pause,.start  :
     
            self.stopTimer()
            
        default:
            break
        }
        
    }
    
    
    func setTimerInfoViewVisible(isHidden : Bool){
        
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    
    }
    
    func configureToggleBtn(){
        self.toggleBtn.setTitle("시작", for: .normal)
        self.toggleBtn.setTitle("일시정지", for: .selected)
    }
    
    func startTimer(){
        if self.timer == nil{
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main) // 어떤 쓰레드에서 할지? ( UI 와 관련된 작업은 반드시 main 쓰레드에서 구현 되어야 함
            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: { [weak self] in
                guard let self = self else {return}
                self.currentSeconds -= 1
//                debugPrint(self.currentSeconds)
                
                let hour = self.currentSeconds / 3600
                let min = (self.currentSeconds%3600) / 60
                let seconds = (self.currentSeconds%3600) % 60
                
                
                // 시간표기
                self.timerLabel.text = String(format:"%02d:%02d:%02d", hour,min,seconds )
                
                
                // 포르그래스바
                self.progressView.progress = Float(self.currentSeconds) / Float(self.duration)
                
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
                })
                
                UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi * 2)
                })
                

                if  self.currentSeconds <= 0 {
                    // 타이머 종료
                    self.stopTimer()
                    AudioServicesPlaySystemSound(1005)
                    
                }
            })
            
            self.timer?.resume()
            
        }
    }
    
    func stopTimer(){
        if self.timerStatus == .pause{
            self.timer?.resume()
        }
        self.timerStatus = .end
        self.cancelBtn.isEnabled = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.timerLabel.alpha = 0
            self.progressView.alpha = 0
            self.datePicker.alpha = 1
            self.imageView.transform = .identity // 원상복구
        })
        
        self.toggleBtn.isSelected = false
        self.timer?.cancel()
        
        self.timer = nil
    }
    
    
    @IBAction func toggleBtnEvent(_ sender: Any) {
        self.duration = Int(self.datePicker.countDownDuration)
        // debugPrint(self.duration)
        
        switch self.timerStatus {
        case .end :
            self.currentSeconds = self.duration
            self.timerStatus = .start
            
            UIView.animate(withDuration: 0.5, animations: {
                self.timerLabel.alpha = 1
                self.progressView.alpha = 1
                self.datePicker.alpha = 0
            })
            
            self.toggleBtn.isSelected = true
            self.cancelBtn.isEnabled = true
            
            self.startTimer()
            
        case .start :
            self.timerStatus = .pause
            self.toggleBtn.isSelected = false
            self.timer?.suspend()
            
        case .pause :
            self.timerStatus = .start
            self.toggleBtn.isSelected = true
            self.timer?.resume()
            
        default:
            break
        }
        
    }
    
}

