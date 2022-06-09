//
//  ViewController.swift
//  FastCampers_Cal
//
//  Created by Woong on 2022/06/09.
//

import UIKit

enum Operation {
    case Add
    case Minus
    case Divide
    case Muti
    case unknowen
}

class ViewController: UIViewController {
    
    var displayNumber = "" // 계산기 버튼을 누를때마다 표기
    var firstOperand = "" // 이전 계산 값을 저장하는 곳
    var secondOperand = "" // 두번째 피 연산자
    var result = ""
    var currentOperation : Operation = .unknowen
    
    
    @IBOutlet weak var numberOutputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tabNumberBtn(_ sender: UIButton) {
        
        guard let numberValue = sender.title(for: .normal) else {return}
        
        if self.displayNumber.count<9 {
            self.displayNumber += numberValue
            self.numberOutputLabel.text = self.displayNumber
        }
        
    }
    
    
    @IBAction func tabClearBtn(_ sender: UIButton) {
        self.numberOutputLabel.text = "0"
        self.displayNumber = "" // 계산기 버튼을 누를때마다 표기
        self.firstOperand = "" // 이전 계산 값을 저장하는 곳
        self.secondOperand = "" // 두번째 피 연산자
        self.result = ""
        self.currentOperation = .unknowen
        
        
    }
    
    
    
    @IBAction func tabDotBtn(_ sender: UIButton) {
        
        if self.displayNumber.count < 8, !self.displayNumber.contains("."){
            self.displayNumber += self.displayNumber.isEmpty ? "0." : "."
            self.numberOutputLabel.text = self.displayNumber
        }
        
        
    }
    
    
    
    @IBAction func tabDivideBtn(_ sender: UIButton) {
        self.operation(.Divide)
    }
    
    @IBAction func tabMaltiBtn(_ sender: UIButton) {
        self.operation(.Muti)
    }
    
    
    @IBAction func tabMinusBtn(_ sender: UIButton) {
        self.operation(.Minus)
    }
    
    
    @IBAction func tabAddBtn(_ sender: UIButton) {
        self.operation(.Add)
    }
    
    
    @IBAction func tabResultBtn(_ sender: UIButton) {
        self.operation(self.currentOperation)
    }
    
    
    func operation(_ operation:Operation){
        if self.currentOperation != .unknowen{
            if !self.displayNumber.isEmpty{
                self.secondOperand = self.displayNumber
                self.displayNumber = ""
                
                guard let firstOp = Double(self.firstOperand) else{return}
                
                guard let seconOp = Double(self.secondOperand) else{return}
                
                switch self.currentOperation{
                case .Add : self.result = "\(firstOp+seconOp) "
                case .Minus : self.result = "\(firstOp-seconOp) "
                case .Muti : self.result = "\(firstOp*seconOp) "
                case .Divide : self.result = "\(firstOp/seconOp) "
                default : break
                }
                
                if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 {
                    self.result = "\(Int(result))"
                }
                
                self.firstOperand  = self.result
                self.numberOutputLabel.text = self.result
                
            }
            
            self.currentOperation = operation
            
        }else {
            self.firstOperand = self.displayNumber
            self.currentOperation = operation
            self.displayNumber = ""
        }
        
    }
    
    
    
}

