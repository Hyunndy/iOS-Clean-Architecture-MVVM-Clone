//
//  DataTransferService.swift
//  iOS-Clean-Architecture-MVVM-Clone
//
//  Created by hyunndy on 2023/01/30.
//

import Foundation

/*
 네트워크를 통해 <데이터>를 주고받는 것에 관한 프로토콜 + 디폴트 매니저 클래스를 정의해놓음
 
 DataTransferService
    - request(endPoint: ResponseRequestable) T: Decodable
    - request T: Void
 
 ResponseRequestable
    - Requestable 채택
 
 Requestable
    - baseURL에 붙일 path, method, 여러 params
    - func urlRequest(with networkConfig: NetworkConfigurable)
 
 NetworkConfigurable
    - baseURL
    - headers
    - queryParameters
 
 
 DataTransferService에서 Request()를 호출하고,
 Request() 함수는 ResponseRequestable을 사용한다.
 ResponseRqeuatable은 기본적 NetworkConfig, 부가적인 Param, urlRequest()를 갖는다.
 
 */
public enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkingError(NetworkError)
    case resolvedNetworkFailure(Error)
}

public protocol DataTransferService {
    typealias CompletionHandler<T> = (Result<T, DataTransferError>) -> Void
    
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E, completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where E.Response == T
    
    func request<E: ResponseRequestable>(with endpoint: E, completion: @escaping CompletionHandler<Void>) -> NetworkCancellable? where E.Response == Void
}

public protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

/*
 AppDelegate에서 주입하는 데이터 통신 객체
 
 DataTransferService 채택하고, 이 서비스에서는
 request()에 필요한
    - completionHandler
    - HTTP 통신에 필요한 endpoint
 
 networkService
 -> Resolve, Logger이 뭐지!
 
 */
public final class DefaultDataTransferService {
    
    private let networkService: NetworkService
    private let errorResolver: DataTransferErrorResolver
    private let errorLogger: DataTransferErrorLogger
    
    public init(with networkService: NetworkService,
                errorResolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver(),
                errorLogger: DataTransferErrorLogger = DefaultDataTransferErrorLogger()) {
        self.networkService = networkService
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }
}

extension DefaultDataTransferService: DataTransferService {
    
    public func request<T: Decodable, E: ResponseRequestable>(with endpoint: E, completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where T : Decodable, T == E.Response, E : ResponseRequestable {
            
        /*
          여기서 네트워크 서비스가 나온다.
         데이터 통신 프로토콜의 request의 내부 구현을 networkService의 requet로 한다.
         */
        self.networkService.request(with: endpoint, completion: { result in
            
            switch result {
            case .success(let data):
                let result: Result<T, DataTransferError> = self.decode(data: data, decoder: endpoint.responseDecoder)
                DispatchQueue.main.async {
                    return completion(result)
                }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                DispatchQueue.main.async {
                    return completion(.failure(error))
                }
            }
        })
    }
    
    public func request<E>(with endpoint: E, completion: @escaping CompletionHandler<Void>) -> NetworkCancellable? where E : ResponseRequestable, E.Response == Void {
        
        self.networkService
            .request(with: endpoint, completion: { result in
                
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        return completion(.success(()))
                    }
                case .failure(let error):
                    self.errorLogger.log(error: error)
                    let error = self.resolve(networkError: error)
                    DispatchQueue.main.async {
                        return completion(.failure(error))
                    }
                }
            })
    }
    
    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) -> Result<T, DataTransferError> {
        do {
            guard let data = data else { return .failure(.noResponse) }
            
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            self.errorLogger.log(error: error)
            return .failure(.parsing(error))
        }
    }
    
    private func resolve(networkError error: NetworkError) -> DataTransferError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError ? .networkingError(error) : .resolvedNetworkFailure(resolvedError)
    }
}


public protocol DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error
}

// MARK: - Error Resolver
public class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    public init() { }
    
    public func resolve(error: NetworkError) -> Error {
        return error
    }
}

public protocol DataTransferErrorLogger {
    func log(error: Error)
}

// MARK: - Logger
public final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
    public init() { }
    
    public func log(error: Error) {
        print("-------------")
        print("\(error)")
    }
}
