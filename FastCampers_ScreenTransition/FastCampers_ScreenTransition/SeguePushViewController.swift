import UIKit

class SeguePushViewController: UIViewController {
    
    var name: String?

    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = name {
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }
        
    }

    
    @IBAction func btnBack(_ sender: UIButton) {
        // 이전것
        self.navigationController?.popViewController(animated: true)
        
        // 루트
//        self.navigationController?.popToRootViewController(animated: true)
    }
}

