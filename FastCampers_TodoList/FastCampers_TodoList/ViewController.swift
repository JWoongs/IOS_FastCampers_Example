//
//  ViewController.swift
//  FastCampers_TodoList
//
//  Created by Woong on 2022/06/10.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var editBtn: UIBarButtonItem!
    
    var doneBtn : UIBarButtonItem?
    
    var tasks = [Task](){
        // 데이터가 추가 될대마다 userDefaults에 저장
        didSet{
            self.saveTasks()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // edit 버튼
        self.doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:  #selector(doneBtnTap))
        
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loasTasks()
    }
    
    // object C 와 호환하기위해
    @objc func doneBtnTap(){
        self.navigationItem.leftBarButtonItem = self.editBtn
        self.tableView.setEditing(false, animated: true)
        
    }
    
    @IBAction func tabEditBtn(_ sender: UIBarButtonItem) {
        guard !self.tasks.isEmpty else {return}
        
        self.navigationItem.leftBarButtonItem = self.doneBtn
        self.tableView.setEditing(true, animated: true)
        
    }
    
    @IBAction func tabAddBtn(_ sender: UIBarButtonItem) {
        
        let alert  = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
        
        // 등록 버튼 ( 타이틀, 내용, 이벤트 클로저 )
        let regiBtn = UIAlertAction(title: "등록", style: .default, handler: { [weak self] _ in
            // 텍스트 필드에 입력된 값 가지고 오기
            guard let title = alert.textFields?[0].text else{return}
            let tesk  = Task(title: title, done: false)
            self?.tasks.append(tesk)
            
            // 갱신
            self?.tableView.reloadData()
            
            // debugPrint(todoContent)
            // print("등록 \(todoContent)")
            
        })
        
        // 취소 버튼
        let cancelBtn = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        // alert에  버튼 추가
        alert.addAction(cancelBtn)
        alert.addAction(regiBtn)
        
        // alert에 텍스트필 추가 ( 텍스트 필드에 대한 config 를 정의 해줘 야 한다 . )
        alert.addTextField(configurationHandler: { textfield in
            
            textfield.placeholder = "할 일 입력"
            
        })
        
        // alert 보이기
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func saveTasks(){
        let data = self.tasks.map{
            [
                "title" : $0.title,
                "done" : $0.done
            ]
        }
        // 저장
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
        
    }
    
    func loasTasks(){
        // 데이터 로드
        let userDefaults = UserDefaults.standard
        guard let data =  userDefaults.object(forKey: "tasks") as? [[String : Any]] else {return}
        
        // 맵형태로 만들기
        self.tasks = data.compactMap{
            guard let title = $0["title"] as? String else {return nil}
            guard let done = $0["done"] as? Bool else {return nil}
            return Task(title: title, done: done)
        }
        
    }
    
}


// android의 adapter 느낌 ?
extension ViewController: UITableViewDataSource {
   
    //UITableViewDataSource 프로토콜을 사용하려면 아래의 두개 함수를 꼭 정의 해줘야 한다.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 각 섹션에 표시할 행의 갯수
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 스토리보드에서 구현된 셀을 가지고 오기
        // dequeueReusableCell 재사용 가능한 테이블 뷰를 가져옴 ( 메모리 낭비를 방지하기 위하여 셀을 재사용 )
        // Cell 은 스토리보드 셀의 id 값
        let cell = tableView.dequeueReusableCell(withIdentifier:  "Cell", for: indexPath)
        let task = self.tasks[indexPath.row]
        
        cell.textLabel?.text = task.title
        
        if task.done{
            cell.accessoryType = .checkmark
            
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    // 삭제버튼이 눌린 셀이 어떤것인지
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        // 모든 행이 삭제됬을경우 돌아옥
        if self.tasks.isEmpty{
            self.doneBtnTap()
        }
    }
    
    // 셀이동
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 원래 위치랑 이동한 곳을 알려줌
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var tasks = self.tasks
        let task = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(task, at: destinationIndexPath.row)
        self.tasks = tasks
    }
    
}

// 동작과 외관을 담당함 
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        
        //변경된 데이터 덮어 씌우기
        self.tasks[indexPath.row] = task
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
