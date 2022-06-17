

import UIKit

class StarViewController: UIViewController {

    // 즐겨찾기한 일기만 콜랙션 변수에 추가
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollView()
        self.loadStarDList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(editDiaryNoti(_:)), name: NSNotification.Name("editDiary"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(starDiaryNoti(_:)), name: NSNotification.Name("starDiary"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteDiaryNoti(_:)), name: NSNotification.Name("deleteDiary"), object: nil)
      
    }

    
    private func loadStarDList(){

        
        let userD  = UserDefaults.standard
        guard let data =  userD.object(forKey: "diaryList") as? [[String:Any]] else { return }
        
       
        print(data)
        self.diaryList = data.compactMap{
            guard let uuidString = $0["uuidString"] as? String else { return nil}
            guard let title = $0["title"] as? String else{ return nil}
            guard let contents = $0["contents"] as? String else{ return nil }
            guard let date = $0["date"] as? Date else{ return nil }
            guard let isStar = $0["isStar"] as? Bool else{ return nil }
            
            
            return Diary(uuidString:uuidString,title: title, content: contents, date: date, isStar: isStar)
        }.filter({
            $0.isStar == true
        }).sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        
    }
    
    private func configureCollView(){
     
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        
    }
    
    @objc func starDiaryNoti(_ noti : Notification){
        guard let starDiary = noti.object as? [String:Any] else {return}
        guard let diary = starDiary["diary"]  as? Diary else {return}
        guard let isStar = starDiary["isStar"] as? Bool else {return}
        guard let uuidString = starDiary["uuidString"] as? String else { return }
     
        
        if isStar {
            self.diaryList.append(diary)
            self.diaryList = self.diaryList.sorted(by: {
                $0.date.compare($1.date) == .orderedDescending
            })
            self.collectionView.reloadData()
        } else{
            guard let index =  self.diaryList.firstIndex(where: {$0.uuidString == uuidString}) else { return }
            self.diaryList.remove(at: index)
            self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    
    @objc func editDiaryNoti(_ noti : Notification){
        guard let data = noti.object as? Diary else {return}
        // guard let row = noti.userInfo?["indexPath.row"] as? Int else {return}
        guard let index =  self.diaryList.firstIndex(where: {$0.uuidString == data.uuidString}) else { return }
        
        self.diaryList[index] = data
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
    
    @objc func deleteDiaryNoti(_ noti : Notification){
        guard let uuidString = noti.object as? String else {return}
        guard let index =  self.diaryList.firstIndex(where: {$0.uuidString == uuidString}) else { return }
        
        self.diaryList.remove(at: index)
        self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        self.collectionView.reloadData()
    }
    
    
    private func dateToString (date : Date) -> String{

        let fommatter = DateFormatter()
        fommatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        fommatter.locale = Locale(identifier: "ko_KR")
        return fommatter.string(from: date)
    }
    
}

extension StarViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarCell", for: indexPath) as? StarCell else {return UICollectionViewCell()}
        
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = self.dateToString(date: diary.date)
        
        
        return cell
    }
}

extension StarViewController : UICollectionViewDelegateFlowLayout{
    // 사이즈단위가 pt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width-20, height: 80)
    }
    
    

    
}

extension StarViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController  =  self.storyboard?.instantiateViewController(withIdentifier: "DiaryDetailViewController")  as? DiaryDetailViewController else { return }
        
        let diary = self.diaryList[indexPath.row]
        viewController.diary = diary
        viewController.indexPath = indexPath
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
