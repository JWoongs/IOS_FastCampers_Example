import UIKit


// 스토리 보드상에 빌드 및 적용하여 보여줌
// 남용하게 되면, 버벅이거나 오류 발생 가능성이 있음.
@IBDesignable
class RoundBtn: UIButton {
    
    // 코드 <-> 스토리보드의 인스펙터 영역을 이어주는 것
    // 인스펙터 영역에 내가 원하는 Attribute를 추가하고 싶을 때 사용
    @IBInspectable var isRound:Bool = false {
        didSet{
            if isRound{
                self.layer.cornerRadius = self.frame.height/2
            }
        }
    }
}
