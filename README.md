# AdBox Test Project
AdBox is a simple app that displays various categories of advertisements and can locally save a users favorite ad.

## Description
AdBox is structured using MVVM. It contains a ```UITabBarController``` which has two root ```UIViewControllers``` that are embedded in a ```UINavigationController```. The app utilizes ```Alamofire``` to create a ```GET``` request on the ```JSON``` file and caches it once downloaded. Utilizing ```CoreData``` the app is able to save users favorite ad locally.

## Reflection
Overall, the app achieved all of what has been requested and more. It is neatly designed and it also includes some suttle animations to add some finishing touches to it. 

If I had more time, I would find ways to paginate the JSON file because it currently downloads the entire object. Secondly, I also would like to do more Unit Testing to achieve a test coverage of at least 75%. I would also create a more sophisticated caching system as the current one used is specifically assumes that the ```discover.json``` is static and does not change values.


![](https://github.com/trevinwisaksana/AdBox-Test-Project/blob/master/Screenshots/Favorites.png)
![](https://github.com/trevinwisaksana/AdBox-Test-Project/blob/master/Screenshots/Home.png)
