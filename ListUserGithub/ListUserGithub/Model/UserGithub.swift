
import Foundation

class DetailUserGithub: Decodable{
    var login: String
    var avatar_url: String
}
class SearchUserGitHub: Decodable {
    var items: [DetailUserGithub]
}

