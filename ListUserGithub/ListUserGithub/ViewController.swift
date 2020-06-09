import UIKit
import SnapKit


class ViewController: UIViewController {
 
    var isSearching = false
    var userSectionTitle = [String]()
    var userDictonary = [String: [DetailUserGithub]]()
    var searchUser = [DetailUserGithub]()

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
    
    var userList = [DetailUserGithub](){
        didSet{
            DispatchQueue.main.async {
                self.userList = self.userList.sorted(by:  {$0.login.lowercased() < $1.login.lowercased()})
                self.tableUser.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableUser.backgroundColor = UIColor.clear
        searchBar.delegate = self
        UserRequset().getUsers { result in
            switch result{
            case .failure(let error):
                print("load list: ",  error)
            case .success(let user):
                self.userList = user
                self.createSection()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        UserRequset().getUsers { result in
            switch result{
            case .failure(let error):
                print("load list: ",  error)
            case .success(let user):
                self.userList = user
            }
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
        tableUser.delegate = self
        tableUser.dataSource = self
        tableUser.register(CustomCell.self, forCellReuseIdentifier: CustomCell.customCell)
        tableUser.snp.makeConstraints{(make) in
            make.top.equalTo(searchBar.snp_bottom).offset(5)
            make.bottom.equalTo(mainView).offset(-5)
            make.left.equalTo(mainView).offset(0)
            make.right.equalTo(mainView).offset(0)

        }
    }
}
