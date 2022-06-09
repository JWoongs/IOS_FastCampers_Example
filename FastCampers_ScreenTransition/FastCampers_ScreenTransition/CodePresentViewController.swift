
import UIKit



protocol SendDataDelegate: AnyObject{
    func sendData(name: String)
}


class CodePresentViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    var name: String?
    
    // weak 는 델리게이트 패턴사용시 델리게이트 변수앞에 붙여줘야 한다 ( 강한 순환 참조로 메모리릭이 발생가능성이 있음 )
    weak var deletgate : SendDataDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = name{
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }
      
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.deletgate?.sendData(name: "Woongs")
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
