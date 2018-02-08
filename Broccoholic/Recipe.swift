import UIKit

class Recipe {
	
	let id:Int
	let title:String
	let imageUrl:String
	var image:UIImage?
	var servings:Int?
	var readyInMin:Int?
    var ingredients:[(name: String, quantity: Int, unit: String)]?
	var instructions:String?
	var isBookmarked:Bool
	var isComplete:Bool
	
	init(id:Int, title:String, imageUrl:String) {
		self.id = id
		self.title = title
		self.imageUrl = imageUrl
		self.isBookmarked = false
		self.isComplete = false
	}
	
}
