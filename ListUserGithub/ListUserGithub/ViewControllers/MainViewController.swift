import UIKit
import SnapKit

class MainViewController: UIViewController {
    var isSearching = false
    let dataSource = UserDataSource()

    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.6 , alpha: 0.4)
        view.layer.cornerRadius = 10
        return view
    }()
    
    let naviView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 30
        return view
    }()
    
    let titleLable: UILabel = {
        let label = UILabel()
        label.textColor  = UIColor.white
        label.text = "User Github"
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 35)
        return label
    }()
    
    let searchBar: UISearchBar = {
        let sB = UISearchBar()
        sB.searchBarStyle = UISearchBar.Style.minimal
        sB.searchTextField.backgroundColor = UIColor.white
        sB.placeholder = "Search User"
        sB.searchTextField.textColor = UIColor.black
        return sB
    }()
    
    let tableUser: UITableView = {
        let tUser = UITableView()
        return tUser
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableUser.backgroundColor = UIColor.clear
        searchBar.delegate = self
        dataSource.delgate = self
        ApiManager.sharedInstance.getUsers { result in
            switch result{
            case .failure(let error):
                print("load list: ",  error)
            case .success(let user):
                self.dataSource.userList = user
                self.dataSource.createSection()
                self.tableUser.reloadData()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        ApiManager.sharedInstance.getUsers { result in
            switch result{
            case .failure(let error):
                print("load list: ",  error)
            case .success(let user):
                self.dataSource.userList = user
                self.tableUser.reloadData()
            }
        }
    }

    func  setupView() {
        view.addSubview(mainView)
        view.addSubview(naviView)
        naviView.addSubview(titleLable)
        mainView.addSubview(searchBar)
        mainView.addSubview(tableUser)
        
        mainView.snp.makeConstraints{(make) in
            make.top.equalTo(naviView.snp_bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        naviView.snp.makeConstraints{(make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
            make.left.equalTo(30)
            make.right.equalTo(-30)
        }
        
        titleLable.snp.makeConstraints{(make) in
            make.center.equalTo(naviView)
        }
        
        searchBar.snp.makeConstraints{(make) in
            make.height.equalTo(50)
            make.top.equalTo(mainView.snp_top).offset(5)
            make.width.equalTo(mainView)
        }

        tableUser.delegate = dataSource
        tableUser.dataSource = dataSource
        tableUser.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        
        tableUser.snp.makeConstraints{(make) in
            make.top.equalTo(searchBar.snp_bottom).offset(5)
            make.bottom.equalTo(mainView).offset(-5)
            make.left.equalTo(mainView).offset(0)
            make.right.equalTo(mainView).offset(0)
        }
    }
}

extension MainViewController: UserDataSourceDelagate{
    func didSelect(_ user: DetailUserGithub) {
        let vCdetailUser = UserDetailViewController()
        vCdetailUser.userLogin = user.login
        vCdetailUser.userAvatar = user.avatar_url
        let naviControler = UINavigationController(rootViewController: vCdetailUser)
        navigationController?.modalPresentationStyle = .fullScreen
        self.present(naviControler,animated: true)
    }
}

extension MainViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != nil && searchBar.text != "" {
            ApiManager.sharedInstance.searchUsers(searchTextField: searchBar.text!) { result in
                switch result{
                case .failure(let error):
                    print("search list: ",  error)
                case .success(let user):
                    self.dataSource.searchUser = user
                    self.dataSource.isSearching = true
                    self.tableUser.reloadData()
                }
            }
        }else{
            dataSource.isSearching = false
            tableUser.reloadData()
        }
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
        dataSource.isSearching = false
        self.dataSource.searchUser.removeAll()
        tableUser.reloadData()
    }
}
