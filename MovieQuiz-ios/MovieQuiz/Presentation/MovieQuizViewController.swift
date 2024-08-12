import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    //MARK: - Outlets and Variables
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    
    
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        questionFactory.requestNextQuestion()
        
        let alertPresenter = AlertPresenter(delegate: self)
        self.alertPresenter = alertPresenter
        
        let statisticService = StatisticService()
        self.statisticService = statisticService
        

        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        
        if let customFont = UIFont(name: "YSDisplay-Medium", size: 20) {
            counterLabel.font = customFont.withSize(20)
            yesButton.titleLabel?.font = customFont.withSize(20)
            noButton.titleLabel?.font = customFont.withSize(20)
        }
    }
    
    //MARK: - QuestionFactoryDelegate
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)}
        
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
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                             question: model.text,
                                             questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)")
        return questionStep
    }
    
    //MARK: - Private Funcs
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
        
        if currentQuestionIndex == questionAmount - 1 {
            statisticService?.store(correct: correctAnswers, total: questionAmount)
            let text = correctAnswers == questionAmount ?
            """
            Поздравляем, вы ответили на 10 из 10!
            Количество сыгранных квизов: \(String(describing: statisticService.gamesCount))
            Рекорд: \(String(describing: statisticService!.bestGame.correct))/10 (\(String(describing: statisticService!.bestGame.date.dateTimeString)))
            Средняя точность: \(String(format: "%.2f", statisticService!.totalAccuracy))%
            """ :
            
            //на меня тут ругалось приложение и просила сделать либо принудительную распаковку, либо проставить, что это statisticServise - опционал. Принудительная помню, что не очень хорошо, но я не очень могу понять даже, почему тут просят распаковку((((
            """
            Ваш результат: \(correctAnswers)/10
            Количество сыгранных квизов: \(String(describing: statisticService!.gamesCount))
            Рекорд: \(String(describing: statisticService!.bestGame.correct))/10 (\(String(describing: statisticService!.bestGame.date.dateTimeString)))
            Средняя точность: \(String(format: "%.2f", statisticService!.totalAccuracy))%
            """
    
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз",
                completion: { [weak self] in
                    self?.currentQuestionIndex = 0
                    self?.correctAnswers = 0
                    self?.questionFactory?.requestNextQuestion()
                })
            
            self.alertPresenter?.show(quiz: alertModel)
            
        } else {
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
        }
        resetBorder()
    }

    
    private func resetBorder() {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
    }
        
    }


