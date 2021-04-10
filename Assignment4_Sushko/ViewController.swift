// Name: Nikita Sushko
// ID: 105075196

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var cityField: UITextField!
    
    @IBOutlet weak var btnWeather: UIButton!
    
    @IBOutlet weak var lblOutput: UILabel!
    
    let url = "http://api.weatherapi.com/v1/current.json?key=e0b348cddca8469894885615211004"
    var output = ""
    
    @IBAction func onClick(_ sender: UIButton) {
        if (cityField.text != "")
        {
            let tempUrl = url + "&q=" + cityField.text! + "&aqi=no"
            getData(from: tempUrl)
        }
    }
    
    let cities = ["London", "Toronto", "Berlin", "Beijing", "Singapore", "Moscow", "Tokyo", "Rome", "Ottawa", "Paris"]
    
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        cityField.inputView = pickerView
        cityField.textAlignment = .center
        cityField.placeholder = "Select City"
        
        btnWeather.layer.cornerRadius = 10
    }
    
    private func getData(from url: String) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            //have data
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            }
            catch {
                print("failed to convert \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
            
            self.output = "Current weather in " + json.location.name + " (" + json.location.country + ")" + "\nTemperature: " + String(format: "%.1f", json.current.temp_c) + "°C\nFeels Like: " + String(format: "%.1f", json.current.feelslike_c) + "°C\nWind Direction: " + json.current.wind_dir + "\nWind Speed: " + String(format: "%.1f", json.current.wind_kph) + "km/h\nHumidity: " + String(json.current.humidity) + "%\nCloudiness: " + String(json.current.cloud) + "%\nUltraviolet Index: " + String(format: "%.1f", json.current.uv) + "nm"
            
            DispatchQueue.main.async {
                self.lblOutput.text = self.output
            }
        })
        task.resume()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cityField.text = cities[row]
        cityField.resignFirstResponder()
    }
}

struct Response: Codable {
    public let location: MyLocation
    public let current: MyCurrent
}

struct MyLocation: Codable {
    public let name: String!
    public let country: String!
}
struct MyCurrent: Codable {
    public let temp_c: Double!
    public let feelslike_c: Double!
    public let wind_dir: String!
    public let wind_kph: Double!
    public let humidity: Int!
    public let cloud: Int!
    public let uv: Double!
}


/*
 {
     "location": {
         "name": "London",
         "region": "City of London, Greater London",
         "country": "United Kingdom",
         "lat": 51.52,
         "lon": -0.11,
         "tz_id": "Europe/London",
         "localtime_epoch": 1618051399,
         "localtime": "2021-04-10 11:43"
     },
     "current": {
         "last_updated_epoch": 1618050600,
         "last_updated": "2021-04-10 11:30",
         "temp_c": 8.0,
         "temp_f": 46.4,
         "is_day": 1,
         "condition": {
             "text": "Overcast",
             "icon": "//cdn.weatherapi.com/weather/64x64/day/122.png",
             "code": 1009
         },
         "wind_mph": 13.6,
         "wind_kph": 22.0,
         "wind_degree": 80,
         "wind_dir": "E",
         "pressure_mb": 1014.0,
         "pressure_in": 30.4,
         "precip_mm": 0.1,
         "precip_in": 0.0,
         "humidity": 66,
         "cloud": 100,
         "feelslike_c": 5.4,
         "feelslike_f": 41.8,
         "vis_km": 10.0,
         "vis_miles": 6.0,
         "uv": 1.0,
         "gust_mph": 11.9,
         "gust_kph": 19.1
     }
*/
