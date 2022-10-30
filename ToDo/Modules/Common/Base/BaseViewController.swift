import UIKit

class BaseViewController<T: UIView>: UIViewController {

    var baseView: T { view as! T }
    
    override func loadView() {
        view = T()
        setDelegates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() { }
    func setDelegates() { }
}
