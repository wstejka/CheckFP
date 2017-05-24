###!/home/wstejka/virtualenv/firebase/bin/python
from lxml import html, etree
import requests

#################### PARSERS #######################
import OrlenParser as orlenParser
import LotosParser as lotosParser

# Let's define list of parsers
webPageList = { orlenParser: "http://www.orlen.pl/EN/ForBusiness/FuelWholesalePrices/Pages/default.aspx" ,
				lotosParser: "http://www.lotos.pl/144/poznaj_lotos/dla_biznesu/hurtowe_ceny_paliw"}


for parser, webPage in webPageList.iteritems():
	try:
		functionName = parser.__name__
		identation = "\t"
		print functionName, ":"
		print identation, "downloading data ..."
		webPageContent = requests.get(webPage)

		print identation, "parsing html ..."
		myparser = etree.HTMLParser(encoding="utf-8")
		etreeElement = etree.HTML(webPageContent.content, parser=myparser)

	except Exception, e:
		print e
		continue

	print identation, "scraping html ..."
	fuelPriceForTheDay = parser.parse(etreeElement)

	print identation, "final data:", fuelPriceForTheDay.theDay, ",", fuelPriceForTheDay.fuelTypesList
