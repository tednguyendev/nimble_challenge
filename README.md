# [WIP] Documentation
I will use this README to show about my approach, what obstables I met, what are the features that I will implement if I still have time, the demos, ...

## Demos
- [First MVP 2023-03-19 17:47](https://share.cleanshot.com/bWY03jmP)

## Links
- [Frontend github repo](https://github.com/tednguyendev/nimble_challenge_fe)
- [Postman collection(version 2023-03-19 20:00)](https://api.postman.com/collections/9434315-f930a92c-eb4e-48ee-89ef-8fb53ff49baf?access_key=PMAT-01GVWZ6R79MM3W3JXV76YR3B56)
- [.env file]()
  - TBD

## Obstacles and approaches
### Obstacles
As I researched, one of the most popular and most efficient ways to handle the limitations of mass-searching keywords that people usually use are:
- Use the Google Search API
- Use the Google Search Scraping services from third-party services

But as we can not use the third-party services, I then move on to find if there are any other ways.

Another method I find is to rotate the proxies.

In short, as we send requests to the servers, one of the most basic and most reliable ways the servers can use to rate limit or to prevent DDoS is to detect and limit the requests based on the IP of the clients.

So the most obvious way to bypass this is to not only have one IP, which is to use rotating proxies.

But we can not use any third-party services, including the third-party services that provide the rotate proxies services.

I also discovered other ways to handle the mass-searching problem, but I'm afraid they are still considered third-party services.

As to rotate proxies, using third-party services is not the only way:
- We can create our own proxies to rotate.
- We can scrape sites that provide free rotate proxies, like [this](https://free-proxy-list.net/rotating-proxy-open.html), to have a list of short-lived free-to-use proxies.

Besides that, we can distribute the crawl to multiple machines, and each server can have its own IP.

Another way is to use the headless browser to run the Tor browser - the browser that can help its user browse the internet anonymously without exposing their IP.

These are all the ways that are still very effective in protecting the application from being banned, although not as effective as using rotating proxies or scraping services. But since I think they are still third-party services(creating our own proxies may need tools and servers, using Tor means that we depend on Tor, or distributing the crawl may need more cloud servers ,...), I won't use them. But if they are not and I can use them, please tell me; thank you!

### My approaches
Not as effective as the earlier methods, I figured out that there are still ways to reduce the chance of the application being banned.

If we can not have many IPs, we must be as human as we are when scraping the pages.

The first method is to use random sleep(delay) time.

Between each request to search Google, I put a randomly generated sleep time between 0.2 and 1.2 seconds as a mimic of human behaviour.

I also put in a random sleep time(a bit longer) between every ten requests, also as a mimic of being a human.

The next method I use is that I have a list of user agents(about 1000 agents), and I rotate and pick one of them to use for each request to appear as if we are accessing the site from different devices or browsers.

And the last thing is that I use the headless browser Selenium, as a headless browser allows us to simulate a web browser without a graphical user interface, which can help us crawl websites more efficiently and avoid detection. Another reason I use Selenium is that these headless browsers can help us scrape the sites that also use JavaScript to render the pages(Like Google).

Of course, these are not foolproof methods to prevent being banned or blocked entirely, but every technique that can help us reduce the chance of being banned is worth implementing.

One area of concern for using the headless browser is its slowness.

To improve this, I also tried to use the Typhoeus to try to crawl, and although I found that it can speed up this process a lot by fetching pages parallelly, doing this faster also means that we are sending more requests to the servers, which also means that we are more likely to be banned(it only took like 4 or 5 CSV file uploads to be rate limited).

The first method is to partially load and show the user the scraped data for each keyword as soon as possible.

Like this,

![Keyword load](public/keyword-load.png)

The scraped information of each keyword row will be shown to the user periodly(I use polling API calls, with 4-second intervals), and although the user will still need to wait for all other keywords to be processed, they can look at the newly updated scraped keyword information row and work on that row first, when waiting for the other keywords to be scraped.

Another method is, instead of asking the user that they have to keep the browser open and to sit there and wait for the result, I tell the user that they do not need to stay, and instead, the Nimble Scraper application will send them a notification email after the whole process is finished.

The note:

![Mail note](public/mail-note.png)

The email:

![Report finish](public/report-finish.png)

## Code structures
### Backend(Rails)
...

### Frontend(React)
...

## Current features
...

## What's left
...
- Improve codebase, adding more tests, make the code cleaner
- Handle more edge cases
- Improve UI-UX
- Deploy the application to AWS using LightSail
- Keep updating the documentation so that we can communicate asynchronously easier.

## Optional incoming features
...

## Benchmark
...