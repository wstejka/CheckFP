#!/home/wstejka/virtualenv/firebase/bin/python
import pyrebase
import sys, getopt, os

config = {
  "apiKey": "AIzaSyB5gJnV0cCayzgD5sZHhUCGovrJiPlozcU",
  "authDomain": "checkfuelprice-d5d3d.firebaseapp.com",
  "databaseURL": "https://checkfuelprice-d5d3d.firebaseio.com/",
  "storageBucket": "gs://checkfuelprice-d5d3d.appspot.com"
}

config2 = {
  "apiKey": "AIzaSyAqEAN1PMOMeKQWWox2LECz-CoeyP7pu6I",
  "authDomain": "grocr-ddd20.firebaseapp.com",
  "databaseURL": "https://grocr-ddd20.firebaseio.com",
  "storageBucket": "gs://grocr-ddd20.appspot.com"
}

directory = os.path.dirname(sys.argv[0])
credentials = directory + "/credentials"
print credentials

# IMPORTANT REMARK: 
# Due to security reason credentials are kept in separate file which is called "credentials"
# Information should be stored there in format: "login|password"
class FirebaseManager(object):
	"""docstring for FirebaseManager"""

	login = ""
	password = ""
	firebase = None
	db = None
	userIdToken = None

	def __init__(self, login=None, password=None):

		if not login or not password:
			self.login, self.password = self.getCredentials()
		else:
			self.login = login
			self.password = password

		firebase = pyrebase.initialize_app(config)

		###### AUTHENTICATION ############
		# Get a reference to the auth service
		auth = firebase.auth()

		# Log the user in
		user = auth.sign_in_with_email_and_password(self.login, self.password)
		# Refresh token as it can expire after 1 hour
		user = auth.refresh(user['refreshToken'])
		# now we have a fresh token
		self.userIdToken = user['idToken']

		######## DATABASE #####################
		# Get a reference to the database service
		self.db = firebase.database()

	def getCredentials(self):

		f = open(credentials, "r")
		stringWithCredentials = f.read().strip("\n")
		f.close()
		credentialPair = stringWithCredentials.split("|")
		if len(credentialPair) != 2:
			return ["", ""]
		return credentialPair

	def set(self, nodeName, dictKey, dictData):
		
		# companies = db.child("companies").get()
		# print self.userIdToken
		self.db.child(nodeName).child(dictKey).set(dictData, self.userIdToken)

	def  get(self, nodeName, shallow=None):
		if shallow == True:
			return self.db.child(nodeName).shallow().get(self.userIdToken)
		else:
			return self.db.child(nodeName).get(self.userIdToken)

	def  remove(self, nodeName):
		return self.db.child(nodeName).remove(self.userIdToken)

	def  update(self, data):
		return self.db.update(data, self.userIdToken)

if __name__ == "__main__":
	firebaseManager = FirebaseManager()
	print firebaseManager.db
	lastTimestamp = 2482966000
	values = firebaseManager.db.child("fuel_price_items").order_by_child("P_FT_T").start_at("2_").end_at("2_2_" + str(lastTimestamp)).limit_to_last(10).get().val() #order_by_child("timestamp").get() #order_by_key().get().val() # order_by_child("height").limit_to_first(5).get()
	for item in reversed(values.values()):
		# print item
		print  item["producer"], item["fuelType"], item["humanReadableDate"], item["timestamp"]

	print "========="

	values = firebaseManager.db.child("fuel_price_items").order_by_child("P_FT_T").start_at("2_").end_at("2_2_" + str(lastTimestamp)).limit_to_last(5).get().val() #order_by_child("timestamp").get() #order_by_key().get().val() # order_by_child("height").limit_to_first(5).get()
	for item in reversed(values.values()):
		# print item
		print  item["producer"], item["fuelType"], item["humanReadableDate"], item["timestamp"]
		if (lastTimestamp > item["timestamp"]):
			lastTimestamp = item["timestamp"]

	print "========="
	values = firebaseManager.db.child("fuel_price_items").order_by_child("P_FT_T").start_at("2_").end_at("2_2_" + str(lastTimestamp - 1)).limit_to_last(5).get().val() #order_by_child("timestamp").get() #order_by_key().get().val() # order_by_child("height").limit_to_first(5).get()
	for item in reversed(values.values()):
		print  item["producer"], item["fuelType"], item["humanReadableDate"], item["timestamp"]



	# firebaseManager.remove("test")
	# firebaseManager.db.child("fuel_types").order_by_child("id").get() #.order_by_child("timestamp").get() #.limit_to_first(5).get()





