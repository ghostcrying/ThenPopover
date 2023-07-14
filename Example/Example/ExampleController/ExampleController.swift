import UIKit

class PopoverController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        
        self.view.heightAnchor.constraint(equalToConstant: 240).isActive = true
        self.view.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
    }

}
