#!/usr/local/bin/python
# coding=utf-8
from datetime import datetime

class Utils:

	def properties(self, excludeNames=None):
		properties = {}
		for key, value in self.__class__.__dict__.iteritems():
			# exclude low level properties associated directly with class
			if "__" in key:
				continue
			method = getattr(self, key)
			# exclude functions
			if callable(method):
				continue
			# exclude these of properites which names are provided under an array
			if excludeNames != None:
				exclude = False
				for keyName in excludeNames:
					if key == keyName:
						exclude = True
						break 
				if exclude:
					continue
			properties[key] = value
		return properties

	def getValueByKey(self, key):
		
		properties = self.properties()
		if key in properties.keys():			
			return [True, properties[key]]
		else:
			return [False, "Incorrect key: " + str(key)]

	# Important remark: It can happen that more than one key has the same value 
	#					cause uniqueness is not guaranteed toward this direction
	def getKeyByValue(self, value):
		
		properties = self.properties()
		values = properties.values()
		if value in values:			
			return [True, properties.keys()[properties.values().index(value)]]
		else:
			return [False, "Incorrect value: " + str(value)]

class Test(Utils):
	cat = "happy"
	dog = "friendly"
	horse = "friendly"
	house = "comfortable"
	number = 16

	def run():
		pass

if __name__ == "__main__":
	test = Test()
	print test.properties()
	print test.properties(["dog", "nope"])
	print test.getValueByKey("cat")
	print test.getValueByKey("marshmallow")
	print test.getKeyByValue(123)
	print test.getKeyByValue('friendly')


