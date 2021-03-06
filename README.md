# Check fuel price

[![N|Solid](https://cldup.com/a06I-yFNUk.png)]()

Check Fuel Price aka Fuelpred is my private project created to present plenty techniques of developing applications on mobile ios platform. The app's code is written in Swift while backend one (which is used for provisioning data) is in Python.

# Architecture

Here you go high level architecture of my solution:

[![N|Solid](https://cldup.com/xAOyeufh3t.png)]()


1. Web scraping
2. Python daemon authenticates to Firebase project via email \ password
3. Python daemon updates Firebase database as soon as it notices any changes in data on source web sites
4. User authenticates to Firebase only for the first time or when signs out and switched to the other profile. Authentication can be done in one of most  convienient ways: using social network (facebook, twiter, google +) or email / password
5. App uploads needed data on demand and are in-sync throughout observers.
6. App uploads / downloads files from / to Firebase storage


# Remarks
- The application is isolated from collecting data. It makes it highly resistant to any changes in the structure of data in data source web sites
- even though the app is offline it still has an access to data previously downloaded using firebase persistency and reliability mechanism

# Features list, frameworks and techniques used in app:

#### Frontend/presentation layer:

- Creating Views:
	- from storyboard
	- programmatically
	- programmatically from pre-defined View/xib

- Creating constraints:
	- using Auto-layout
	- programmatically
	- with outleted constraints

- Table View
	- static
	- dynamic

- Collections
- SearchBar (integrated with UITableView)
- Tab bars with multiple views
- Progress bar

- Building Complex View 
	- nesting Container View one in another

- Internationalization: support for english and polish languages

- Transition betweenn Views
	- push with storyboards
	- push programmatically
	- modal with storyboards
	- modal programmatically
	- segue
	- unwinding

- Graphs
	- data presentation
	- tab bar graph

- Themes
	- changing themes in runtime

- Attributed string

- Image picker  

- Fixed orientation for certain View

- MapKit: coordinates, regions, spans

####  Backend:

- GCD
	- concurrency
	- serial

- Extensions

- Delegates

- Encloures

- Mobile backend as a service: Firebase

- Logs in details (SwiftyBeaver)

- Firebase features used in app: 
	- Authentication: Facebook, Twitter, Google+, email/password
	- Database: structuring DB, defining rules
	- Storage: defining rules
	- Push Notification (TODO)


- property:
	- stored
	- computed
	- KVO


Other
=======================================

- DevOps: 
	- Fabric\crashlythics for tracking crashes and metrics
	- Hockeyapp for distribution and user metrics
	- fastline for releasing app

- Managing dependency by means of dependency managers:
	- Cocoapods
	- Carthage


### Installation

```sh
$ git clone https://github.com/wstejka/CheckFP.git
$ pod install
$ carthage update --platform iOS
```
### Roadmap

- add Push Notification support


