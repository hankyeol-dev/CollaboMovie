//
//  CreditResponseDTO.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/9/24.
//

import Foundation

struct CreditResponseDTO: Decodable {
    struct Cast: Decodable {
        let adult: Bool
        let gender: Int
        let id: Int
        let department: String
        let name: String
        let originalName: String
        let popularity: Double
        let profilePath: String
        let character: String
        let creditId: String
        let order: Int
        
        enum CodingKeys: String, CodingKey {
            case adult
            case gender
            case id
            case department = "known_for_department"
            case name
            case originalName = "original_name"
            case popularity
            case profilePath = "profile_path"
            case character
            case creditId = "credit_id"
            case order
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<CreditResponseDTO.Cast.CodingKeys> = try decoder.container(keyedBy: CreditResponseDTO.Cast.CodingKeys.self)
            self.adult = try container.decode(Bool.self, forKey: CreditResponseDTO.Cast.CodingKeys.adult)
            self.gender = try container.decode(Int.self, forKey: CreditResponseDTO.Cast.CodingKeys.gender)
            self.id = try container.decode(Int.self, forKey: CreditResponseDTO.Cast.CodingKeys.id)
            self.department = try container.decode(String.self, forKey: CreditResponseDTO.Cast.CodingKeys.department)
            self.name = try container.decode(String.self, forKey: CreditResponseDTO.Cast.CodingKeys.name)
            self.originalName = try container.decode(String.self, forKey: CreditResponseDTO.Cast.CodingKeys.originalName)
            self.popularity = try container.decode(Double.self, forKey: CreditResponseDTO.Cast.CodingKeys.popularity)
            self.profilePath = try container.decodeIfPresent(String.self, forKey: CreditResponseDTO.Cast.CodingKeys.profilePath) ?? ""
            self.character = try container.decode(String.self, forKey: CreditResponseDTO.Cast.CodingKeys.character)
            self.creditId = try container.decode(String.self, forKey: CreditResponseDTO.Cast.CodingKeys.creditId)
            self.order = try container.decode(Int.self, forKey: CreditResponseDTO.Cast.CodingKeys.order)
        }
    }
    
    struct Crew: Decodable {
        let adult: Bool
        let gender: Int
        let id: Int
        let name: String
        let originalName: String
        let popularity: Double
        let profilePath: String
        let creditId: String
        let department: String
        let job: String
        
        enum CodingKeys: String, CodingKey {
            case adult
            case gender
            case id
            case name
            case originalName = "original_name"
            case popularity
            case profilePath = "profile_path"
            case creditId = "credit_id"
            case department
            case job
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<CreditResponseDTO.Crew.CodingKeys> = try decoder.container(keyedBy: CreditResponseDTO.Crew.CodingKeys.self)
            self.adult = try container.decode(Bool.self, forKey: CreditResponseDTO.Crew.CodingKeys.adult)
            self.gender = try container.decode(Int.self, forKey: CreditResponseDTO.Crew.CodingKeys.gender)
            self.id = try container.decode(Int.self, forKey: CreditResponseDTO.Crew.CodingKeys.id)
            self.name = try container.decode(String.self, forKey: CreditResponseDTO.Crew.CodingKeys.name)
            self.originalName = try container.decode(String.self, forKey: CreditResponseDTO.Crew.CodingKeys.originalName)
            self.popularity = try container.decode(Double.self, forKey: CreditResponseDTO.Crew.CodingKeys.popularity)
            self.profilePath = try container.decodeIfPresent(String.self, forKey: CreditResponseDTO.Crew.CodingKeys.profilePath) ?? ""
            self.creditId = try container.decode(String.self, forKey: CreditResponseDTO.Crew.CodingKeys.creditId)
            self.department = try container.decode(String.self, forKey: CreditResponseDTO.Crew.CodingKeys.department)
            self.job = try container.decode(String.self, forKey: CreditResponseDTO.Crew.CodingKeys.job)
        }
    }
    
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
}

extension CreditResponseDTO {
   func toCastGroup() -> [DetailCastAndDirect] {
      cast.prefix(3).map { .init(name: $0.name) }
   }
   
   func toDirectGroup() -> [DetailCastAndDirect] {
      crew.prefix(3).map { .init(name: $0.name) }
   }
}
