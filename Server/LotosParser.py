#!/home/wstejka/virtualenv/firebase/bin/python
# coding=utf-8
import FuelModel as fuelModel
from datetime import datetime, date
from lxml import html, etree
import requests

# Dict of web pages which are a source for scraping
webPagesList = { fuelModel.Fuel.unleaded95: "http://www.lotos.pl/145/type,oil_95/poznaj_lotos/dla_biznesu/hurtowe_ceny_paliw/archiwum_cen_paliw",
				fuelModel.Fuel.unleaded98: "http://www.lotos.pl/145/type,oil_98/poznaj_lotos/dla_biznesu/hurtowe_ceny_paliw/archiwum_cen_paliw",
				fuelModel.Fuel.diesel: "http://www.lotos.pl/145/type,oil_eurodiesel/poznaj_lotos/dla_biznesu/hurtowe_ceny_paliw/archiwum_cen_paliw",
				fuelModel.Fuel.dieselIZ40: "http://www.lotos.pl/145/type,oil_Iz_40/poznaj_lotos/dla_biznesu/hurtowe_ceny_paliw/archiwum_cen_paliw",
				fuelModel.Fuel.dieselHeating: "http://www.lotos.pl/145/type,oil_rgterm/poznaj_lotos/dla_biznesu/hurtowe_ceny_paliw/archiwum_cen_paliw", 
				}


def process(producerId):


	fuelPriceElementsList = []
	for fuelType, webPage in webPagesList.iteritems():

		identation = "\t"
		print identation, "downloading data for:", fuelModel.Fuel().getKeyByValue(fuelType)[1]
		webPageContent = requests.get(webPage)

		print identation, "parsing html ..."
		myparser = etree.HTMLParser(encoding="utf-8")
		etreeElement = etree.HTML(webPageContent.content, parser=myparser)

		print identation, "scraping html ..."
		tableLight = etreeElement.xpath("//table")
		for trNode in tableLight[0].findall("tr"):

			price = 0.0
			excise = 0.0
			fee = 0.0
			dateTime = date.today()
			humanReadableDate = ""
			iteration = 0

			for tdNode in trNode.findall("td"):

				value = tdNode.text.encode("utf-8")
				# print value
				# In first iteration we have date
				if iteration == 0:
					humanReadableDate = value
					dateTime = datetime.strptime(value, '%Y-%m-%d')					
				else:
					numericValue = float(value.replace(' ','').replace(',','.'))
					if iteration == 1:
						price = numericValue						
					elif iteration == 2:
						excise = numericValue						
					elif iteration == 3:
						fee = numericValue
				# end if
				iteration += 1		
			# end for
			if price > 0 :
				timestamp = dateTime.strftime("%s")
				fuelPriceElement = fuelModel.FuelPriceElement()
				fuelPriceElement.timestamp = int(timestamp)
				fuelPriceElement.fuelType = fuelType
				fuelPriceElement.price = price
				fuelPriceElement.excise = excise
				fuelPriceElement.fee = fee
				fuelPriceElement.humanReadableDate = humanReadableDate
				fuelPriceElement.producer = producerId
			
				fuelPriceElementsList.append(fuelPriceElement)

	return fuelPriceElementsList

if __name__ == "__main__":
	process(1)


