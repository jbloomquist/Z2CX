# Experimental Usage:

## %~2 is appended to URL if url flag set now.

### Here's a few useful use cases for this behavior.
* If %~2 doesn't contain spaces, do not quote wrap it.
  
`scryfall` `https://scryfall.com/search?q=` `bm scryfall searchstring`

```bm scryfall legal:commander+set:fin+ci:mardu```

* If you are using multiple query criteria, it may be necessary to escape &s with two or three ^s.
* Here the %~2 does contain spaces, so make sure it's quote wrapped. 

`gpt` `https://chatgpt.com/?model=auto^^^&q=` `bm gpt "query string for chatgpt"`

```bm gpt "heres how we query chatgpt from command line, avoid special characters"```
