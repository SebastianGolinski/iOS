import Foundation
import SnapKit

protocol UserDataSourceDelagate {
    func didSelect(_ user: DetailUserGithub)
}

class UserDataSource: NSObject, UITableViewDelegate, UITableViewDataSource{
    var delgate: UserDataSourceDelagate?
    var userDictonary = [String: [DetailUserGithub]]()
    var searchUser = [DetailUserGithub]()
    var isSearching = false
    var userSectionTitle = [String]()

    var userList = [DetailUserGithub](){
        didSet{
            self.userList = self.userList.sorted(by:  {$0.login.lowercased() < $1.login.lowercased()})
        }
    }

    func createSection(){
        for user in userList{
            let key = String(user.login.prefix(1)).uppercased()
            if (userDictonary[key] != nil){
                userDictonary[key]?.append(user )
            }else{
                userDictonary[key] = [user]
            }
        }
        userSectionTitle = [String](userDictonary.keys)
        userSectionTitle = userSectionTitle.sorted(by: {$0.uppercased() < $1.uppercased()})
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return searchUser.count
        }
        else{
            let userKey = userSectionTitle[section]
            if let userValue = userDictonary[userKey]{
                return userValue.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
        var user: DetailUserGithub
        if isSearching{
            user = searchUser[indexPath.row]
        }else{
            user = getCurrentUser(section: indexPath.section, row: indexPath.row)
        }
        cell.nameUser.text = user.login
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearching{
            return "Search User"
        }else{
            return userSectionTitle[section]
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching{
            return 1
            
        }else{
            return userSectionTitle.count
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexCur = getCurrentUserIndex(section: indexPath.section, row: indexPath.row)
        if isSearching{
            delgate?.didSelect(searchUser[indexPath.row])
        }else{
            delgate?.didSelect(userList[indexCur])
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        headerView.contentView.backgroundColor = UIColor.lightGray
        headerView.textLabel?.textColor = UIColor.black
        return headerView
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isSearching{
            return nil
        }else{
            tableView.sectionIndexColor = UIColor.black
            return userSectionTitle
        }
    }
    
    func getCurrentUser(section: Int, row: Int) -> DetailUserGithub{
        let userKey = userSectionTitle[section]
        var user = userList[0]
        if let userValue = userDictonary[userKey]{
            user = userValue[row]
        }
        return user
    }

    func getCurrentUserIndex(section: Int, row: Int) -> Int{
        if isSearching{
            var index = 0
            let user = searchUser[row]
            if let i = userList.firstIndex(where: { ($0.login == user.login)}){
                index = i
            }
            return index
        }else{
            var index = 0
            let user = getCurrentUser(section: section, row: row)
            if let i = userList.firstIndex(where: { ($0.login == user.login)}){
                index = i
            }
            return index
        }
    }
}
