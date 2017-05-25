#!/home/wstejka/virtualenv/firebase/bin/python
from datetime import date
from utils.utils import Utils

class ProducerType(Utils):
	none, lotos, orlen = range(3)

	@staticmethod
	def getProducer(producerId):

		if producerId == ProducerType.none:
			return "none"
		elif producerId == ProducerType.lotos:
			return "Lotos"			
		elif producerId == ProducerType.orlen:
			return "Orlen"			
		else:
			return "Incorrect TYPE"


class FuelType(Utils):
	none, unleaded95, unleaded98, diesel, dieselIZ40, dieselHeating, lpg = range(7)

	@staticmethod
	def getFuelTypeName(fuelType):

		if fuelType == FuelType.none:
			return "none"
		elif fuelType == FuelType.unleaded95:
			return "unleaded95"			
		elif fuelType == FuelType.unleaded98:
			return "unleaded98"
		elif fuelType == FuelType.diesel:
			return "diesel"
		elif fuelType == FuelType.dieselIZ40:
			return "dieselIZ40"
		elif fuelType == FuelType.dieselHeating:
			return "dieselHeating"
		elif fuelType == FuelType.lpg:
			return "lpg"
		else:
			return "Incorrect TYPE"


class FuelPriceElement:

	theDay = date.today()
	fuelType = FuelType.none
	price = 0.0
	excise = 0.0
	fee = 0.0
	humanReadableDate = ""
	producer = 0


	def serialize(self):
		return {"theDay" : self.theDay,
				"fuelType" : self.fuelType,
				"price" : float(self.price),
				"excise" : float(self.excise),
				"fee" : float(self.fee),
				"humanReadableDate" : self.humanReadableDate,
				"producer" : self.producer}


if __name__ == "__main__":
	dieselType = FuelType.diesel
	print dieselType
	print FuelType.getFuelTypeName(dieselType)
	print FuelType.getFuelTypeName("BadType")
	print FuelType().types(["none"])

	print "=============================="
	producerType = ProducerType.lotos
	print producerType
	print ProducerType.getProducer(producerType)
	print ProducerType.getProducer(ProducerType.orlen)
	print ProducerType.getProducer(22)




