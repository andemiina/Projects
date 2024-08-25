import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    
    //MARK: - Outlets and Variables
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    
    private var presenter: MovieQuizPresenter?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        setupFonts()
        showLoadingIndicator()

    }
    
    //MARK: - Action
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter?.yesButtonClicked()
        disableButtons()
    }
    
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter?.noButtonClicked()
        disableButtons()
    }
    
    //MARK: - Funcs
    
    private func setupFonts() {
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        
        if let customFont = UIFont(name: "YSDisplay-Medium", size: 20) {
            counterLabel.font = customFont
            yesButton.titleLabel?.font = customFont.withSize(20)
            noButton.titleLabel?.font = customFont.withSize(20)
        }
    }
    
    func show(quiz step: QuizStepViewModel) {
        resetBorder()
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
          let message = presenter?.makeResultsMessage()

          let alert = UIAlertController(
              title: result.title,
              message: message,
              preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Game results"

              let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                  guard let self = self else { return }

                  self.presenter?.restartGame()
              }
        alert.view.accessibilityIdentifier = "Game results"

          alert.addAction(action)

          self.present(alert, animated: true, completion: nil)
      }
  
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Попробоваться еще раз", style: .default) 
        { [ weak self ] _ in
            guard let self = self else { return }
            
            self.presenter?.resetQuestionIndex()
        }
        alert.addAction(action)
    }
    
    func resetBorder() {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
    }
    
   
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func enableButtons() {
        self.yesButton.isEnabled = true
        self.noButton.isEnabled = true
    }
    
    func disableButtons() {
        self.yesButton.isEnabled = false
        self.noButton.isEnabled = false
    }
    
}


