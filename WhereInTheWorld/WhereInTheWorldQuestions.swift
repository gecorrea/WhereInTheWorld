import Foundation
import CoreLocation

class WhereInTheWorldQuestion {
    let location:CLLocationCoordinate2D
    let regionSizeInMeters:Double
    var answers = [String:Bool]()
    
    init(location:CLLocationCoordinate2D, regionSizeInMeters:Double) {
        self.location = location
        self.regionSizeInMeters = regionSizeInMeters
    }
    
    func addAnswer(_ place:String, isCorrect:Bool) {
        answers[place] = isCorrect
    }
    
    
}
