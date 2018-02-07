import UIKit

class TempRecipe: NSObject {

	let id: Int
	let imageUrl: String
	let title: String
	
	init(id:Int?, imageUrl:String?, title:String?) {
		if let id = id {
			self.id = id
		} else {self.id = 0}
		if let imageUrl = imageUrl {
			self.imageUrl = imageUrl
		} else {self.imageUrl = "Undefined URL"}
		if let title = title {
			self.title = title
		} else {self.title = "Undefined title"}
	}
	
}
