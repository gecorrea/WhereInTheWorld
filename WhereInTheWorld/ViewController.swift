import UIKit
import MapKit

class ViewController: UIViewController {
    
    override var canBecomeFirstResponder: Bool {return true}
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
            wrong = 0
            correct = 0
            showCurrentQuestion()
        }
    }

    // User Defaults = dictionary that saves to the device
    var defaults = UserDefaults.standard
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var score: UILabel!
    var questions = [WhereInTheWorldQuestion]()
    var currentQuestionIndex:Int {
        get{
            // if the key doesn't exist -> 0
            return defaults.integer(forKey: "currentQuestionIndex")
        }
        set{
            defaults.set(newValue, forKey: "currentQuestionIndex")
        }
    }
    var currentQuestion:WhereInTheWorldQuestion {
        return questions[currentQuestionIndex]
    }
    var correct:Int {
        get{
            // if the key doesn't exist -> 0
            return defaults.integer(forKey: "correctAnswers")
        }
        set{
            defaults.set(newValue, forKey: "correctAnswers")
        }
    }
    var wrong:Int {
        get{
            // if the key doesn't exist -> 0
            return defaults.integer(forKey: "wrongAnswers")
        }
        set{
            defaults.set(newValue, forKey: "wrongAnswers")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        mapView.mapType = .satellite
        showCurrentQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func checkAnswer(_ sender: UIButton) {
        guard let answer = sender.titleLabel?.text
            else {return}
        guard let isCorrect = currentQuestion.answers[answer]
            else {return}
        
        var title = ""
        var subtitle = ""
        
        if isCorrect == true {
            correct += 1
            title = "Correct!"
            subtitle = "You're so good at geography!"
        }
        else {
            wrong += 1
            title = "Wrong!"
            subtitle = "OH NO!"
        }
        
        // make an alert controller (the popup)
        let alertController = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        
        // add an action ro ir (triggered when you tap "OK")
        let action = UIAlertAction(title: "OK", style: .default) {
            (action) in
            
            // everything we want to do after "OK" is pressed
            if self.currentQuestionIndex < self.questions.count - 1 {
                self.currentQuestionIndex += 1
            }
            else {
                self.currentQuestionIndex = 0
            }
            self.showCurrentQuestion()
        }
        
        // add the action to the alert controller
        alertController.addAction(action)
        
        // present the controller
        self.present(alertController, animated: true, completion: nil)
        
        
//        if currentQuestionIndex < self.questions.count - 1 {
//            self.currentQuestionIndex += 1
//        }
//        else {
//            self.currentQuestionIndex = 0
//        }
//        showCurrentQuestion()
    }

    func loadData () {
        let kb = WhereInTheWorldQuestion(location: CLLocationCoordinate2D(latitude:   67.074411, longitude:-158.945477), regionSizeInMeters: 1000)
        kb.addAnswer("Alaska", isCorrect: true)
        kb.addAnswer("Sahara Desert", isCorrect: false)
        kb.addAnswer("Arizona", isCorrect: false)
        self.questions.append(kb)
        
        let ba = WhereInTheWorldQuestion(location: CLLocationCoordinate2D(latitude: 44.499527, longitude: 33.598420), regionSizeInMeters: 500)
        ba.addAnswer("Turkey", isCorrect: false)
        ba.addAnswer("Russia", isCorrect: true)
        ba.addAnswer("Italy", isCorrect: false)
        self.questions.append(ba)
        
        let ca = WhereInTheWorldQuestion(location: CLLocationCoordinate2D(latitude: 32.675831, longitude:-117.157526), regionSizeInMeters: 500)
        ca.addAnswer("California", isCorrect: true)
        ca.addAnswer("Germany", isCorrect: false)
        ca.addAnswer("Italy", isCorrect: false)
        self.questions.append(ca)
        
        let ar = WhereInTheWorldQuestion(location: CLLocationCoordinate2D(latitude: -33.867886, longitude:-63.984500), regionSizeInMeters: 1500)
        ar.addAnswer("Tennessee", isCorrect: false)
        ar.addAnswer("Argentina", isCorrect: true)
        ar.addAnswer("New Mexico", isCorrect: false)
        self.questions.append(ar)
        
        let ch = WhereInTheWorldQuestion(location: CLLocationCoordinate2D(latitude: 40.452107, longitude: 93.742118), regionSizeInMeters: 2500)
        ch.addAnswer("Peru", isCorrect: false)
        ch.addAnswer("China", isCorrect: true)
        ch.addAnswer("Egypt", isCorrect: false)
        self.questions.append(ch)
        
        let nv = WhereInTheWorldQuestion(location: CLLocationCoordinate2D(latitude: 37.563936, longitude: -116.851230), regionSizeInMeters: 500)
        nv.addAnswer("Nevada", isCorrect: true)
        nv.addAnswer("China", isCorrect: false)
        nv.addAnswer("Egypt", isCorrect: false)
        self.questions.append(nv)
        
        let sa = WhereInTheWorldQuestion(location: CLLocationCoordinate2D(latitude: 16.864841, longitude:  11.953808), regionSizeInMeters: 500)
        sa.addAnswer("Sahara Desert", isCorrect: true)
        sa.addAnswer("Nevada", isCorrect: false)
        sa.addAnswer("Egypt", isCorrect: false)
        self.questions.append(sa)
        
        
        let bs = WhereInTheWorldQuestion(location: CLLocationCoordinate2D(latitude: 26.357896, longitude: 127.783809), regionSizeInMeters: 200)
        bs.addAnswer("Japan", isCorrect: true)
        bs.addAnswer("New York", isCorrect: false)
        bs.addAnswer("Tibet", isCorrect: false)
        self.questions.append(bs)
    }
    
    func showCurrentQuestion(){
        self.score.text = "Correct:\(correct) Wrong:\(wrong)"
        
        let question = questions[currentQuestionIndex]
        //Display the correct location on the map
        //Create an MKCoordinateREgion
        
        let region = MKCoordinateRegionMakeWithDistance(question.location, question.regionSizeInMeters, question.regionSizeInMeters)
        
        mapView.setRegion(region, animated: true)
        
        //Set the map to begin at that region
        
        //Set the buttons to having answers
        // get the different answers
        let answers = [String](question.answers.keys)
        guard answers.count == 3
            else {return}
        
        // put the answers in the buttons
        self.button1.setTitle(answers[0], for: .normal)
        self.button2.setTitle(answers[1], for: .normal)
        self.button3.setTitle(answers[2], for: .normal)
    }
    
}

