import UIKit
import CoreLocation

class RecipeAPIManager {
	
	let searchEndPoint:String
	let detailEndPoint:String
	let imageEndPoint:String
	let searchParams:[String:String]
	let detailsParams:[String:String]
	let headerInfo:[String:String]
	var queryParameterName:String
	var idParameterName:String
	
	init() {
		self.searchEndPoint = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search"
		self.detailEndPoint = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/informationBulk"
		self.searchParams = [
			"diet":"vegan",
			"instructionsRequired":"true",
			"number":"30"
		]
		self.detailsParams = [
			"includeNutrition":"false"
		]
		self.headerInfo = [
			"X-Mashape-Key":"TOm0IKGGc9mshc792FqI3pYYoMI5p1QK8tejsn0uwr0E7Pwx8r",
			"Accept":"application/json"
		]
		self.queryParameterName = "query"
		self.idParameterName = "ids"
		self.imageEndPoint = "https://spoonacular.com/recipeImages/"
	}
	
	enum RecipeApiError: Error {
		case UndefinedServerError, UndefinedResponse, InvalidStatusCode, InvalidData, InvalidJSONFormat, UnableToParseJSON, InvalidURL, UnableToParseImage
	}
	
	func fetchRestaurantsFromYelpApi(location: CLLocationCoordinate2D, radius: Int, callback:@escaping ([Restaurant])->()) {
		guard let url = self.generateYelpUrl(location: location, radius: radius) else {
			print(RecipeApiError.InvalidURL)
			return
		}
		let configuration = URLSessionConfiguration.default
		configuration.waitsForConnectivity = true
		let session = URLSession(configuration: configuration)
		var request = URLRequest(url: url)
		request.addValue("Bearer fm2pDRqlIs2_05-dm6N8gxenY_Ki7IdIt-iK2RY-SRJdTT3lRGHCSlzOROO2Gr1I-JKSHsNJv-I7QcR3CILMHJZZcpBMM1azWq65Mlp_T-V7iLQtGsOc-VsWWjN3WnYx", forHTTPHeaderField: "Authorization")
		let dataTask = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
			if error != nil {
				print(RecipeApiError.UndefinedServerError)
				return
			}
			guard let resp = response else {
				print(RecipeApiError.UndefinedResponse)
				return
			}
			if let statusCode = (resp as? HTTPURLResponse)?.statusCode {
				if statusCode != 200 {
					print(RecipeApiError.InvalidStatusCode)
					return
				}
			}
			guard let data = data else {
				print(RecipeApiError.InvalidData)
				return
			}
			var resultArr:[Restaurant] = [Restaurant]()
			do {
				let json = try JSONSerialization.jsonObject(with: data, options: [])
				guard let restaurantsArr:[[String:Any]] = (json as! [String:Any])["businesses"] as? [[String:Any]] else {
					return
				}
				for restaurant in restaurantsArr {
					resultArr.append(Restaurant(data: restaurant))
				}
			} catch {
				print(RecipeApiError.UnableToParseJSON)
				return
			}
			callback(resultArr)
			session.invalidateAndCancel()
		}
		dataTask.resume()
	}
	
	func fetchRecipesFromApi(queryParameter:String?, callback:@escaping ([Recipe])->()) {
		let query = queryParameter != nil ? queryParameter! : ""
		guard let url = self.generateSearchUrl(query: query) else {
			print(RecipeApiError.InvalidURL)
			return
		}
		let configuration = URLSessionConfiguration.default
		configuration.waitsForConnectivity = true
		let session = URLSession(configuration: configuration)
		let request = self.generateURLRequest(url: url)
		let dataTask = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
			if error != nil {
				print(RecipeApiError.UndefinedServerError)
				return
			}
			guard let resp = response else {
				print(RecipeApiError.UndefinedResponse)
				return
			}
			if let statusCode = (resp as? HTTPURLResponse)?.statusCode {
				if statusCode != 200 {
					print(RecipeApiError.InvalidStatusCode)
					return
				}
			}
			guard let data = data else {
				print(RecipeApiError.InvalidData)
				return
			}
			var recipesArr:[Recipe] = [Recipe]()
			do {
				let json = try JSONSerialization.jsonObject(with: data, options: [])
				guard let recipesArrDict:[[String:Any]] = (json as! [String:Any])["results"] as? [[String:Any]] else {
					return
				}
				for recipeDict in recipesArrDict {
					let id:Int
					let title:String
					let imageUrl:String
					if let tempId = recipeDict["id"] as? Int {
						id = tempId
					} else {id = -1}
					if let tempTitle = recipeDict["title"] as? String {
						title = tempTitle
					} else {title="Undefined title"}
					if let imageEndUrl = recipeDict["image"] as? String {
						imageUrl = self.imageEndPoint + imageEndUrl
					} else {imageUrl="Undefine image URL"}
					recipesArr.append(Recipe(id: id, title: title, imageUrl: imageUrl))
				}
			} catch {
				print(RecipeApiError.UnableToParseJSON)
				return
			}
			callback(recipesArr)
			session.invalidateAndCancel()
		}
		dataTask.resume()
	}
	
	func fetchRecipeDetailFromApi(recipe: Recipe, callback: @escaping (Recipe)->()) {
		guard let url = self.generateDetailUrl(id: recipe.id) else {
			print(RecipeApiError.InvalidURL)
			return
		}
		let configuration = URLSessionConfiguration.default
		configuration.waitsForConnectivity = true
		let session = URLSession(configuration: configuration)
		let request = self.generateURLRequest(url: url)
		let dataTask = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
			if error != nil {
				print(RecipeApiError.UndefinedServerError)
				return
			}
			guard let resp = response else {
				print(RecipeApiError.UndefinedResponse)
				return
			}
			if let statusCode = (resp as? HTTPURLResponse)?.statusCode {
				if statusCode != 200 {
					print(RecipeApiError.InvalidStatusCode)
					return
				}
			}
			guard let data = data else {
				print(RecipeApiError.InvalidData)
				return
			}
			do {
				let json = try JSONSerialization.jsonObject(with: data, options: [])
				let recipeDict:[String:Any] = (json as! [[String:Any]])[0]
				let servings:Int = recipeDict["servings"] as? Int ?? 0
				let readyInMin:Int = recipeDict["readyInMinutes"] as? Int ?? 0
				let glutenFree:Bool = recipeDict["glutenFree"] as? Bool ?? false
				let dairyFree:Bool = recipeDict["dairyFree"] as? Bool ?? false
				let popular:Bool = recipeDict["veryPopular"] as? Bool ?? false
				let ketogenic:Bool = recipeDict["ketogenic"] as? Bool ?? false
				let filters = Recipe.createEnumArray(boolArr: [glutenFree, dairyFree, popular, ketogenic])
				let instructions:String = recipeDict["instructions"] as? String ?? "No instructions defined"
				let ingredientsDictArr:[[String:Any]] = recipeDict["extendedIngredients"] as! [[String:Any]]
				var ingredArr:[Ingredient] = [Ingredient]()
				for ingredientDict in ingredientsDictArr {
					let name:String = ingredientDict["name"] as? String ?? "Undefined name"
					let amount:Double = ingredientDict["amount"] as? Double ?? 0
					let unit:String = ingredientDict["unit"] as? String ?? "-"
					ingredArr.append(Ingredient(name: name, quantity: amount, unit: unit))
				}
				recipe.servings = servings
				recipe.readyInMin = readyInMin
				recipe.filters = filters
				recipe.instructions = instructions
				let detailInstrucArr:[[String:Any]] = recipeDict["analyzedInstructions"] as! [[String:Any]]
				let detailInstrucDict = detailInstrucArr[0]
				let stepsDictArr:[[String:Any]] = detailInstrucDict["steps"] as! [[String:Any]]
				var detailedInstructions = [String]()
				for stepsDict in stepsDictArr {
					let step = stepsDict["step"] as? String ?? "Undefined step"
					detailedInstructions.append(step)
				}
				recipe.detailedInstructions = detailedInstructions
				recipe.ingredients = ingredArr
				recipe.isComplete = true
			} catch {
				print(RecipeApiError.UnableToParseJSON)
				return
			}
			callback(recipe)
			session.invalidateAndCancel()
		}
		dataTask.resume()
		
	}
	
	func fetchImageWithUrl(url:String, callback: @escaping (UIImage?)->()) {
		
		let configuration = URLSessionConfiguration.default
		configuration.waitsForConnectivity = true
		let session = URLSession(configuration: configuration)
		guard let imageUrl = URL(string: url) else {
			callback(nil)
			return
		}
		let downloadTask = session.downloadTask(with: imageUrl) { (url:URL?, response:URLResponse?, error:Error?) in
			if error != nil {
				print(RecipeApiError.UndefinedServerError)
				return
			}
			guard let resp = response else {
				print(RecipeApiError.UndefinedResponse)
				return
			}
			if let statusCode = (resp as? HTTPURLResponse)?.statusCode {
				if statusCode != 200 {
					print(RecipeApiError.InvalidStatusCode)
					return
				}
			}
			do {
				let data = try Data.init(contentsOf: url!)
				let image = UIImage.init(data: data)
				callback(image)
				session.invalidateAndCancel()
			} catch {
				print(RecipeApiError.UnableToParseImage)
				return
			}
			
		}
		downloadTask.resume()
	}
	

	private func generateURLRequest(url:URL) -> URLRequest {
		var request = URLRequest(url: url)
		request.addValue(self.headerInfo["X-Mashape-Key"]!, forHTTPHeaderField: "X-Mashape-Key")
		request.addValue(self.headerInfo["Accept"]!, forHTTPHeaderField: "Accept")
		return request
	}
	
	private func generateSearchUrl(query:String) -> URL? {
		var queryItemsArr = [URLQueryItem]()
		for (key, value) in self.searchParams {
			queryItemsArr.append(URLQueryItem(name: key, value: value))
		}
		queryItemsArr.append(URLQueryItem(name: self.queryParameterName, value: query))
		guard var component = URLComponents(string: self.searchEndPoint) else {
			return nil
		}
		component.queryItems = queryItemsArr
		return component.url
	}
	
	private func generateDetailUrl(id:Int) -> URL? {
		var queryItemsArr = [URLQueryItem]()
		for (key, value) in self.detailsParams {
			queryItemsArr.append(URLQueryItem(name: key, value: value))
		}
		queryItemsArr.append(URLQueryItem(name: self.idParameterName, value: String(id)))
		guard var component = URLComponents(string: self.detailEndPoint) else {
			return nil
		}
		component.queryItems = queryItemsArr
		return component.url
	}
	
	private func generateYelpUrl(location: CLLocationCoordinate2D, radius:Int) -> URL? {
		var queryItemsArr = [URLQueryItem]()
		queryItemsArr.append(URLQueryItem(name: "latitude", value: String(location.latitude)))
		queryItemsArr.append(URLQueryItem(name: "longitude", value: String(location.longitude)))
		queryItemsArr.append(URLQueryItem(name: "radius", value: String(radius)))
		queryItemsArr.append(URLQueryItem(name: "categories", value: "vegan"))
		guard var component = URLComponents(string: "https://api.yelp.com/v3/businesses/search") else {
			return nil
		}
		component.queryItems = queryItemsArr
		return component.url
	}
	
}
