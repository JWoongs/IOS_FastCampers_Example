//
//  BeerListViewController.swift
//  FastCampers_Brewery
//
//  Created by Woong on 2022/06/29.
//

import UIKit

class BeerListViewController : UITableViewController{
    
    var beerList = [Beer] ()
    
    var currentPage = 1
    var dataTasks = [URLSessionTask]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation setting
        // UINavigationBar
        
        title = "브루어리"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
        tableView.prefetchDataSource = self
        
        fetchBeer(of: currentPage)
        
    }
    
}

// DataSource , Delegate
extension BeerListViewController  : UITableViewDataSourcePrefetching {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath)
                as? BeerListCell else { return UITableViewCell()}
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer  = beerList[indexPath.row]
        let detailViewController = BeerDetailViewController()
        detailViewController.beer = selectedBeer
        
    
        //print(detailViewController.beer)
        
       self.show(detailViewController, sender: nil)
    }
    
    
    // paging
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        guard currentPage != 1 else { return }
        indexPaths.forEach{
            if ($0.row+1)/25 + 1 == currentPage {
                self.fetchBeer(of: currentPage)
            }
        }
        
    }
    
    
}

//Data Fatching
extension BeerListViewController {
    func fetchBeer(of page : Int)  {
        
        // 이전에 실행한 url 이 아닌경우에만 처리
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
              dataTasks.firstIndex(where: {$0.originalRequest?.url == url}) == nil
        else { return }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask =  URLSession.shared.dataTask(with: request ){
            data, response, error in
            guard error == nil,
                  
                    let response = response as? HTTPURLResponse,
                  let data = data,
                  let beers = try? JSONDecoder().decode([Beer].self, from: data) else {
                      print("ERROR : URLSession Data task \(error?.localizedDescription ?? "")" )
                      return
                  }
            switch response.statusCode {
            case (200...299): // 성공
                self.beerList += beers
                self.currentPage += 1
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case (400...499): // 클라이언트 에러
                print("ERROR : Client \( response.statusCode)" )
                
            case (500...599): // 서버에러
                print("ERROR : Server \( response.statusCode)" )
            default :
                print("ERROR")
            }
            
        }
        dataTask.resume()
        dataTasks.append(dataTask)
        
    }
}
