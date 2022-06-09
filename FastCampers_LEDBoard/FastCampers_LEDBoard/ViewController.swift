//
//  ViewController.swift
//  FastCampers_LEDBoard
//
//  Created by Woong on 2022/06/08.
//

import UIKit

class ViewController: UIViewController, LEDBoardSettingDelegate {
    
    @IBOutlet weak var contentsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentsLabel.textColor = .yellow
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settingViewController = segue.destination as? SettingViewController{
            settingViewController.delegate = self
            
            
            settingViewController.ledText = self.contentsLabel.text
            settingViewController.textColor = self.contentsLabel.textColor
            settingViewController.backColor = self.view.backgroundColor ?? .black
        }
        
    }
    
    func changedSetting(text: String?, textColor: UIColor, backColor: UIColor) {
        
        if let text = text{
            self.contentsLabel.text = text
        }
        
        self.contentsLabel.textColor = textColor
        self.view.backgroundColor = backColor
    }
    
    
    
}

