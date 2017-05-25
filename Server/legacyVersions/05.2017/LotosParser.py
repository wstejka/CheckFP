#!/home/wstejka/virtualenv/firebase/bin/python
# coding=utf-8
import FuelModel as fuelModel
from lxml import etree
from datetime import datetime

def parse(etreeElement):

	# Extract day for the day
	tableDate = etreeElement.xpath("//h2")
	token = "Aktualne ceny paliw obowiązujące od dnia "
	formatedDate = tableDate[0].text.encode("utf-8").replace(token, '').replace(':', '')
	dateTime = datetime.strptime("2001-03-14", '%Y-%m-%d')
	fuelPriceForTheDay = fuelModel.FuelPriceForTheDay(dateTime.date())

	# Parse data to extract prices for certain type of fuel
	tableLight = etreeElement.xpath("//table")
	for trNode in tableLight[0].findall("tr"):
		tagFuelName = fuelModel.FuelType.none
		currentFuelName = tagFuelName
		for tdNode in trNode.findall("td"):

			# print tdNode.text.encode("utf-8")
			foundTagValue = tdNode.text.encode("utf-8")
			tagFuelName = fuelModel.FuelType.none

			if "95" in foundTagValue:
				tagFuelName = fuelModel.FuelType.unleaded95
			elif "98" in foundTagValue:
				tagFuelName = fuelModel.FuelType.unleaded98
			elif "EURODIESEL" in foundTagValue:
				tagFuelName = fuelModel.FuelType.diesel
			elif "40" in foundTagValue:
				tagFuelName = fuelModel.FuelType.dieselIZ40
			elif "LOTOS RED" in foundTagValue:
				tagFuelName = fuelModel.FuelType.dieselHeating

			if tagFuelName != fuelModel.FuelType.none:
				currentFuelName = tagFuelName
			else:
				if currentFuelName != fuelModel.FuelType.none:
					fuelPriceForTheDay.fuelTypesList[currentFuelName] = float(foundTagValue.replace(' ','').replace(',','.'))
					currentFuelName = fuelModel.FuelType.none

	return fuelPriceForTheDay