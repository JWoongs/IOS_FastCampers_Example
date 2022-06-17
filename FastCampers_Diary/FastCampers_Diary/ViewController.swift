//
//  ViewController.swift
//  FastCampers_Diary
//
//  Created by Woong on 2022/06/13.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary](){
        didSet{
            self.saveD()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureCollectionView()
        self.loadD()
        
        NotificationCenter.default.addObserver(self, selector: #selector(editDiaryNoti(_:)), name: NSNotification.Name("editDiary"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(starDiaryNoti(_:)), name: NSNotification.Name("starDiary"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteDiaryNoti(_:)), name: NSNotification.Name("deleteDiary"), object: nil)
        
    }
    
    @objc func starDiaryNoti(_ noti : Notification){
      
        guard let starDiary = noti.object as? [String:Any] else {return}
        guard let isStar = starDiary["isStar"] as? Bool else {return}
        guard let uuidString = starDiary["uuidString"] as? String else {return}
        guard let index =  self.diaryList.firstIndex(where: {$0.uuidString == uuidString}) else { return }
        self.diaryList[index].isStar = isStar
    }
    
    
    @objc func editDiaryNoti(_ noti : Notification){
        guard let data = noti.object as? Diary else {return}
        // guard let row = noti.userInfo?["indexPath.row"] as? Int else {return}
        guard let index =  self.diaryList.firstIndex(where: {$0.uuidString == data.uuidString}) else { return }
        
        // self.diaryList[row] = data
        self.diaryList[index] = data
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
    
    @objc func deleteDiaryNoti(_ noti : Notification){
        // guard let indexPath = noti.object as? IndexPath else {return}
        guard let uuidString = noti.object as? String else {return}
        guard let index =  self.diaryList.firstIndex(where: {$0.uuidString == uuidString}) else { return }
        
        self.diaryList.remove(at: index)
        self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        
        self.collectionView.reloadData()
    }
    
    

    private func configureCollectionView(){
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
      
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiartViewController = segue.destination as? WriteDiaryController
        {
            //WriteDiaryViewDelegate' 를 채택하라는 경고문구가 등장하는데  그럼 채택해주자
            writeDiartViewController.delegate = self
        }
    }
    
    private func dateToString (date : Date) -> String{

        let fommatter = DateFormatter()
        fommatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        fommatter.locale = Locale(identifier: "ko_KR")
        return fommatter.string(from: date)
    }
    
    // 로컬 디비에 저장
    private func saveD(){
        let date = self.diaryList.map{
            [
                "uuidString" : $0.uuidString,
                "title" : $0.title,
                "contents" : $0.content,
                "date" : $0.date,
                "isStar" : $0.isStar
                
            ]
            
        }
        
        let userD = UserDefaults.standard
        userD.set(date, forKey: "diaryList")
    }
    
    private func loadD(){
        let userD  = UserDefaults.standard
        guard let data =  userD.object(forKey: "diaryList") as? [[String:Any]] else { return }
        self.diaryList = data.compactMap{
            guard let uuidString = $0["uuidString"] as? String else { return nil}
            guard let title = $0["title"] as? String else{ return nil}
            guard let contents = $0["contents"] as? String else{ return nil }
            guard let date = $0["date"] as? Date else{ return nil }
            guard let isStar = $0["isStar"] as? Bool else{ return nil }
            
            return Diary(uuidString : uuidString, title: title, content: contents, date: date, isStar: isStar)
        }
    
        
        // 최신 순
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        
    }
    

    
}

// collection view 구현
extension ViewController : UICollectionViewDataSource{
    // 지정된 섹션에 표현할 셀의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    // 표시할 셀을 요청
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell()}
     
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = self.dateToString(date: diary.date)
        return cell
        
    }
}

extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width/2) - 20 , height: 200)
    }
}


// WriteDiaryViewDelegate 를 채택
extension ViewController : WriteDiaryViewDelegate{
    func didSelectReg(diary: Diary) {
        
        self.diaryList.append(diary)
        // 최신 순
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })

        self.collectionView.reloadData()
    }
}

extension ViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        
        let diary = self.diaryList[indexPath.row]
        viewController.diary = diary
        viewController.indexPath = indexPath
        //  viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

//NOti로 변경 
//extension ViewController : DiaryDetailDelegate{
//    func didSelectDelete(indexPath: IndexPath) {
//        self.diaryList.remove(at: indexPath.row)
//        self.collectionView.deleteItems(at: [indexPath])
//    }
//
//    // 즐겨찾기 여부 업데이트 ( noti 로 변경 )
//    func didSelectStar(indexPath: IndexPath, isStar: Bool) {
//        self.diaryList[indexPath.row].isStar = isStar
//        // print(self.diaryList[indexPath.row].isStar)
//    }
//}
