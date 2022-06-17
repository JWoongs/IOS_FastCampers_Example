

import UIKit


// 프로토콜을 이용한 델리게이트는 1:1 로만 동작하기때문에
// 한쪽에만 델리게이트를 전달할수 있다 그래서 걷어내고  노티센터를 이용해서 하려고 한다.
//
//protocol DiaryDetailDelegate : AnyObject {
//
//    // func didSelectDelete(indexPath : IndexPath)
//    // func didSelectStar(indexPath : IndexPath, isStar : Bool)
//
//}

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTxt: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var startButton : UIBarButtonItem?
    
   //  weak var delegate : DiaryDetailDelegate?
    
    
    var diary: Diary?
    var indexPath : IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        NotificationCenter.default.addObserver(self, selector: #selector(starNoti(_:)), name: NSNotification.Name("starDiary"), object: nil)

    }
    @objc func starNoti(_ noti : Notification){
        guard let starD = noti.object as? [String : Any] else { return }
        guard let isStar = starD["isStar"] as? Bool else {return}
        guard let uuidString = starD["uuidString"] as? String else {return}
        guard let diary = self.diary else {
            return
        }
        
        if diary.uuidString == uuidString{
            self.diary?.isStar = isStar
            self.configureView()
        }

    }
    
    
    private func configureView(){
        guard let diary = self.diary else {
            return
        }
        
        self.titleLabel.text = diary.title
        self.contentTxt.text = diary.content
        self.dateLabel.text = self.dateToString(date: diary.date)
        
        // 즐겨찾기 버튼 추기 및 설정
        self.startButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(starBtnClick))
        self.startButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.startButton?.tintColor = .orange
        self.navigationItem.rightBarButtonItem = self.startButton

    }
    
    @objc func starBtnClick(){
        // 즐겨찾기 토글
        
        guard let isStar = self.diary?.isStar else {return}
        guard let indexPath = indexPath else { return        }

        
        if isStar {
            self.startButton?.image = UIImage(systemName: "star")
        }else{
            self.startButton?.image = UIImage(systemName: "star.fill")
        }
        
        self.diary?.isStar = !isStar
        
        
        // 상단의 이슈정리 ( 노티로 처리 )
        //self.delegate?.didSelectStar(indexPath: indexPath, isStar: self.diary?.isStar ?? false)
        
        NotificationCenter.default.post(
            name: NSNotification.Name("starDiary"),
            object: [
                "diary" : self.diary,
                "isStar": self.diary?.isStar ?? false,
                "uuidString" : self.diary?.uuidString
            ],
            userInfo: nil
        )
    }
    
    
    private func dateToString (date : Date) -> String{

        let fommatter = DateFormatter()
        fommatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        fommatter.locale = Locale(identifier: "ko_KR")
        return fommatter.string(from: date)
    }
    
 
    @IBAction func editBtn(_ sender: UIButton) {
        
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WriteDiaryController") as? WriteDiaryController else {
            return
        }
        guard let indexPath = self.indexPath else { return }
        guard let diary = self.diary else {return}
        viewController.diaryEditorMode = .edit(indexPath, diary)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNoti(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    deinit{
        // 옵저빙 해제 
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func editDiaryNoti(_ notification : Notification){
        guard let data = notification.object as? Diary else { return }
     
        
        self.diary = data
        self.configureView()
    }
    
    
    @IBAction func removeBtn(_ sender: UIButton) {
        
        guard let uuidString =  self.diary?.uuidString else {return}
        
       //  self.delegate?.didSelectDelete(indexPath: indexPath)
        
        
        NotificationCenter.default.post(
            name: NSNotification.Name("deleteDiary"),
            object:uuidString,
            userInfo: nil)
        
        self.navigationController?.popViewController(animated: true)

        
    }
    
}
