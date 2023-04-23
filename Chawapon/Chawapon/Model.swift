//
//  Model.swift
//  Chawapon
//
//  Created by chawapon.kiatpravee on 23/4/2566 BE.
//
enum Currency: String {
    case USD
    case GBP
    case EUR
}

struct BTCData: Codable {
    let time: Time?
    let disclaimer: String?
    let chartName: String?
    let bpi: BPI?
    
    enum CodingKeys: String, CodingKey {
        case time
        case disclaimer
        case chartName
        case bpi
    }
}

struct Time: Codable {
    let updated: String?
    let updatedISO: String?
    let updateduk: String?
    
    enum CodingKeys: String, CodingKey {
        case updated
        case updatedISO
        case updateduk
    }
}

struct BPI: Codable {
    let usd: BPIData?
    let gbp: BPIData?
    let eur: BPIData?
    
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
        case gbp = "GBP"
        case eur = "EUR"
    }
}

struct BPIData: Codable {
    let code: String?
    let symbol: String?
    let rate: String?
    let description: String?
    let rateFloat: Float?
   
    enum CodingKeys: String, CodingKey {
        case code
        case symbol
        case rate
        case description
        case rateFloat = "rate_float"
    }
}
