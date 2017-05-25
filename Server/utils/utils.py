#!/usr/local/bin/python
# coding=utf-8

class Utils:

	def types(self, excludeNames=None):
		types = {}
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
			types[key] = value
		return types


class Test(Utils):
	cat = "tst"
	dog = "cEsadasd"
	house = "sa"

	def run():
		pass

if __name__ == "__main__":
	print Test().types([""])
