
import Combine
import Alamofire
import SwiftyJSON

struct UserRequset{
    
    let resourceUrl: URL
    let API_KEY = "https://api.github.com/users"
    
    
    init() {
        guard let resourceUrl = URL(string: API_KEY) else {fatalError()}
        self.resourceUrl = resourceUrl
        
    }
    func getUser (completion: @escaping(Result<[DetailUserGithub],UserGithubError>) -> Void ){
               
        AF.request(resourceUrl).validate().responseJSON { (data) in
        let json = try! JSON(data: data.data!)
        var listU: [DetailUserGithub] = []
        for i in json{
            //DetailUserGithub.app
            listU.append(DetailUserGithub(login: i.1["login"].stringValue, avatar_url: i.1["avatar_url"].stringValue))
        }
        completion(.success(listU))

        }
    }

}

enum UserGithubError:Error{
    case notDataAvaible
    case canNotProcessData
}
