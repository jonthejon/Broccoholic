import UIKit

class RecipeAPIManager {
	
	let searchEndPoint:String
	let params:[String:String]
	let headerInfo:[String:String]
	var queryParameterName:String?
	
	init() {
		self.searchEndPoint = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search"
		self.params = [
			"diet":"vegan",
			"instructionsRequired":"true",
			"number":"20"
		]
		self.headerInfo = [
			"X-Mashape-Key":"TOm0IKGGc9mshc792FqI3pYYoMI5p1QK8tejsn0uwr0E7Pwx8r",
			"Accept":"application/json"
		]
		self.queryParameterName = "query"
	}
	
	enum RecipeApiError: Error {
		case UndefinedServerError, UndefinedResponse, InvalidStatusCode, InvalidData, InvalidJSONFormat, UnableToParseJSON, InvalidURL
	}
	
	func fetchRecipesFromApi(queryParameter:String?, callback:@escaping ([TempRecipe])->()) throws {
		let query = queryParameterName != nil ? queryParameterName! : ""
		guard let url = self.generateSearchUrl(query: query) else {
			throw RecipeApiError.InvalidURL
		}
		let configuration = URLSessionConfiguration.default
		configuration.waitsForConnectivity = true
		let session = URLSession(configuration: configuration)
		let request = self.generateURLRequest(url: url)
				print(url)
				print(request.allHTTPHeaderFields)
		var errorType:RecipeApiError?
		let dataTask = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
			if error != nil {
				errorType = RecipeApiError.UndefinedServerError
				print("error")
				return
			}
			guard let resp = response else {
				errorType = RecipeApiError.UndefinedResponse
				print("resp")
				return
			}
			if let statusCode = (resp as? HTTPURLResponse)?.statusCode {
				if statusCode != 200 {
					errorType = RecipeApiError.InvalidStatusCode
				print("status")
					return
				}
			}
			guard let data = data else {
				errorType = RecipeApiError.InvalidData
				print("data")
				return
			}
			var recipesArr:[TempRecipe] = [TempRecipe]()
			do {
				let json = try JSONSerialization.jsonObject(with: data, options: [])
				guard let recipesArrDict:[[String:Any]] = (json as! [String:Any])["results"] as? [[String:Any]] else {
					errorType = RecipeApiError.UnableToParseJSON
					return
				}
				for recipeDict in recipesArrDict {
					let id = recipeDict["id"] as? Int
					let title = recipeDict["title"] as? String
					let imageUrl = recipeDict["image"] as? String
					recipesArr.append(TempRecipe(id: id, imageUrl: imageUrl, title: title))
				}
			} catch {
				errorType = RecipeApiError.InvalidJSONFormat
				return
			}
			callback(recipesArr)
		}
		dataTask.resume()
		if (errorType != nil) {
			throw errorType!
		}
	}
	
	private func generateURLRequest(url:URL) -> URLRequest {
		var request = URLRequest(url: url)
		request.addValue(self.headerInfo["X-Mashape-Key"]!, forHTTPHeaderField: "X-Mashape-Key")
		request.addValue(self.headerInfo["Accept"]!, forHTTPHeaderField: "Accept")
		return request
	}
	
	private func generateSearchUrl(query:String) -> URL? {
		var queryItemsArr = [URLQueryItem]()
		for (key, value) in self.params {
			queryItemsArr.append(URLQueryItem(name: key, value: value))
		}
		guard var component = URLComponents(string: self.searchEndPoint) else {
			return nil
		}
		component.queryItems = queryItemsArr
		return component.url
	}
	
}
