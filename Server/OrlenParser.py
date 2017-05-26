#!/home/wstejka/virtualenv/firebase/bin/python
# coding=utf-8
import FuelModel as fuelModel
from datetime import datetime, date
from lxml import html, etree
import requests

# Dict of web pages which are a source for scraping
webPagesList = { fuelModel.Fuel.unleaded95: "http://www.orlen.pl/EN/ForBusiness/FuelWholesalePrices/Pages/Archive.aspx?Fuel=Pb95",
				fuelModel.Fuel.unleaded98: "http://www.orlen.pl/EN/ForBusiness/FuelWholesalePrices/Pages/Archive.aspx?Fuel=Pb98",
				fuelModel.Fuel.diesel: "http://www.orlen.pl/EN/ForBusiness/FuelWholesalePrices/Pages/Archive.aspx?Fuel=ONEkodiesel",
				fuelModel.Fuel.dieselIZ40: "http://www.orlen.pl/EN/ForBusiness/FuelWholesalePrices/Pages/Archive.aspx?Fuel=ONArctic2",
				fuelModel.Fuel.dieselHeating: "http://www.orlen.pl/EN/ForBusiness/FuelWholesalePrices/Pages/Archive.aspx?Fuel=ONEkoterm", 
				}


def process(producerId):

	currentYear = datetime.now().year
	identation = "\t"
	fuelPriceElementsList = []
	# Let's download data for 3 years back
	for fuelType, webPagePrefix in webPagesList.iteritems():

		print identation , "downloading data for:", fuelModel.Fuel().getKeyByValue(fuelType)[1]
		for year in range(currentYear - 2, currentYear + 1):
			
			print identation * 2, "year: ", str(year)
			webPage = webPagePrefix + "&Year=" + str(year)
			print identation * 2, "downloading html ..." #, webPage, "..."
			webPageContent = requests.get(webPage)

			print identation * 2, "parsing html ..."
			myparser = etree.HTMLParser(encoding="utf-8")
			etreeElement = etree.HTML(webPageContent.content, parser=myparser)

			print identation * 2, "scraping html ..."

			# Until 2015 table tag has attribue class with value "tableLight orlen-styled-table"
			# Since 2016 it is just "tableLight". Considering this we need to use starts-with operator
			tableLight = etreeElement.xpath("//table[starts-with(@class, 'tableLight')]")
			for trNode in tableLight[0].findall("tr"):

				if len(trNode.findall("td/span")) != 3:
					continue

				price = 0.0
				excise = 0.0
				fee = 0.0
				dateTime = date.today()
				humanReadableDate = ""
				iteration = 0	

				for spanNode in trNode.findall("td/span"):
					value = spanNode.text.encode("utf-8")
					# In first iteration we have date
					if iteration == 0:
						humanReadableDate = value
						dateTime = datetime.strptime(value, '%d-%m-%Y')					
					elif iteration == 1:
						# remove escape code for non-breaking spaces and comma
						price = float(value.replace('\xc2\xa0','').replace(',','.'))
					# end if
					else:
						break
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
				
					# print fuelPriceElement.serialize()
					fuelPriceElementsList.append(fuelPriceElement)

	# print fuelPriceElementsList
	return fuelPriceElementsList

if __name__ == "__main__":
	process(2)
