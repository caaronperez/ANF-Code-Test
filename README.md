# ANF

## Description
This project adds the funcionality to get the data from the public service https://www.abercrombie.com/anf/nativeapp/qa/codetest/codeTest_exploreData.css where it displays images and contains different information for season/products

## Features
- Adding the testing needed for each function and added mock from json (added example where it can use dependency injection)
- Adding the storyboard elements to display the data (all labels added in stack view so no need for extra constraints)
- Adding exploreservice to fetch the data from the service, as well protocols and mock data in case dependency is needed
- Added exploredata structs to have codable elements to parse from json
- Adding string extension to display correctly the attributed string for bottomdescription
- Added imageloader and cell helpers to load image only once and have limited cache
- In controller each function for the elements was separated, the api call is made and the activity indicator is stopped and hide when finished, small animation for redrawing the image when fully loaded was added and at the end each button from content was added with similar style from PDF

## Installation
Instructions to set up the project locally:
1. Clone the repository:
   ```bash
   git clone https://github.com/caaronperez/ANF-Code-Test
