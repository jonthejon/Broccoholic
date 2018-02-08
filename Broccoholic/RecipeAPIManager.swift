import UIKit

class RecipeAPIManager {
	
	let searchEndPoint:String
	let imageEndPoint:String
	let params:[String:String]
	let headerInfo:[String:String]
	var queryParameterName:String?
	
	init() {
		self.searchEndPoint = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/search"
		params = [
			"diet":"vegan",
			"instructionsRequired":"true",
			"number":"20"
		]
		self.headerInfo = [
			"X-Mashape-Key":"TOm0IKGGc9mshc792FqI3pYYoMI5p1QK8tejsn0uwr0E7Pwx8r",
			"Accept":"application/json"
		]
		self.queryParameterName = "query"
		self.imageEndPoint = "https://spoonacular.com/recipeImages/"
	}
	
	enum RecipeApiError: Error {
		case UndefinedServerError, UndefinedResponse, InvalidStatusCode, InvalidData, InvalidJSONFormat, UnableToParseJSON, InvalidURL, UnableToParseImage
	}
	
	func fetchRecipesFromApi(queryParameter:String?, callback:@escaping ([Recipe])->()) {
		let query = queryParameterName != nil ? queryParameterName! : ""
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
			} catch {
				print(RecipeApiError.UnableToParseImage)
				return
			}
			
		}
		downloadTask.resume()
//			NSData *data = [NSData dataWithContentsOfURL:location];
//			UIImage* image = [UIImage imageWithData:data];
//			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
//			photo.image = image;
//			cell.imageView.image = image;
//			}];
//			}];
//		[downloadTask resume];
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
