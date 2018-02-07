import UIKit

class Recipe {
	
	let id:Int
	let title:String
	var image:UIImage?
	var servings:Int?
	var readyInMin:Int?
	var ingredients:(String, Int, String)?
	var instructions:String?
	var isBookmarked:Bool
	var isCached:Bool
	
	init(id:Int, title:String) {
		self.id = id
		self.title = title
		self.isBookmarked = false
		self.isCached = false
	}
	
}
