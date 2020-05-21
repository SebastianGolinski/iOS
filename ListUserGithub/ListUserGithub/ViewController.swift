//
//  ViewController.swift
//  ListUserGithub
//
//  Created by Sebastian Golinski on 15/04/2020.
//  Copyright © 2020 Sebastian Golinski. All rights reserved.
//

import UIKit
import SnapKit

var indexCur: Int = 0
var allUserList = [DetailUserGithub]()
var userDictonary = [String: [DetailUserGithub]]()
var userSectionTitle = [String]()
var isSearching = false
var searchUser = [DetailUserGithub]()

class ViewController: UIViewController {
 

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
        //sB.searchTextField.text = "Search user"
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
                allUserList = self.userList
                allUserList = allUserList.sorted(by:  {$0.login.lowercased() < $1.login.lowercased()})
                self.tableUser.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        tableUser.backgroundColor = UIColor.clear

        searchBar.delegate = self
        let userRequest = UserRequset()
        userRequest.getUser { result in
            switch result{
            case .failure(let error):
                print("pobranie listy: ",  error)
            case .success(let user):
                self.userList = user
                self.CreateSection()
            }
        }
        
    }
    
    func CreateSection(){

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

    func FilterSearchList(searchText: String){
        if searchText.count > 0{
            allUserList = self.userList
            let filterUsersList = allUserList.filter{
                $0.login.replacingOccurrences(of: " ", with: " ").lowercased().contains(searchText.replacingOccurrences(of: " ", with: " ").lowercased())
            }
            allUserList = filterUsersList
        }else{
            allUserList = self.userList
        }
        //CreateSection()
        tableUser.reloadData()

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
var imageCrop: CGFloat = 1

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
        setImage(user.avatar_url, placeImage: cell.avatarUser)
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return ((tableView.frame.width)/imageCrop)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexCur = getCurrentUserIndex(section: indexPath.section, row: indexPath.row)
        let naviControler = UINavigationController(rootViewController: ViewControllerDetailUser())
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
    func setImage(_ photoURL: String, placeImage: UIImageView){
        guard let resourceUrl = URL(string: photoURL) else {fatalError()}
        DispatchQueue.global(qos: .userInitiated).async {
            do{
                let imageData: Data = try Data(contentsOf: resourceUrl)
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)
                    placeImage.image = image
                    imageCrop = (image?.getCropRatio())!
                }
            }catch{
                print("Unable to load data: \(error)")
            }
        }
    }
    func getCurrentUser(section: Int, row: Int) -> DetailUserGithub{
        let userKey = userSectionTitle[section]
        var user = allUserList[0]
        if let userValue = userDictonary[userKey]{
            user = userValue[row]
        }
        return user
    }
    func getCurrentUserIndex(section: Int, row: Int) -> Int{
        if isSearching{
            var index = 0
            let user = searchUser[row]
            if let i = allUserList.firstIndex(where: { ($0.login == user.login)}){
                index = i
            }
               return index
        }else{
            var index = 0
            let user = getCurrentUser(section: section, row: row)
            if let i = allUserList.firstIndex(where: { ($0.login == user.login)}){
                index = i
            }
            return index
        }
    }
}

extension UIImage{
    func getCropRatio() -> CGFloat{
        let widthRatio = CGFloat(self.size.width / self.size.height)
        return widthRatio
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != nil && searchBar.text != "" {
            isSearching = true
            searchUser = allUserList.filter{$0.login.replacingOccurrences(of: " ", with: "").lowercased().contains(searchText.replacingOccurrences(of: " ", with: "").lowercased())}
        }else{
            isSearching = false
        }
        tableUser.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
    
}
