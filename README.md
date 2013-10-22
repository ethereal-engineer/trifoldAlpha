## What is this?

This is my response to a self-issued challenge on Twitter:
  
<blockquote class="twitter-tweet"><p>NEW GAME: pick 3 frameworks you&#39;ve been meaning to try or have never used before and build something random.&#10;<a href="https://twitter.com/search?q=%23devgames&amp;src=hash">#devgames</a> <a href="https://twitter.com/search?q=%23goodforyourgithub&amp;src=hash">#goodforyourgithub</a></p>&mdash; Adam Iredale (@iosengineer) <a href="https://twitter.com/iosengineer/statuses/390405105301729280">October 16, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

The idea is to expand your framework experience by doing something random. It doesn't even have to be useful. This, by example, is not useful at all!

## What does it do?

Not much. It downloads movie information and a movie poster from TMDb.org and then bounces the poster around a bit. The rating of the movie affects the "bounciness" of the poster. To change the movie, edit the movie identifier in `TFAViewController.m`.

## Frameworks Used

1. [AFNetworking](https://github.com/AFNetworking/AFNetworking)
2. [Magical Record](https://github.com/magicalpanda/MagicalRecord)
3. UIKit Dynamics

## Honorable Mention New Tools

1. [Mogenerator](http://rentzsch.github.io/mogenerator/)

## Platforms

This will only run using Xcode 5 and iOS 7.

## How to build

This project uses [CocoaPods](http://cocoapods.org/) as well, so you'll need to have that installed. Once you've got that, run this command in the project directory.

    pod install
    
You'll also need an API KEY from [TMDb](http://www.themoviedb.org/). They're free. All you need to do is register and request a key (it's automated, so don't put too much effort into your request reasons). Alternately, if you're chummy with me, just ask and I'll let you use mine - if you ask nicely...  

Once you've got your API KEY, replace the text `YOUR_API_KEY_HERE` in `TFAApiKey.h` *and only there*.  
  
That should about do it. Go build the useless demo!  
  
If there are any questions or suggestions, feel free to raise an issue or connect with me on [Twitter](https://twitter.com/iosengineer).