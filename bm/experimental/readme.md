# Experimental Usage:

## %~2 is appended to URL if url flag set now.

### Here's a few useful use cases for this behavior.
* If %~2 doesn't contain spaces, do not quote wrap it.

*YouTube*  
Import: `bm yt https://www.youtube.com/results?search_query=`  
Usage: `bm yt never+gonna+give+you+up`  

*Scryfall*  
Import: `bm scryfall https://scryfall.com/search?q=`  
Usage: `bm scryfall legal:commander+set:fin+ci:mardu`
  
*ChatGPT*  
Import: `gpt https://chatgpt.com/?model=auto^^^&q= "query string for chatgpt"` (Model Specific)  
* If you are using multiple query criteria, it may be necessary to escape &s with two or three ^s.  
  
Import: `gpt https://chatgpt.com/?q= "query string for chatgpt"` (Automatic Model)  
Usage: `bm gpt "heres how we query chatgpt from command line, avoid special characters"`  

* Optionally you can just omit the model query and only include ?q=.  
* Here the %~2 does contain spaces, so make sure it's quote wrapped.  
* Some special characters will escape the scripting, so avoid using them in your search string.  
  
---
  
## Shell Calls  
  
### Explorer CLSID Calls  
* All tasks that can be accessed with CLSID shell call.  
* Avoids having to create .lnk or new folder to open this.  
  
`godmode` `call explorer shell:::{ED7BA470-8E54-465E-825C-99712043E01C}` `bm godmode`
  
Usage: ```bm godmode```  
  
## Clip Pipes  
  
### Limited Use-Case  
* Can be used as a pseudo password manager if software can't be installed on system but files can be created.  
* Uses pipes to copy text to clipboard.  

  
`labelname` `call echo|set /P=texttocopytoclipboard|clip` `bm labelname`
  
```bm labelname```  
  
