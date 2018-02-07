import UIKit

class RecipeAPIManager {
	
	var searchUrl:URL?
	let searchEndPoint:String
	let params:[String:String]
	let headerInfo:[String:String]
	var queryParameterName:String
	
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
	
}
