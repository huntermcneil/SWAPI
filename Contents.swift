import UIKit

struct Person: Decodable {
    let name: String
    let hair_color: String
    let eye_color: String
    let films: [URL]
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService {
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    static let personEndpoint = "people/"
    static let filmEndpoint = "films/"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        let personId = String(id)
        guard let baseUrl = baseURL else {return completion(nil)}
        let secondURL = baseUrl.appendingPathComponent(personEndpoint)
        let finalURL = secondURL.appendingPathComponent(personId)
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error)
                print(error.localizedDescription)
                print("We had an error fetching our person")
            }
            
            guard let data = data else {return}
            
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                return completion(person)
            } catch {
                print("We had an error decoding the data - \(error) -- \(error.localizedDescription)")
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
       
        
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let data = data else {return completion(nil)}
            
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                return completion(film)
            } catch {
                print("We had an error decoding the data - \(error) -- \(error.localizedDescription)")
            }
        }.resume()
    }
}

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print(film)
        }
    }
}

SwapiService.fetchPerson(id: 5) { person in
    if let person = person {
        print(person)
        for film in person.films {
            fetchFilm(url: film)
        }
    }
}


