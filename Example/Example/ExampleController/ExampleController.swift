import UIKit

class PopoverController: UIViewController {

    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "我是自定义视图"
        label.textAlignment = .center
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        
        // 限定整体UI大小
        self.view.widthAnchor.constraint(equalToConstant: 240).isActive  = true
        self.view.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        /*
         // 也可以通过控件约束进行限定
         view.addSubview(label)
         NSLayoutConstraint.activate([
             label.leftAnchor.constraint(equalTo: view.leftAnchor),
             label.rightAnchor.constraint(equalTo: view.rightAnchor),
             label.topAnchor.constraint(equalTo: view.topAnchor),
             label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             label.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
         ])
         */
    }

}
