
import Foundation

struct ResponseModel<T: Codable>: Codable {
    let message: T
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decode(T.self, forKey: .message)
        status = try values.decode(String.self, forKey: .status)
    }
}
