
import Combine
import Alamofire

struct UserRequset{
    
    let resourceUrl: URL
    let API_KEY = "https://api.github.com/users"
    
    init() {
        guard let resourceUrl = URL(string: API_KEY) else {fatalError()}
        self.resourceUrl = resourceUrl
    }
    
    func getUsers (completion: @escaping(Result<[DetailUserGithub],UserGithubError>) -> Void ){
        AF.request(resourceUrl).validate().responseJSON { (response) in
            let users = try! JSONDecoder().decode([DetailUserGithub].self, from: response.data!)
            
        completion(.success(users))
        }
    }
    func searchUsers(searchTextField: String, completion: @escaping(Result<[DetailUserGithub],UserGithubError>) -> Void ){
        AF.request(resourceUrl).validate().responseJSON { (response) in
            let users = try! JSONDecoder().decode([DetailUserGithub].self, from: response.data!)
            var results = users.filter{$0.login.replacingOccurrences(of: " ", with: "").lowercased().contains(searchTextField.replacingOccurrences(of: " ", with: "").lowercased())}
            
            results = results.sorted(by:  {$0.login.lowercased() < $1.login.lowercased()})

            completion(.success(results))
        }
    }
}

enum UserGithubError:Error{
    case notDataAvaible
    case canNotProcessData
}
