
import UIKit
import SnapKit


class ViewControllerDetailUser: UIViewController {
    static var detialUser = "DetailUser"
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        nameLable.text = allUserList[indexCur].login
        guard let resourceUrl = URL(string: allUserList[indexCur].avatar_url) else {fatalError()}
        setImage(resourceUrl, placeImage: avatarUser)
    }
    func setImage(_ photoURL: URL?, placeImage: UIImageView?){
        guard let imageURL = photoURL else { return  }
        DispatchQueue.global(qos: .userInitiated).async {
            do{
                let imageData: Data = try Data(contentsOf: imageURL)
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)
                    placeImage?.image = image
                }
            }catch{
                print("Unable to load data: \(error)")
            }
        }
        
    }
    func  setupView() {
        view.backgroundColor = UIColor.lightGray
        self.navigationController!.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
        self.navigationController?.navigationBar.topItem?.title = "User"
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-Medium", size: 20)!
        ]

        view.addSubview(mainView)
        view.addSubview(nameView)
        nameView.addSubview(nameLable)
        mainView.addSubview(avatarUser)
        
        mainView.snp.makeConstraints{(make) in
            make.top.equalTo(nameView.snp_bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        nameView.snp.makeConstraints{(make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.height.equalTo(60)
            make.left.equalTo(30)
            make.right.equalTo(-30)
        }
        
        nameLable.snp.makeConstraints{(make) in
            make.center.equalTo(nameView)
        }
        
        avatarUser.snp.makeConstraints { (make) in
            make.left.equalTo(mainView).offset(20)
            make.right.equalTo(mainView).offset(-20)
            make.bottom.equalTo(-20)
            make.height.equalTo(400)
        }
    }
    
    let mainView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    let nameView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 30
        return view
    }()
    
    let nameLable: UILabel = {
        let label = UILabel()
        label.textColor  = UIColor.white
        label.text = "User "
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 35)
        return label
    }()
    
    let avatarUser: UIImageView = {
        let av = UIImageView()
        av.contentMode  = .scaleAspectFill
        av.layer.borderWidth = 3
        av.layer.borderColor = UIColor.black.cgColor
        av.layer.cornerRadius = 15
        av.layer.masksToBounds = true
        return av
    }()
    
    let buttonReturn: UIBarButtonItem = {
        let btn = UIBarButtonItem()
        btn.title = "Return"
        btn.style = .plain
        btn.target = nil
        btn.action = nil
        return btn
    }()
}
