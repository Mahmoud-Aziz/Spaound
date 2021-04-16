

import Foundation
import FirebaseDatabase


final class SpacesDatabaseManager {
    
    var spaces:[SpaceInfo]?
    
    static let shared = SpacesDatabaseManager()
    private let database = Database.database().reference()
    
}

//MARK: -Space Info Management

extension SpacesDatabaseManager {
    
    public func getAllSpaces(completion: @escaping (Result<[[String:Any]], Error>,[SpaceInfo]) -> Void) {

        let space:[SpaceInfo] = []
        database.child("spaces").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String:Any]] else {
                completion(.failure(DatabaseError.failedToFetch), space)
                return
            }
            let data = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
            let spaces = try! JSONDecoder().decode([SpaceInfo].self, from: data)
            completion(.success(value),spaces)
        })
    }
    
    public func retrieveSpaces(completion: @escaping (Result<[SpaceInfo], Error>) -> Void) {
        database.child("spaces").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            
            guard let value = snapshot.value as? [[String:Any]] else {
                
                completion(.failure(DatabaseError.failedToFetch))
                print("error retrieving data from firebase")
                return
            }
            
            do {
                let data = try! JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                let spaces = try! JSONDecoder().decode([SpaceInfo].self, from: data)
                
                self?.spaces = spaces
                completion(.success(spaces))
                
            } catch let error {
                print("error retrieving \(error.localizedDescription)")
            }
        })
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
    }
    
}
