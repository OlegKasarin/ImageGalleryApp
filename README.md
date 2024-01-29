# ImageGalleryApp
Simple UIKit app / iOS 13

## Objective: Develop an image gallery app that allows users to browse and favorite images fetched from an API. 

## Requirements:

The app should have two screens: 
- a. Image Gallery Screen:
Display a grid of thumbnail images fetched from the provided API (details below).
Each thumbnail should be tappable and lead to the Image Detail Screen.
Implement pagination to load more images as the user scrolls to the bottom of the screen. 

- b. Image Detail Screen:
Show the selected image in a larger view with additional details, such as the image title and description.
Allow the user to mark the image as a favorite by tapping a heart-shaped button.
Implement basic swipe gestures to navigate between images in the detail view.

Use the Unsplash API (https://unsplash.com/developers) to fetch the images.

Register for a free API access key.
Use the "List Photos" endpoint to retrieve a list of curated photos.
Fetch the images in pages of 30 images per request.

Implement basic data persistence to store the user's favorite images locally.

Provide a mechanism to save and retrieve the list of favorite images.
Display a visual indicator on the thumbnail images in the gallery screen for the user's favorite images.

Design the user interface with attention to usability and aesthetics.

Ensure a clean and intuitive layout, considering different device sizes and orientations.
Use appropriate UI components and image caching techniques for smooth scrolling and image loading.

## Technical Guidelines:

Use Swift as the programming language.
Support iOS 13 and above.
Use UIKit for building the user interface.
Utilize URLSession or a suitable third-party library for network requests.
Follow modern iOS design patterns and best practices.
Structure the codebase with appropriate separation of concerns and modularity.
Implement proper error handling and data parsing.
Demonstrate proficiency in asynchronous programming.
Basic unit tests are encouraged but not mandatory.