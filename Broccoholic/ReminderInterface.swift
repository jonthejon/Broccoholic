//
//  ReminderInterface.swift
//  Broccoholic
//
//  Created by Jonathan Oliveira on 10/02/18.
//  Copyright © 2018 Jonathan Oliveira. All rights reserved.
//

import UIKit
import EventKit

class ReminderInterface {
	
	var recipe: Recipe
	var eventStore: EKEventStore
	var reminders: [EKReminder]!
	var calendar: EKCalendar?
	var controller: DetailedRecipeViewController

	
	init(recipe: Recipe, controller: DetailedRecipeViewController) {
		self.recipe = recipe
		self.eventStore = EKEventStore()
		self.reminders = [EKReminder]()
		self.controller = controller
	}
	
	func saveIngredients(ingredients:[String]) -> Bool {
		var result = true
		self.eventStore.requestAccess(to: EKEntityType.reminder) { (granted:Bool, error:Error?) in
			if granted {
				do {
					let newCalendar = EKCalendar(for: EKEntityType.reminder, eventStore: self.eventStore)
					newCalendar.title = self.recipe.title
					let sourcesInEventStore = self.eventStore.sources
					newCalendar.source = sourcesInEventStore.filter({ (source: EKSource) -> Bool in
						source.sourceType.rawValue == EKSourceType.local.rawValue
					}).first!
					try self.eventStore.saveCalendar(newCalendar, commit: true)
					UserDefaults.standard.set(newCalendar.calendarIdentifier, forKey: "\(self.recipe.id)")
					self.calendar = newCalendar
					for ingredient in ingredients {
						let reminder = EKReminder(eventStore: self.eventStore)
						reminder.title = ingredient
						reminder.calendar = self.calendar!
						do {
							try self.eventStore.save(reminder, commit: true)
							print("adding \(ingredient)")
						}catch{
							let alert = UIAlertController(title: "Error", message: "Unable to add ingredients to Reminders", preferredStyle: .alert)
							let okAlert = UIAlertAction(title: "OK", style: .default, handler: nil)
							alert.addAction(okAlert)
							self.controller.present(alert, animated: true, completion: nil)
						}
					}
				} catch {
					let alert = UIAlertController(title: "Error", message: "Calendar could not be created", preferredStyle: .alert)
					let okAlert = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(okAlert)
					self.controller.present(alert, animated: true, completion: nil)
					result = false
				}
			} else {
				print("This app does not have permission to access the reminders database")
				result = false
			}
		}
		return result
	}

}
