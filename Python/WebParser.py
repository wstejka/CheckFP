###!/home/wstejka/virtualenv/firebase/bin/python

##################    PARSERS    #######################
import OrlenParser as orlenParser
import LotosParser as lotosParser
from Firebase import FirebaseManager
from FuelModel import ProducerType, FuelType, FuelComponent
import sys, getopt, os
from datetime import datetime


def createFuelTypesNodeIfNeeded(firebaseManager):
	nodeName = "fuel_types"
	preDefinedValues = FuelType().types(["none"]).iteritems()

	currentTypes = {}
	firebaseFuelTypesList = firebaseManager.get(nodeName)

	if firebaseFuelTypesList.val() == None:
		firebaseFuelTypesListKeys = [{}]
	else:
		firebaseFuelTypesListKeys = firebaseFuelTypesList.val()

	# Check if all predefined values are already on the list		
	# If not, add the missing ones ...
	missingTypeKeys = {}
	for keyName, key in preDefinedValues:		
		found = False
		for firebaseFuelTypesKey in firebaseFuelTypesListKeys:
			
			if firebaseFuelTypesKey == None or \
				'id' not in firebaseFuelTypesKey:
				continue
			if key == firebaseFuelTypesKey['id']:
				found = True
				break

			# print key, firebaseFuelTypesKey

		if found == False:
			print "\t", keyName, "(" + str(key) + ")" + " is not on the list. Let's add it ..."
			# [{1 : {"name" : "unleadeed95", "lastUpdate" : 123456789, "id" : 1, ...},
			# 	2 : {"name" : "unleadeed98", "lastUpdate" : 123456789, "id" : 2, ...}, ...}]
			missingTypeKeys[nodeName + "/" + str(key)] = {"id" : key, 
														  "name" : keyName}

	numberOfMissingTypeKeys = len(missingTypeKeys)
	if numberOfMissingTypeKeys > 0:
		print "\tAdding", numberOfMissingTypeKeys ,"missing fuel types to the", nodeName
		firebaseManager.update(missingTypeKeys)
	else:
		print "\t" + nodeName, "node is up to date"

# end def		


def updateInstancesNodeIfNeeded(firebaseManager):


	print "Preparing initial data ...."
	startTime = datetime.now()
	# get current data for comparison
	## INSTANCES
	instancesNodeName = "instances"
	currentInstanceDataList = firebaseManager.get(instancesNodeName)
	if currentInstanceDataList.val() == None:
		currentInstanceDataListKeys = []
	else:
		currentInstanceDataListKeys = currentInstanceDataList.val().keys()

	## FUEL TYPE CATEGORY
	print "Data prepared in", str((datetime.now() - startTime).seconds), "second(s)"

	# Let's get current data
	for producerId, parser in parsersList.iteritems():
		try:
			print parser.__name__, ":"
			# data: {1 : [FuelModel.FuelComponent, ..., FuelModel.FuelComponent]}
			#		...
			# 	    {N : [FuelModel.FuelComponent, ..., FuelModel.FuelComponent]}
			
			fuelComponentsList = parser.process(producerId)
			print
			print "\tpreparing data to save ..."
			startTime = datetime.now()


			newInstancesDataDict = {}
			for fuelComponent in fuelComponentsList:
				dictKey = str(fuelComponent.producer) + "_" + str(fuelComponent.theDay) + "_" + str(fuelComponent.fuelType)
				if dictKey not in currentInstanceDataListKeys:
					newInstancesDataDict[dictKey] = fuelComponent.serialize()


			print "\tnumber of rows to update:", len(newInstancesDataDict)
			if len(newInstancesDataDict) == 0:
				print "\tall prices data are up to date"
				continue
			print "\tsaving prices data in firebase DB ..."
			startTime = datetime.now()
			firebaseManager.set("", instancesNodeName, newInstancesDataDict)
			print "\tdata saved in firebase DB in", str((datetime.now() - startTime).seconds), "second(s)"

		except Exception, e:
			print "++++++++++++++++ ERROR ++++++++++++++++"
			print e
			print "+++++++++++++++++++++++++++++++++++++++"
			continue


##################################################
##################################################
#################### MAIN ########################
##################################################
fileName = os.path.basename(sys.argv[0])
login = ""
password = ""

########### Obtain login and password from param list #################
usage =  fileName + " -l <login> -p <password>\n"
try:
	opts, args = getopt.getopt(sys.argv[1:],"hl:p:",["login=","password="])
except getopt.GetoptError:
	print usage
	sys.exit(2)

for opt, arg in opts:
	if opt == '-h':
		print usage
		sys.exit()
	elif opt in ("-l", "--login"):
		login = arg
	elif opt in ("-p", "--password"):
		password = arg

# check if login and password are not empty
if login == "" or password == "" :
	print "Lack of authentication data ..."
	print usage
	exit(1)

# Let's define list of parsers
parsersList = {ProducerType.lotos : lotosParser } #, 
			   # ProducerType.orlen : orlenParser}

##################  AUTHENTICATION ######################
print "Connecting to firebase ...."
startTime = datetime.now()
firebaseManager = FirebaseManager(login, password)
print "Connected in", str((datetime.now() - startTime).seconds), "seconds"

######################  STEP 1 ##########################
createFuelTypesNodeIfNeeded(firebaseManager)

######################  STEP 2 ##########################
updateInstancesNodeIfNeeded(firebaseManager)

