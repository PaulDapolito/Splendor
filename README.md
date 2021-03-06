Splendor
========
<p align="center">
  <img src="http://i60.tinypic.com/14sphlj.png" width ="150px" hspace="5px"/> 
  <img src="http://i61.tinypic.com/15n4n0j.png" width="150px" hspace="5px"/> 
  <img src="http://i60.tinypic.com/ta3tdz.png" width="150px" hspace="5px"/> 
  <img src="http://i60.tinypic.com/jl582h.png" width="150px" hspace="5px"/>
</p>
## About
This is a public respository for my ongoing iOS project, Splendor. Splendor is an app which uses a user's latitude and longitude to display information regarding the sun as pertinent to their location, such as the sunrise time, sunset time, and total hours of sunlight. Splendor also provides an interface by which users can photograph the sunrise/sunset and have their photos catalogued on their iOS device. 

The first version of Splendor was published to the iTunes App Store on 6/25/2014, and it is freely available for [download](https://itunes.apple.com/us/app/splendor/id890240088?mt=8) on iOS devices.

## Attributions
To calculate sunrise/sunset times, I used [Ernesto García](https://github.com/erndev)'s open source [EDSunriseSet](https://github.com/erndev/EDSunriseSet) class. This open-source class is an Objective-C wrapper around the C-routines created by [Paul Schlyter](http://stjarnhimlen.se/english.html).

The sunlight map displayed on the homescreen of Splendor is generated and served remotely. This image is created using J.P.Westerhof's open source [sunlightmap](http://www.edesign.nl/examples/sunlightmap/) project. The code for this project is mirrored by [shadowhand](https://github.com/shadowhand) on Github under the name [sunlightmap](https://github.com/shadowhand/sunlightmap).

The images used in generating the sunlight map were obtained from [NASA's Visible Earth](http://visibleearth.nasa.gov/view_cat.php?categoryID=1484&p=3) project.

## Goals
My real motivation in putting this project on GitHub is to learn how I might make this project better and become a better software developer. I want to expand Splendor and further-refine the app's codebase, and I would love to hear any and all feedback regarding the app's design or implementation, and my coding practices.

My short-term goals for this project are:

1. ~~Implement an in-depth settings bundle, and perhaps implement a settings view within the app.~~
  * ~~Allow users to enable/disable notifications for the sunset.~~
  * ~~Allow users to enable/disable the use of their camera roll for image storage.~~
2. Transfer data storage in Splendor to Core Data.
  * Splendor currently uses SQLite, but in the future, I'd like to implement storage using Core Data. 
3. Create the sunlight map locally.
  * I want to adapt [sunlightmap](https://github.com/shadowhand/sunlightmap) to perform image-rendering on a user's iOS device.


## License
[MIT License](http://www.opensource.org/licenses/mit-license.php)
