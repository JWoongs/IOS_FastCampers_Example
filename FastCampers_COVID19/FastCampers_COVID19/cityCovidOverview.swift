//
//  cityCovidOverview.swift
//  FastCampers_COVID19
//
//  Created by Woong on 2022/06/22.
//

import Foundation

struct CityCovidOverView: Codable{
    let korea: CovidOverView
    let seoul : CovidOverView
    let busan : CovidOverView
    let daegu : CovidOverView
    let incheon : CovidOverView
    let gwangju : CovidOverView
    let daejeon : CovidOverView
    let ulsan : CovidOverView
    let sejong : CovidOverView
    let gyeonggi : CovidOverView
    let gangwon : CovidOverView
    let chungbuk : CovidOverView
    let chungnam : CovidOverView
    let jeonbuk : CovidOverView
    let gyeongbuk : CovidOverView
    let gyeongnam : CovidOverView
    let jeju : CovidOverView
    
    
}

struct CovidOverView : Codable{
    let countryName : String
    let newCase : String
    let totalCase : String
    let recovered: String
    let death : String
    let percentage : String
    let newCcase : String
    let newFcase: String
}
