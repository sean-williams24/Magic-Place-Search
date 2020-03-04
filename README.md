# Magic Place Search

## Overview

On initial launch the user is asked to allow location services; enabling these will permit full functionality. Search 'type' is set to 'lodging' and the search also uses the keyword 'surf'. The user can enter a latitude and longitude into the texfields and search for places within a 1km radius. Tapping 'Use Current Location' will perform the searching using the users geo-coded location. The map view can be used to set a search area, just select the area required and tap 'Map Search'.

## Getting Started

Please enter your API key in the Auth.swift file.

Using the combination of type 'lodging' and keyword 'surfing', I was unable to obtain any search results. Please access the PlacesClient.swift file and change the place 'type' within the 'parameters' property to an alternative to see results. Using 'cafe' I found works.
