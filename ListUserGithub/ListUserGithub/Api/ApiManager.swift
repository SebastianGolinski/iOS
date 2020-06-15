import Combine
import Alamofire

class ApiManager{
    public static let sharedInstance = ApiManager()
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
        guard let url = URL(string: "https://api.github.com/search/users?q=\(searchTextField)")else {fatalError()}
        AF.request(url).validate().responseJSON { (response) in
            do{
                let users = try JSONDecoder().decode(SearchUserGitHub.self, from: response.data!)
                var results = users.items
                results = results.sorted(by:  {$0.login.lowercased() < $1.login.lowercased()})
                completion(.success(results))
            }catch let error{
                print(error)
            }
        }
    }
}

enum UserGithubError:Error{
    case notDataAvaible
    case canNotProcessData
}
