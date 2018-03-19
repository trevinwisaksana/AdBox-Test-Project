# AdBox Test Project
AdBox is a simple app that displays various categories of advertisements and can locally save a users favorite ad.

## Installation
1. Head to the root directory of this project on Terminal
2. ```pod install``` to download all the dependencies
3. Build the project

## Description
AdBox displays different categories of advertisements such as trending (based on the highest score on the ```JSON``` file), cars and real estate. Users can also see all of the advertisements of each category by selecting the "See more" button. It can locally save a users favorite ad by pressing a like button which will show it in the favorites tab. 

AdBox is structured using MVVM. It contains a ```UITabBarController``` which has two root ```UIViewControllers``` that are embedded in a ```UINavigationController```. The app utilizes ```Alamofire``` to create a ```GET``` request on the ```JSON``` file and caches it once downloaded. Utilizing ```CoreData``` the app is able to save users favorite ad locally.

## Reflection
Overall, I believe the app is neatly designed which includes some suttle animations to add some finishing touches and rounded corners. From an optimization standpoint, I am partcually pleased that the app caches downloaded data to save the user from having to download a large ```JSON``` file repeatedly. It also has a separate function that allows users to refresh the app by downloading data from the internet so they can get an updated file.

If I had more time, I would find ways to paginate the JSON file because it currently downloads the entire object. This may require some backend optimization, but I am writing this down to point out that I am aware of this improvement. Secondly, I also would like to do Unit Testing to achieve a test coverage of at least 75%. From a design standpoint, the app currently crops the description and does not allow users to read the entire sentence. I would improve this by allowing a user to tap on any cell and open the advertisement on Safari or on a separate ```UIViewController```. Lastly, I would also fix a bug that is caused by the ```UICollectionViewFlowLayout``` which dislocates the collection view header after dismissing the ```DisplaySectionViewController```.

![](https://github.com/trevinwisaksana/AdBox-Test-Project/blob/master/Screenshots/Favorites.png)
![](https://github.com/trevinwisaksana/AdBox-Test-Project/blob/master/Screenshots/Home.png)
