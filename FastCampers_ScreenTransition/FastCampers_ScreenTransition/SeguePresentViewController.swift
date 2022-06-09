
import UIKit

class SeguePresentViewController: UIViewController {
    
    var name: String?

    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func backBtn(_ sender: UIButton) {
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
