//
//  ViewController.swift
//  FastCampers_ScreenTransition
//
//  Created by Woong on 2022/06/07.
//

import UIKit

class ViewController: UIViewController, SendDataDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    // 코드로 푸시 방법
    @IBAction func tabCodePushBtn(_ sender: UIButton) {
        
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CodePushViewController")as?
                CodePushViewController
        else {return}
        
        // 다음 화면에  값전달
        viewController.name = "Woong"
      
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    // 코드로 프레젠트
    @IBAction func tabCodePresent(_ sender: UIButton) {
        
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CodePresentViewController")as? CodePresentViewController
              
        else{return}
        
        // 다음 화면에  값전달
        viewController.name = "Woongs"
        
        // 델리게이트를 위임 받음
        viewController.deletgate = self
        viewController.modalPresentationStyle = .fullScreen
        
        self.present(viewController, animated: true,completion: nil)
    }
    
    
    // 코드로  델리게이트로 처리하는 방식
    func sendData(name: String) {
        self.nameLabel.text = name
        self.nameLabel.sizeToFit()
        
    }
    
    
    // 세그웨이 방식으로 값 전달하는 방법
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 전환하려는 뷰컨트롤러의 인스턴스를 가지고 올수 있다.
        if let viewController = segue.destination as? SeguePushViewController{
            viewController.name = "woogs"
        }
        
    }
    
    
}

