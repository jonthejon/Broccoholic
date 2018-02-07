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
		case UndefinedServerError, UndefinedResponse, InvalidStatusCode, InvalidData, InvalidJSONFormat, UnableToParseJSON
	}
	
	func fetchRecipesFromApi(queryParameter:String?, networkCallback callback:([TempRecipe])->()) throws {
		let query = queryParameterName != nil ? queryParameterName! : ""
		guard let url = self.generateSearchUrl(query: query) else {
			callback([TempRecipe]())
			return
		}
		let configuration = URLSessionConfiguration()
		configuration.waitsForConnectivity = true
		let session = URLSession(configuration: configuration)
		let request = self.generateURLRequest(url: url)
		var errorType:RecipeApiError?
		let dataTask = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
			if error == nil {
				errorType = RecipeApiError.UndefinedServerError
				return
			}
			guard let resp = response else {
				errorType = RecipeApiError.UndefinedResponse
				return
			}
			if let statusCode = (resp as? HTTPURLResponse)?.statusCode {
				if statusCode != 200 {
					errorType = RecipeApiError.InvalidStatusCode
					return
				}
			}
			guard let data = data else {
				errorType = RecipeApiError.InvalidData
				return
			}
			do {
				let json = try JSONSerialization.jsonObject(with: data, options: [])
				guard let recipesArrDict = (json as! [String:Any])["results"] as? [[String:Any]] else {
					errorType = RecipeApiError.UnableToParseJSON
					return
				}
				var recipesArr:[TempRecipe] = [TempRecipe]()
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
		}
		dataTask.resume()
		if (errorType != nil) {
			throw errorType!
		}
	}
	
	private func generateURLRequest(url:URL) -> URLRequest {
		var request = URLRequest(url: url)
		request.allHTTPHeaderFields = self.headerInfo
		return request
	}
	
	private func generateSearchUrl(query:String) -> URL? {
		var queryItemsArr = [URLQueryItem]()
		for (key, value) in self.params {
			queryItemsArr.append(URLQueryItem(name: key, value: value))
		}
		let component = NSURLComponents(string: self.searchEndPoint)
		component?.queryItems = queryItemsArr
		return component?.url
	}
	
}
