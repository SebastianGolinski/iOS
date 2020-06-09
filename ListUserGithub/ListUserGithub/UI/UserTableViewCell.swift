import SnapKit
import UIKit

class UserTableViewCell: UITableViewCell {
    static var identifier = "UserTableViewCell"
    
    let nameUser: UILabel = {
        let name = UILabel()
        name.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        name.textColor = UIColor.black
        return name
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        setupView()
    }
    
    private func setupView(){
        self.addSubview(nameUser)

        nameUser.snp.makeConstraints{(make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(-10)
            make.top.equalTo(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("err")
    }
}
