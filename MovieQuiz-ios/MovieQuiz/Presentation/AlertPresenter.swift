
import UIKit


//класс алерт презентера подписали на протокол
final class AlertPresenter: AlertPresenterProtocol {
    
    
//    weak var viewController: UI
    weak var delegate: UIViewController?
    
    init(delegate: UIViewController?) {
        self.delegate = delegate
    }
    
    
    func show(quiz result: AlertModel) {
      
        
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Game results"

        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion()
        }
        
        
        alert.view.accessibilityIdentifier = "Game results"
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}



