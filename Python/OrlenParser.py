#!/home/wstejka/virtualenv/firebase/bin/python
import FuelModel as fuelModel
from lxml import etree
from datetime import datetime

def parse(webPageString):
	

	myparser = etree.HTMLParser(encoding="utf-8")
	tree = etree.HTML(webPageString.content, parser=myparser)

	# Extract day for the day
	tableDate = tree.xpath("//span[@id='ctl00_ctl00_SPWebPartManager1_g_73ff41bc_f8a0_4b3a_98ea_c4200b64ef40_ctl00_lblDate']")
	dateTime = datetime.strptime(tableDate[0].text, '%d-%m-%Y')
	fuelPriceForTheDay = fuelModel.FuelPriceForTheDay(dateTime.date())


	# Parse data to extract prices for certain type of fuel
	tableLight = tree.xpath("//table[@class='tableLight']")
	for trNode in tableLight[0].findall("tr"):
		tagFuelName = fuelModel.FuelType.none
		currentFuelName = tagFuelName
		for tdNode in trNode.findall("td"):
			for spanNode in tdNode.findall("span"):
				
				foundTagValue = spanNode.text.encode("utf-8")
				tagFuelName = fuelModel.FuelType.none

				if "95" in foundTagValue:
					tagFuelName = fuelModel.FuelType.unleaded95
				elif "98" in foundTagValue:
					tagFuelName = fuelModel.FuelType.unleaded98
				elif "Ekodiesel" in foundTagValue:
					tagFuelName = fuelModel.FuelType.diesel
				elif "Arktyczny" in foundTagValue:
					tagFuelName = fuelModel.FuelType.dieselIZ40
				elif "Grzewczy" in foundTagValue:
					tagFuelName = fuelModel.FuelType.dieselHeating

				if tagFuelName != fuelModel.FuelType.none:
					currentFuelName = tagFuelName
				else:
					if currentFuelName != fuelModel.FuelType.none:
						# print "Adding: ", currentFuelName , ":", spanNode.text.encode("utf-8")
						fuelPriceForTheDay.fuelTypesList[currentFuelName] = float(foundTagValue.replace(',',''))
						currentFuelName = fuelModel.FuelType.none
						
	return fuelPriceForTheDay


if __name__ == "__main__":
	pass
