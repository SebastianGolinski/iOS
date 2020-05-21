
import SnapKit
import UIKit

class CustomCell: UITableViewCell {
    static var customCell = "cellUser"
    
    let avatarUser: UIImageView = {
        let av = UIImageView()
        av.image = UIImage(named: "asd")
        return av
    }()
    
    let nameUser: UILabel = {
        let name = UILabel()
        name.text = "dddddddd"
        name.font = UIFont(name: "HelveticaNeue-Medium", size: 30)
        name.textColor = UIColor.black
        return name
    }()
    let boxCell: UIView = {
        let box = UIView()
        box.backgroundColor = UIColor.gray
        box.layer.cornerRadius = 20
        box.layer.borderWidth = 2
        box.layer.borderColor = UIColor.black.cgColor
        box.clipsToBounds = true
        return box
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        setupView()
    }
    
    private func setupView(){
        self.addSubview(boxCell)
        
        boxCell.addSubview(nameUser)
        boxCell.addSubview(avatarUser)
        
        boxCell.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
            make.bottom.equalTo(-10)
            make.top.equalTo(10)
        }
        nameUser.snp.makeConstraints{(make) in
            make.height.equalTo(50)
            make.bottom.equalTo(boxCell)
            make.centerX.equalTo(boxCell)
        }
        avatarUser.snp.makeConstraints{(make) in
            make.top.equalTo(boxCell)
            make.bottom.equalTo(nameUser.snp_top)
            make.left.right.equalTo(boxCell)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("err")
    }
}
