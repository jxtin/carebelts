# Carebelts

## INTRODUCTION



**Carebelts** is a product idea developed by Team Pontiac Bandits.
It is an automated monitoring and caretaking system for children/babies/pets/elderly people etc which can be set up to cater to every need of you and your loved ones while you are away from home.
CARE-Belts are collars/bands that can generate a health or comfort index of your pets/children/old parents’ vitals in order to automatically trigger various appliances in your home by accounting and reporting the deviation of the being’s vitals from their normal range sent to the integrated software app/website on the home owner’s phone. This is done by allowing the person’s home to be automated through a basic Alexa that is integrated with all the needful output devices like lights, fans, thermistors etc. Extra devices like micro-controller based feeders have also been seamlessly integrated within the same application ensuring that every need of the individual staying home is catered to a one-fits all click-based solution.

Carebelts provide continuous tracking of four of their vitals : *SPO2, heart rate, temperature and blood pressure*, to ensure their wellbeing and provides IOT based integration which can be automated or triggered remotely. The IOT interactions provided in POC include lighting based on vitals and predicted state of mind, music, food-dispensing, with future scopes having no limits.
Those who are being monitored will have a carebelt while the person who wishes to monitor will recieve a web and app based dashboard so they can keep a check on their loved ones as and when required. 
Carebelts is a unique way to ensure the well-being of the ones we wish to care about, physically and emotionally, and interacting using the capabilities of IOT and smart homes.

As the part of our POC we have hardware files and software codes linked, which includes CAD models, stl files, circuit diagrams, and the codebase for the software end. We also have deployed the application and web dashboard with mock data available 24*7 for an experience of how software end appears and reacts to the inputs, to test it out.



## Prototype

The prototype thus includes both a hardware and a software part developed through three versions to get to the final product. Our existing prototype versions have been made available in the form of various folders in the repository. 

The idea behind making multiple versions was to ensure that the developing hardware adds to the functionalities of the software end in a manner that would improvise on the existing product and allow for further scaling / improvements without rendering the mobile application / website for our product entirely dysfunctional. The future could see the development of the physical hardware further with the application and the website dashboard being intact.

The software includes admin-side dashboard and a client side mobile application. A python web flask is used to make the admin side dashboard. Flutter technology is used in the client side application. Because of lack of direct hardware data fetching, the data for the dashboard is being fetched from Cloudant through a randomly generated a database. The web site & client side app are dynamic in nature and are updated as new data is realised by the web/ mobile app. Dynamic updating and health analytics make it easier for the the caretaker to understand the health status of the carebelt user and provide the IOT services available at the moment.

The final version's admin-side dashboard is on this [site](https://carebelts.jxt1n.repl.co/).

The final version of the application has been deployed on this repository.
