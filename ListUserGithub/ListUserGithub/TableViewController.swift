import Foundation
import SnapKit

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.customCell, for: indexPath) as! CustomCell
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
        let vCdetailUser = ViewControllerDetailUser()
        vCdetailUser.userLogin = userList[indexCur].login
        vCdetailUser.userAvatar = userList[indexCur].avatar_url
        let naviControler = UINavigationController(rootViewController: vCdetailUser)
        navigationController?.modalPresentationStyle = .fullScreen
        self.present(naviControler,animated: true)
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
