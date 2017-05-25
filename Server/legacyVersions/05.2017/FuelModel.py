#!/home/wstejka/virtualenv/firebase/bin/python
from datetime import date

class FuelType:
	none, unleaded95, unleaded98, diesel, dieselIZ40, dieselHeating, lpg = range(7)

class FuelPriceForTheDay(object):
	"""docstring for FuelPriceForTheDay"""

	def __init__(self, date=date.today()):
		theDay = date

	theDay = date.today()
	fuelTypesList = {}


if __name__ == "__main__":
	print FuelType.diesel