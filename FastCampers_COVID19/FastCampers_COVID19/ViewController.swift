//
//  ViewController.swift
//  FastCampers_COVID19
//
//  Created by Woong on 2022/06/22.
//

import UIKit
import Charts
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var totalCaseLabel: UILabel!
    
    @IBOutlet weak var newCaseLabel: UILabel!
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var labelStackView: UIStackView!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.indicatorView.startAnimating()
        // Do any additional setup after loading the view.
        self.fetchCovidOverView(completionHandler: { [weak self] result in
            
            // 스트롱 레퍼런스로 일시적으로 만들어서 사용하는 방법
            guard let self = self else {return}
            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true
            self.labelStackView.isHidden = false
            self.pieChartView.isHidden = false
            
            switch result{
            case let.success(result):
                //debugPrint(result)
                self.configureStackView(koreaCodvidOverView: result.korea)
                let covidOverViewList = self.makeCovidOverviewList(cityOverView: result)
                self.configureChart(covidOverViewList: covidOverViewList)
                
            case let .failure(error):
                debugPrint(error)
                

            }
            
            
            
        })
    }
    func configureStackView(koreaCodvidOverView : CovidOverView){
        self.totalCaseLabel.text = "\(koreaCodvidOverView.totalCase) 명"
        self.newCaseLabel.text  = "\(koreaCodvidOverView.newCase) 명"
    }
    
    func makeCovidOverviewList(cityOverView : CityCovidOverView) ->[CovidOverView]{
        return [
            cityOverView.seoul,
            cityOverView.busan,
            cityOverView.daegu,
            cityOverView.incheon,
            cityOverView.gwangju,
            cityOverView.daejeon,
            cityOverView.ulsan,
            cityOverView.sejong,
            cityOverView.gyeonggi,
            cityOverView.chungbuk,
            cityOverView.chungnam,
            cityOverView.gyeongbuk,
            cityOverView.gyeongnam,
            cityOverView.jeju,
            
        ]
    }
    
    func configureChart(covidOverViewList : [CovidOverView]){
        
        self.pieChartView.delegate = self
        
        let entries = covidOverViewList.compactMap{ [weak self] overview ->PieChartDataEntry? in
            guard let self = self else {return nil}
            return PieChartDataEntry(value: self.removeFormetString(string: overview.newCase) , label: overview.countryName, data: overview)
        }
        
        let dataSet = PieChartDataSet(entries: entries,label: "코로나 발생 현황")
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        dataSet.valueTextColor = .black
        
        dataSet.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + ChartColorTemplates.material()
        
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        self.pieChartView.spin(duration: 0.3, fromAngle: self.pieChartView.rotationAngle, toAngle: self.pieChartView.rotationAngle + 80)
    }
    
    func removeFormetString(string : String) -> Double{
        let fommatter = NumberFormatter()
        fommatter.numberStyle = .decimal
        return fommatter.number(from: string)?.doubleValue ?? 0
    }
    
    
    
    // 이스케이핑 클로져 사용 ( 비동기 작업에서 주로사용 한다고 한다 ), 함수가 반환된 후에도 실행되게 하려고 @escaping
    func fetchCovidOverView(  completionHandler : @escaping (Result<CityCovidOverView,Error>) -> Void ){
        let url  = "https://api.corona-19.kr/korea/country/new/?serviceKey="
        let param = [
            "serviceKey":"FEfhUbAp4nSxa1GcQJ7Z5e9I2tBL8kCdy"
        ]
        
        AF.request(url, method: .get, parameters: param)
            .responseData( completionHandler: {responds in
             
                switch responds.result{
                case let .success(data) :
                    do{
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverView.self, from: data)
                        completionHandler(.success(result))
                    }catch{
                        completionHandler(.failure(error))
                    }
                    
                case let .failure(error): completionHandler(.failure(error))
                }
                
                
            })
        
        
    }


}
extension ViewController : ChartViewDelegate{
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let covidDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "CovidDetailViewController") as? CovidDetailViewController else {return}
        
        guard let covidOverview = entry.data as? CovidOverView else { return }
        covidDetailViewController.covidOverView = covidOverview
        self.navigationController?.pushViewController(covidDetailViewController, animated: true)
    }
   
}

