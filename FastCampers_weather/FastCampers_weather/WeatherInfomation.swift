
import Foundation


// 구조체
struct WeatherInfomation : Codable{
    // Codable 외부 표현으로 바꿀수 있게 해줌
    let weather : [Weather]
    let temp : Temp
    let name : String
    
    enum CodingKeys : String, CodingKey {
        case weather
        case temp =  "main"
        case name
    }
        
}

struct Weather  : Codable {
    let id : Int
    let main : String
    let description : String
    let icon : String
}


//coding keys 사용
struct Temp  : Codable {
    let temp : Double
    let feelsLike : Double
    let minTemp : Double
    let maxTemp : Double
    
    enum Codingkeys : String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}



