#!/home/wstejka/virtualenv/firebase/bin/python
from datetime import date
from utils.utils import Utils

class Producer(Utils):
	none, lotos, orlen = range(3)

	@staticmethod
	def get(producerId):

		if producerId == Producer.none:
			return "none"
		elif producerId == Producer.lotos:
			return "Lotos"			
		elif producerId == Producer.orlen:
			return "Orlen"			
		else:
			return "Incorrect TYPE"


class Fuel(Utils):
	none, unleaded95, unleaded98, diesel, dieselIZ40, dieselHeating, lpg = range(7)

	@staticmethod
	def get(fuelType):

		if fuelType == Fuel.none:
			return "none"
		elif fuelType == Fuel.unleaded95:
			return "unleaded95"			
		elif fuelType == Fuel.unleaded98:
			return "unleaded98"
		elif fuelType == Fuel.diesel:
			return "diesel"
		elif fuelType == Fuel.dieselIZ40:
			return "dieselIZ40"
		elif fuelType == Fuel.dieselHeating:
			return "dieselHeating"
		elif fuelType == Fuel.lpg:
			return "lpg"
		else:
			return "Incorrect TYPE"


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
	print Fuel.get(dieselType)
	print Fuel.get("BadType")
	print Fuel().types(["none"])

	print "=============================="
	producerType = Producer.lotos
	print producerType
	print Producer.get(producerType)
	print Producer.get(Producer.orlen)
	print Producer.get(22)

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





