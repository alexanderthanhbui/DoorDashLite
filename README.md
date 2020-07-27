# DoorDashLite

App which displays restaurants on a tableView from a DoorDash API

## Thoughts:

I wanted to keep the project simple. At first I wrote a separate networking layer but eventually went with AlamoFire and use Codable for parsing JSON as I have never tried that before. I found that it was very simple to use although one can argue that using a dependency for just one of its feature is overkill. I also decided to use sdwebimage (an image downloading and caching framework) due to its simplicity. 

As for an architecture, I went with MVVM for scalability. As the project grows, I suspect the view controllers will become massive if done with the traditional MVC pattern. 

