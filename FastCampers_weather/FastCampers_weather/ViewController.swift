
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTxt: UITextField!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var maxLabel: UILabel!
    
    @IBOutlet weak var minLabel: UILabel!
    
    @IBOutlet weak var weatherStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    func configureView(weatherInfo : WeatherInfomation){
        self.cityNameTxt.text = weatherInfo.name
    
        if let weathe = weatherInfo.weather.first{
            self.weatherDescriptionLabel.text = weathe.description
        }
        
        self.tempLabel.text = "\(Int(weatherInfo.temp.temp - 237.15)) 도"
        self.minLabel.text = "최저 : \(Int(weatherInfo.temp.minTemp - 273.15)) 도"
        self.maxLabel.text = "최고 : \(Int(weatherInfo.temp.maxTemp - 273.15)) 도"
    }
   
    @IBAction func tapFetchWeatherBtn(_ sender: UIButton) {
        if let cityName = self.cityNameTxt.text{
            self.getCurrentWeather(ctiyName: cityName)
            self.view.endEditing(true) // 키보드를 숨김
        }
        
       
    }
    
    func getCurrentWeather(ctiyName : String){
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(ctiyName)&appid=50137e1de048d4c02aa1d76504ec1885") else { return}
      //  guard let url2 = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=seoul&appid=50137e1de048d4c02aa1d76504ec1885") else {return}
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url){  [weak self] data,response,error in
            
            let successRange = (200 ..< 299)
            guard let data = data, error == nil else {return}
            let decoder = JSONDecoder()
    
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode){
                guard let weatherInfomation = try? decoder.decode(WeatherInfomation.self, from: data) else {return}
               // debugPrint(weatherInfomation)
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = true
                    self?.configureView(weatherInfo: weatherInfomation)
                }
            }else{
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else {return}
                
                DispatchQueue.main.async {
                    self?.showAlert(msg : errorMessage.message)
                }
                
            }
            
            
          
        }.resume()
        
        
    }
    
    func showAlert(msg : String){
        let alert = UIAlertController(title: "에러", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

