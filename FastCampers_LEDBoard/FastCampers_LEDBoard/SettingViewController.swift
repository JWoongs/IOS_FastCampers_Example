import UIKit



protocol LEDBoardSettingDelegate :  AnyObject{
    func changedSetting(text:String? ,textColor : UIColor, backColor: UIColor)
}

class SettingViewController: UIViewController {

    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var ybtn: UIButton!
    @IBOutlet weak var pbtn: UIButton!
    @IBOutlet weak var gbtn: UIButton!
    
    

    @IBOutlet weak var bbbtn: UIButton!
    @IBOutlet weak var bblbtn: UIButton!
    @IBOutlet weak var bobtn: UIButton!

    
    weak var delegate : LEDBoardSettingDelegate?
    var ledText : String?
    var textColor : UIColor = .yellow
    var backColor : UIColor = .black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    private func configureView(){
        if let ledText = self.ledText {
            self.textfield.text = ledText
        }
        
        self.chageTextColor(color: self.textColor)
        self.changeBackColor(color: self.backColor)
    }
    
    
    @IBAction func tabTextColorButton(_ sender: UIButton) {
        // 어떤 놈이 눌렸는가는 sender 파라미터를 가지고 구분할 수 있다.
        
        if sender == self.ybtn{
            self.chageTextColor(color: .yellow)
            self.textColor = .yellow
        } else if sender == self.pbtn{
            print("click")
            self.chageTextColor(color: .purple)
            self.textColor = .purple
        }else if sender == self.gbtn {
            self.chageTextColor(color: .green)
            self.textColor = .green
        }else{
            self.chageTextColor(color: .green)
            self.textColor = .green
        }
        
    }
    
    
    @IBAction func tabBackColorButton(_ sender: UIButton) {
        
        if sender == self.bbbtn{
            self.changeBackColor(color: .black)
            self.backColor = .black
        } else if sender == self.bblbtn{
            print("click2")
            self.changeBackColor(color: .blue)
            self.backColor = .blue
        }else if sender == self.bobtn {
            self.changeBackColor(color: .orange)
            self.backColor = .orange
        }else{
            self.changeBackColor(color: .orange)
            self.backColor = .orange
        }
        
        
    }
    
    
    @IBAction func tabSaveButton(_ sender: UIButton) {
        
        self.delegate?.changedSetting(text: self.textfield.text, textColor: self.textColor, backColor: self.backColor)
        self.navigationController?.popViewController(animated: true)
                
    }
    
    private func chageTextColor(color: UIColor){
        //3항 연산자
        self.ybtn.alpha = color == UIColor.yellow ? 1: 0.2
        self.pbtn.alpha = color == UIColor.purple ? 1: 0.2
        self.gbtn.alpha = color == UIColor.green ? 1: 0.2
    }
    
    private func changeBackColor(color : UIColor){
        self.bbbtn.alpha = color == UIColor.black ? 1: 0.2
        self.bblbtn.alpha = color == UIColor.blue ? 1: 0.2
        self.bobtn.alpha = color == UIColor.orange ? 1: 0.2
    
    }
    
}
