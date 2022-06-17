import UIKit

enum DiaryEditorMode {
    case new
    case edit(IndexPath, Diary)
}

protocol WriteDiaryViewDelegate: AnyObject {
    // 일기가 작성된 다이어리 전달
    func didSelectReg(diary : Diary)
}

class WriteDiaryController: UIViewController {
    
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var contentTxt: UITextView!
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var confirmBtn: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    weak var delegate: WriteDiaryViewDelegate?
    var diaryEditorMode : DiaryEditorMode = .new
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureContentTv()
        self.configureDatePicker()
        
        // 버튼 비활성화
        self.confirmBtn.isEnabled = false
        
        self.configureInputField()
        self.configureEditMode()
    }
    
    private func configureEditMode(){
        switch self.diaryEditorMode {
        case let .edit(_, diary) :
            self.titleTxt.text = diary.title
            self.contentTxt.text = diary.content
            self.dateTxt.text = self.dateToString(date: diary.date)
            self.diaryDate = diary.date
            self.confirmBtn.title = "수정"
            
        default : break
        }
        
    }
    
    private func dateToString (date : Date) -> String{
        
        let fommatter = DateFormatter()
        fommatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        fommatter.locale = Locale(identifier: "ko_KR")
        return fommatter.string(from: date)
    }
    
    //textView에 보더 설정하기
    private func configureContentTv(){
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentTxt.layer.borderColor = borderColor.cgColor
        self.contentTxt.layer.borderWidth = 0.5
        self.contentTxt.layer.cornerRadius = 5.0
    }
    
    // dateTxt 선택시 이벤트 처리
    private func configureDatePicker(){
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        
        //  어디서 처리할것인지, 어떤 액션을 할 것인지, 어떤 상황에서 처리를 할것 인지
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        // 로컬화
        self.datePicker.locale = Locale(identifier: "ko_KR")
        
        // 키보드대신 데이트 피커가 생김
        self.dateTxt.inputView = self.datePicker
    }
    
    private func configureInputField(){
        self.contentTxt.delegate = self
        self.titleTxt.addTarget(self, action: #selector(titleTxtDidChange(_:)), for: .editingChanged)
        self.dateTxt.addTarget(self, action: #selector(dateTxtDidChange(_:)), for: .editingChanged)
        
    }
    
    
    @IBAction func tabConfirmBtn(_ sender: UIBarButtonItem) {
        
        // notificenter 는 이벤트 버스라고 생각하면된다
        // post 로 이멘트 전송
        // 이벤트를 받르면 observer를 동록 해야한다.
        
        guard let title = self.titleTxt.text else{return}
        guard let contents = self.contentTxt.text else{return}
        guard let date = self.diaryDate else {return}
        
        switch self.diaryEditorMode {
        case .new:
            let diary = Diary(
                uuidString : UUID().uuidString,
                title: title,
                content: contents,
                date: date,
                isStar: false)
            self.delegate?.didSelectReg(diary: diary)
            
            
        case  let .edit(indxPath, diary) :
            let diary = Diary(
                uuidString : diary.uuidString,
                title: title,
                content: contents,
                date: date,
                isStar: diary.isStar)
            NotificationCenter.default.post(
                name: NSNotification.Name("editDiary"),
                object: diary,
                userInfo: nil            )
            
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker){
        let formmater = DateFormatter()
        formmater.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
        formmater.locale = Locale(identifier: "ko_KR")
        self.diaryDate = datePicker.date
        self.dateTxt.text = formmater.string(from: datePicker.date)
        self.dateTxt.sendActions(for: .editingChanged)
    }
    
    @objc private func titleTxtDidChange(_ textField : UITextField){
        self.validateInputField()
    }
    
    @objc private func dateTxtDidChange (_ textField : UITextField){
        self.validateInputField()
    }
    
    // 유저가 화면을 터치하면 발생하는 이벤트
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func validateInputField(){
        self.confirmBtn.isEnabled = !(self.titleTxt.text?.isEmpty ?? true) && !(self.dateTxt.text?.isEmpty ?? true) && !(self.contentTxt.text.isEmpty)
    }
    
}

extension WriteDiaryController : UITextViewDelegate{
    // 내용 입력시마다 호출
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputField()
    }
}
