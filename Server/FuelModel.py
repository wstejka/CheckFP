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
		return {"timestamp" : self.timestamp,
				"fuelType" : self.fuelType,
				"price" : float(self.price),
				"excise" : float(self.excise),
				"fee" : float(self.fee),
				"humanReadableDate" : self.humanReadableDate,
				"producer" : self.producer}

	def key(self):
		return str(self.producer) + "_" + str(self.timestamp) + "_" + str(self.fuelType)


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
	producer = Producer.lotos

	print elem.serialize()
	print elem.key()





