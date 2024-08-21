import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    //MARK: - Outlets and Variables
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    
    
//    private var currentQuestionIndex = 0
    private var correctAnswers = 0
//    private let questionAmount: Int = 10
    private  lazy var questionFactory: QuestionFactoryProtocol = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
    private var currentQuestion: QuizQuestion?
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(delegate: self)
    private lazy var statisticService: StatisticServiceProtocol = StatisticService()
    private let presenter = MovieQuizPresenter()
    
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFonts()
        questionFactory.requestNextQuestion()
        showLoadingIndicator()
        questionFactory.loadData()
    }
    
    //MARK: - QuestionFactoryDelegate
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        show(quiz: viewModel)
//        DispatchQueue.main.async { [weak self] in
//            self?.show(quiz: viewModel)}
        
    }
    
    
    //MARK: - Action
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    //MARK: - Private Funcs
    
    private func setupFonts() {
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        
        if let customFont = UIFont(name: "YSDisplay-Medium", size: 20) {
            counterLabel.font = customFont
            yesButton.titleLabel?.font = customFont.withSize(20)
            noButton.titleLabel?.font = customFont.withSize(20)
        }
    }
//    
//    private func convert(model: QuizQuestion) -> QuizStepViewModel {
//        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
//                                 question: model.text,
//                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)")
//    }
    
    
    //функция показа индикатора загрузки
    private func showLoadingIndicator() {
//        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() //включаем анимацию
    }
    
    //функция скрытия индикатора загрузки
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()  //выключаем анимацию
//        activityIndicator.isHidden = true  //говорим, что индикатор загрузки скрыт
    }
    
    //функция, которая показывает алерт в случае ошибки загрущкм данных с сети
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") { [ weak self ] in
            guard let self = self else { return }
            
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            
            self.questionFactory.requestNextQuestion()
        }
        alertPresenter.show(quiz: alert)
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        resetBorder()
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
   
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect { // 1
            correctAnswers += 1 // 2
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
        }
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    
    private func showNextQuestionOrResults() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
        
        if presenter.isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: presenter.questionAmount)
            let text = correctAnswers == presenter.questionAmount ?
            """
            Поздравляем, вы ответили на 10 из 10!
            Количество сыгранных квизов: \(String(describing: statisticService.gamesCount))
            Рекорд: \(String(describing: statisticService.bestGame.correct))/10 (\(String(describing: statisticService.bestGame.date.dateTimeString)))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """ :
                        """
            Ваш результат: \(correctAnswers)/10
            Количество сыгранных квизов: \(String(describing: statisticService.gamesCount))
            Рекорд: \(String(describing: statisticService.bestGame.correct))/10 (\(String(describing: statisticService.bestGame.date.dateTimeString)))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
    
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз",
                completion: { [weak self] in
                    self?.presenter.resetQuestionIndex()
                    self?.correctAnswers = 0
                    self?.questionFactory.requestNextQuestion()
                })
            
            self.alertPresenter.show(quiz: alertModel)
            
        } else {
            presenter.switchToNextQuestion()
            self.questionFactory.requestNextQuestion()
        }
        resetBorder()
    }

    
    private func resetBorder() {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
        
    }


