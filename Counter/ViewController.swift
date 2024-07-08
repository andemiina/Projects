import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var counterValue: UILabel!
    @IBOutlet private weak var increaseValue: UIButton!
    @IBOutlet private weak var decreaseValue: UIButton!
    @IBOutlet private weak var resetValue: UIButton!
    @IBOutlet private weak var dateInfo: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private var counter: Int = 0
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        formatter.locale = Locale(identifier: "ru_Ru")
        return formatter
    }()
    
    
    @IBAction private func increaseValue(_ sender: Any) {
        let now = dateFormatter.string(from: Date())
        counter += 1
        counterValue.text = "Значение счетчика \(counter)"
        dateInfo.text += "\n[\(now)]: значение изменено на +1"
        
    }
    
    @IBAction private func decreaseValue(_ sender: Any) {
        let now = dateFormatter.string(from: Date())
        if counter > 0 {
            counter -= 1
            counterValue.text = "Значение счетчика \(counter)"
            dateInfo.text += "\n[\(now)]: значение изменено на -1"
        } else { counterValue.text = "Значение счетчика \(counter)"
            dateInfo.text += "\n[\(now)]: попытка уменьшить значение счётчика ниже 0"
        }
    }
    
    @IBAction private func resetValue(_ sender: Any) {
        let now = dateFormatter.string(from: Date())
        counter = 0
        counterValue.text = "Значение счетчика \(counter)"
        dateInfo.text += "\n[\(now)]: значение сброшено"
    }
    
}
