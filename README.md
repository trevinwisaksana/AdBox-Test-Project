# AdBox Test Project
AdBox is a simple app that displays various categories of advertisements and can locally save a users favorite ad.

## Installation
1. Head to the root directory of this project on Terminal
2. ```pod install``` to download all the dependencies
3. Build the project

## Description
AdBox is structured using MVVM. It contains a ```UITabBarController``` which has two root ```UIViewControllers``` that are embedded in a ```UINavigationController```. The app utilizes ```Alamofire``` to create a ```GET``` request on the ```JSON``` file and caches it once downloaded. Utilizing ```CoreData``` the app is able to save users favorite ad locally.

## Reflection
Overall, the app achieved all of what has been requested and more. It is neatly designed and it also includes some suttle animations to add some finishing touches to it. The app caches downloaded data to save the user from having to download a large ```JSON``` file repeatedly. It also has a separate function that allows users to refresh the app by downloading data from the internet so they can get an updated file. 

If I had more time, I would find ways to paginate the JSON file because it currently downloads the entire object. This may require some backend optimization, but I am writing this down to point out that I am aware of this improvement. Secondly, I also would like to do more Unit Testing to achieve a test coverage of at least 75%. From a design standpoint, the app currently crops the description and does not allow users to read the entire sentence. I would improve this by allowing a user to tap on any cell and open the advertisement on Safari or on a separate ```UIViewController```. 

![](https://github.com/trevinwisaksana/AdBox-Test-Project/blob/master/Screenshots/Favorites.png)
![](https://github.com/trevinwisaksana/AdBox-Test-Project/blob/master/Screenshots/Home.png)
