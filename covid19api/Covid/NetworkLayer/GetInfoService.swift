//
//  GetInfoService.swift
//  covid19api
//
//  Created by Anzori Katsitadze on 8/5/20.
//  Copyright © 2020 Anzori Katsitadze. All rights reserved.
//

import Foundation

struct GetInfoService: RequestType {
    let path: String
    typealias ResponseType = BaseResponse
    var data: RequestData {
        get {
            var request = RequestData(path: path)
            request.method = .get
            return request
        }
    }
}

struct BaseResponse: Decodable {
    let objectIdFieldName: String?
    let globalIdFieldName: String?
    let geometryType: String?
    let features: [Feature]?
}

class Feature: NSObject, NSCoding, Decodable {
    let attributes: Attribute?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(attributes, forKey: "attributes")
    }
    
    required init (coder aDecoder: NSCoder) {
        self.attributes = (aDecoder.decodeObject(forKey: "attributes") as! Attribute)
    }
}

class Attribute: NSObject, NSCoding, Decodable {
    let objectId: Int?
    let country_Region: String?
    let confirmed: Int?
    let deaths: Int?
    let recovered: Int?
    let active: Int?
    let incident_Rate: Double?
    let mortality_Rate: Double?
    
    enum CodingKeys: String, CodingKey {
        case objectId = "OBJECTID"
        case country_Region = "Country_Region"
        case confirmed = "Confirmed"
        case deaths = "Deaths"
        case recovered = "Recovered"
        case active = "Active"
        case incident_Rate = "Incident_Rate"
        case mortality_Rate = "Mortality_Rate"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(objectId, forKey: CodingKeys.objectId.rawValue)
        aCoder.encode(country_Region, forKey: CodingKeys.country_Region.rawValue)
        aCoder.encode(confirmed, forKey: CodingKeys.confirmed.rawValue)
        aCoder.encode(deaths, forKey: CodingKeys.deaths.rawValue)
        aCoder.encode(recovered, forKey: CodingKeys.recovered.rawValue)
        aCoder.encode(active, forKey: CodingKeys.active.rawValue)
        aCoder.encode(incident_Rate, forKey: CodingKeys.incident_Rate.rawValue)
        aCoder.encode(mortality_Rate, forKey: CodingKeys.mortality_Rate.rawValue)
    }
    
    required init (coder aDecoder: NSCoder) {
        self.objectId = (aDecoder.decodeObject(forKey: CodingKeys.objectId.rawValue) as? Int)
        self.country_Region = (aDecoder.decodeObject(forKey: CodingKeys.country_Region.rawValue) as? String)
        self.confirmed = (aDecoder.decodeObject(forKey: CodingKeys.confirmed.rawValue) as? Int)
        self.deaths = (aDecoder.decodeObject(forKey: CodingKeys.deaths.rawValue) as? Int)
        self.recovered = (aDecoder.decodeObject(forKey: CodingKeys.recovered.rawValue) as? Int)
        self.active = (aDecoder.decodeObject(forKey: CodingKeys.active.rawValue) as? Int)
        self.incident_Rate = (aDecoder.decodeObject(forKey: CodingKeys.incident_Rate.rawValue) as? Double)
        self.mortality_Rate = (aDecoder.decodeObject(forKey: CodingKeys.mortality_Rate.rawValue) as? Double)
    }
}
