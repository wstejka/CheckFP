#!/home/wstejka/virtualenv/firebase/bin/python
from datetime import date
from utils.utils import Utils

class Producer(Utils):
	none, lotos, orlen = range(3)

class Fuel(Utils):
	none, unleaded95, unleaded98, diesel, dieselIZ40, dieselHeating, lpg = range(7)

class FuelPriceElement:

	timestamp = 0
	fuelType = Fuel.none
	price = 0.0
	excise = 0.0
	fee = 0.0
	humanReadableDate = ""
	producer = Producer.none


	def serialize(self):
		data = {"timestamp" : self.timestamp,
				"fuelType" : self.fuelType,
				"price" : float(self.price),
				"excise" : float(self.excise),
				"fee" : float(self.fee),
				"humanReadableDate" : self.humanReadableDate,
				"producer" : self.producer}
		keysDict = self.getListOfAllKey()
		return dict(data, **keysDict)

	def key(self):
		return str(self.producer) + "_" + str(self.timestamp) + "_" + str(self.fuelType)

	def getListOfAllKey(self):
		# REMARK: Firebase can be queried for one field only (see "order-by" DOC)
		# One of solution is to add a property that combines the values that you want to filter on
		# see here: https://stackoverflow.com/questions/26700924/query-based-on-multiple-where-clauses-in-firebase?answertab=active#tab-top
		# I'm going to use the 2nd approach and generate combination of 3 values: (P)Producent, (FT) FuelType, (T) Timestamp


		# Possible combination
		# P_T_FT, P_FT_T, FT_P_T, FT_T_P, T_FT_P, T_P_FT,
		# inputData = {"P" : self.producer, "T" : self.timestamp, "FT" : self.fuelType}
		outputData = {}
		inputDataName = ["P", "T", "FT"]
		inputDataValue = [self.producer, self.timestamp, self.fuelType]


		for pos, value in list(enumerate(inputDataName)):
			tripleKey = str(value)
			triple = str(inputDataValue[pos])

			for pos2, value2 in list(enumerate(inputDataName)):
				if pos == pos2:
					continue

				tripleKey += "_" + str(value2)
				triple += "_" + str(inputDataValue[pos2])
			outputData[tripleKey] = triple

			tripleKey = str(value)
			triple = str(inputDataValue[pos])

			for pos2, value2 in reversed(list(enumerate(inputDataName))):
				if pos == pos2:
					continue

				tripleKey += "_" + str(value2)
				triple += "_" + str(inputDataValue[pos2])
			outputData[tripleKey] = triple

		return outputData


if __name__ == "__main__":
	dieselType = Fuel.diesel
	print dieselType
	print Fuel().getKeyByValue(dieselType)
	print Fuel().getKeyByValue("BadType")
	print Fuel().properties(["none"])

	print "=============================="
	producerType = Producer.lotos
	print producerType
	print Producer().getKeyByValue(producerType)
	print Producer().getKeyByValue(Producer.orlen)
	print Producer().getKeyByValue(22)

	print "=============================="
	elem = FuelPriceElement()
	elem.timestamp = 123456789
	elem.fuelType = Fuel.unleaded98
	elem.price = 3457.3
	elem.excise = 129.0
	elem.fee = 389.0
	elem.humanReadableDate = "2017-03-15"
	elem.producer = Producer.lotos

	print elem.serialize()
	print elem.key()
	print "=============================="
	# {'fee': 129.41, 'excise': 1540.0, 'humanReadableDate': '2017-05-16', 'T_P_P': '1494885600_1_1', 'producer': 1, 'timestamp': 1494885600, 'price': 3564.0, 'fuelType': 1, 'P_T': '1_1494885600'}



	elem.timestamp = 1494885600
	elem.fuelType = Fuel.unleaded95
	elem.price = 3564.0
	elem.excise = 1540.0
	elem.fee = 129.41
	elem.humanReadableDate = "2017-05-16"
	elem.producer = Producer.lotos


	print elem.serialize()

	print "=============================="
	print elem.getListOfAllKey()






