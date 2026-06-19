---
title: "Tracking books with web hooks"
date: 2025-07-30
---
One of my favorite things about small projects is the way in which their constraints can inspire unexpected solutions. You might expect a simple design to limit the room for creativity, but in my experience the opposite is often true. 

With this project I had the good fortune to stumble into a solution that 1) taught me something new, and 2) leveraged each puzzle piece's natural features in a way that preserved the minimalism I was going for.

In this case the puzzle pieces were Netlify (with its build hooks) and Google Forms (with its Apps Script platform integration).

## A book tracker

The idea was to build a quick and easy way for my wife and I to log the books we finish in a shared list. We didn't need a full social media platform like Goodreads, and in fact the UI cruft there added friction to the book entry process. Likewise our phones' Notes app was too simplistic, missing basic features like sorting and filtering. But something relatively low-tech seemed best, given our limited requirements and reluctance to buy into another app or ecosystem.

So we landed on a spreadsheet, which appealed to me as a data store, but fell short as a view/edit layer, since we mostly planned to be using the tool on our phones. Pinch-zooming around a spreadsheet on a 6-inch screen isn't much fun. Google Forms tied the data entry side together as it had decent mobile UX and could be set up to feed responses into a spreadsheet. Only the view layer remained.

Lately I've been reaching for vanilla JavaScript and HTML more often when building simple websites. After all, isn't React just the Goodreads of frontend frameworks? That's not the low-tech spirit we're looking for here. We need only fetch our books from the Google Sheets API and display them in a single column list. Add some basic sort/filter options and call it a day. That has Web 1.0 written all over it. 

In order to hide my API key from prying eyes, I decided to make the call server-side, which is like, even more Web 1.0 since the earliest browsers didn't even run JavaScript.

For hosting I reached for the friendly and familiar (and free) Netlify, which has served me well over the years. In effect I'd write my own barebones static site generator in a single JS file, which would insert the book data into an HTML string and write it to an `index.html` file. Netlify would run that JS file at build time and serve the HTML.

## A build hook

For a while I thought I'd finished. I'm not proud to admit how long I scratched my head when newly added books didn't appear on the site. Then I pushed a small code change to Github, which triggered a new Netlify build, and suddenly the books appeared. Of course. The Google Sheets API fetch only happened at build time. I needed an automated way to tell Netlify whenever a new book was added to the spreadsheet.

Another admission: in my 8 years as a frontend engineer, I've never really taken the time to learn about webhooks. I'd only heard about them in passing and had a vague notion that they could connect disparate web services. Since educating myself on the concept, I'm glad to report that I wasn't too far off the mark. Red Hat sums it up:

> A webhook is a lightweight, event-driven communication that automatically sends data between applications via HTTP

I poked around my Netlify dashboard hoping to find something useful. Thankfully they've thought of just about everything (this is not a sponsored post), and I eventually lit upon a build hooks section. It promised to give me a unique URL that I could use to trigger a build, and by golly, it did just that.

```
curl -X POST -d '{}' https://api.netlify.com/build_hooks/<my-hook-id>
```

With hook in hand, I headed back over to the Googleplex to figure out whether I could make it sing my particular tune.

## An app script

The Google ~~minefield~~ suite of products and services is a daunting place to find yourself. On the developer side, it feels like every other feature is buried behind layers of usage agreements, consent screens, and granular credentials that rival the ~~worst~~ best AWS has to offer.

Thankfully the Apps Script page is mercifully minimal and requires only a modest amount of documentation to comprehend. Once my reading had convinced me it was possible, I set about creating a trigger that would run whenever my Google Form was used to submit a new book. My little function amounted to no more than a fetch request:

```javascript
function onFormSubmit() {
	const WEBHOOK_URL = 'https://api.netlify.com/build_hooks/<my-hook-id>';
	var options = {
		"method": "post",
		"headers": {
			"Content-Type": "application/json"
		},
		"payload": {},
	};
	UrlFetchApp.fetch(WEBHOOK_URL, options);
}
```

I then set up a new trigger that called this function on form submit. Interestingly, the other event type option was on form *open*. Seems like jumping the gun there a bit, but to each their own.

Once I'd wired this up I was finally able to trigger new website builds whenever a book was added. This wasn't instantaneous, but a dozen seconds is perfectly adequate considering we rarely rush right over to check. I'll admit I did rush over a few times when I first got it working. It's cool, okay? It works! And not a dime spent.

Before I let you go, I thought I'd mention for posterity that there was also an option to attach an app script to the spreadsheet instead of the form. This had the advantage of potentially triggering builds whenever the sheet was updated (which would capture new books in addition to, say, fixing typos). I opted to stick with the form-based script because I didn't feel I needed that level of responsiveness. Small fixes would go out alongside new form submissions eventually.

## A last word

For those of you who came along hoping for a more granular guide on how to trigger Netlify builds with Google Form submissions, I hear you. I originally wrote a 1,500-word draft that covered the process in much more detail. Numbered steps, screenshots, more code blocks, etc. It may have been useful (maybe) but it wasn't any fun to write. 

I decided to frame this as a personal retrospective because it felt more natural and human. It also more closely represented the kind of work I want to share on this site. If you're building an app or site that could use this functionality, let's chat. I can fill in the gaps.

In the meantime, off to read a book!
