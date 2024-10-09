//
//  NetworkManager.swift
//  CollaborationTMDB
//
//  Created by Minjae Kim on 10/8/24.
//

import Foundation
import Moya

enum TMDBError: Error {
    case badRequest          // 400: 잘못된 요청. 클라이언트가 올바르지 않은 데이터를 보냈을 때.
    case unauthorized        // 401: 인증 실패. API 키 또는 사용자 인증이 잘못된 경우.
    case forbidden           // 403: 권한 없음. 요청이 허용되지 않는 경우.
    case notFound            // 404: 요청한 리소스를 찾을 수 없음.
    case methodNotAllowed    // 405: 지원되지 않는 메서드. 잘못된 HTTP 메서드가 사용된 경우.
    case notAcceptable       // 406: 허용되지 않는 형식. 클라이언트가 지원되지 않는 형식을 요청한 경우.
    case unprocessableEntity // 422: 처리할 수 없는 엔티티. 클라이언트가 유효하지 않은 데이터를 보낸 경우.
    case tooManyRequests     // 429: 요청 한도를 초과했을 때.
    case internalServerError // 500: 서버 내부 오류.
    case notImplemented      // 501: 구현되지 않은 기능.
    case badGateway          // 502: 잘못된 게이트웨이. 서버 간 통신에서 문제가 발생한 경우.
    case serviceUnavailable  // 503: 서비스가 일시적으로 중단된 경우.
    case gatewayTimeout      // 504: 게이트웨이 타임아웃. 서버가 응답하지 않을 때.
    case connect(error: MoyaError)
    case decoding(error: Error)
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func request<T: Decodable>(
        _ target: TMDBRouter,
        of type: T.Type,
        completionHandler: @escaping (Result<T, TMDBError>) -> Void
    ) {
        let provider = MoyaProvider<TMDBRouter>()
        
        provider.request(target) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    do {
                        let result = try response.map(type.self)
                        completionHandler(.success(result))
                    } catch {
                        completionHandler(.failure(.decoding(error: error)))
                    }
                } else {
                    completionHandler(.failure(errorHandling(statusCode: response.statusCode)))
                }
            case .failure(let error):
                completionHandler(.failure(.connect(error: error)))
            }
        }
    }
}

extension NetworkManager {
    private func errorHandling(statusCode: Int) -> TMDBError {
        switch statusCode {
        case 400: .badRequest
        case 401: .unauthorized
        case 403: .forbidden
        case 404: .notFound
        case 405: .methodNotAllowed
        case 406: .notAcceptable
        case 422: .unprocessableEntity
        case 429: .tooManyRequests
        case 500: .internalServerError
        case 501: .notImplemented
        case 502: .badGateway
        case 503: .serviceUnavailable
        case 504: .gatewayTimeout
        default: .badGateway
        }
    }
}
