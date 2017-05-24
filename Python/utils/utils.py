#!/usr/local/bin/python
# coding=utf-8

class Utils:

	def types(self, excludeNames=None):
		types = []
		for key, value in self.__class__.__dict__.iteritems():
			# print key, value
			if "__" in key:
				continue
			method = getattr(self, key)
			if callable(method):
				continue
			if excludeNames != None:
				exclude = False
				# print keyName
				for keyName in excludeNames:
					if key == keyName:
						exclude = True
						break 
				if exclude:
					continue
			types.append(key)
		return types



class Test(Utils):
	ala = "tst"
	kot = "cEsadasd"
	domek = "sa"

	def run():
		pass

print Test().types([""])
