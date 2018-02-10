import UIKit

class Recipe {
	
	let id:Int
	let title:String
	let imageUrl:String
	var image:UIImage?
	var servings:Int?
	var readyInMin:Int?
//    var ingredients:[(name: String, quantity: Double, unit: String)]?
	var ingredients:[Ingredient]?
	var filters:[RecipeFilter]?
	var instructions:String?
	var detailedInstructions:[String]?
	var isBookmarked:Bool
	var isComplete:Bool
	
	init(id:Int, title:String, imageUrl:String) {
		self.id = id
		self.title = title
		self.imageUrl = imageUrl
		self.isBookmarked = false
		self.isComplete = false
	}
	
	enum RecipeFilter {
		case GlutenFree, DairyFree, Popular, Ketogenic
	}
	
	class func createEnumArray(boolArr:[Bool]) -> [RecipeFilter]? {
		if boolArr.count != 4 {return nil}
		var result = [RecipeFilter]()
		if boolArr[0] {result.append(RecipeFilter.GlutenFree)}
		if boolArr[1] {result.append(RecipeFilter.DairyFree)}
		if boolArr[2] {result.append(RecipeFilter.Popular)}
		if boolArr[3] {result.append(RecipeFilter.Ketogenic)}
		return result
	}
	
}
