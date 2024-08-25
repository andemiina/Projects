
import Foundation

protocol AlertPresenterDelegate: AnyObject {
    func show(quiz result: AlertModel)
}
