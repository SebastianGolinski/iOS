import Foundation
import SnapKit

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchUserFromGitHub()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        searchBar.text = ""
        isSearching = false
        self.searchUser.removeAll()
        tableUser.reloadData()

    }
    func searchUserFromGitHub(){
        if searchBar.text != nil && searchBar.text != "" {
            UserRequset().searchUsers(searchTextField: searchBar.text!) { result in
                switch result{
                case .failure(let error):
                    print("search list: ",  error)
                case .success(let user):
                    self.searchUser.removeAll()
                    self.searchUser = user
                    self.isSearching = true
                    self.tableUser.reloadData()
                }
            }
        }else{
            isSearching = false
            tableUser.reloadData()
        }
    }

    
}
