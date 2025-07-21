# Experimental Usage:

## %~2 is appended to URL if url flag set now.

### Here are some use cases for this behavior:

**YouTube**  
Import: `bm yt https://www.youtube.com/results?search_query=`  
Usage: `bm yt never+gonna+give+you+up`  

**Scryfall**  
Import: `bm scryfall https://scryfall.com/search?q=`  
Usage: `bm scryfall legal:commander+set:fin+ci:mardu`
  
**ChatGPT**  
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
Import: `bm godmode call explorer shell:::{ED7BA470-8E54-465E-825C-99712043E01C}`  
Usage: `bm godmode`  
  
* *All Tasks*, that can be accessed with CLSID shell call.  
* Avoids having to create .lnk or new folder to open this.  
  
## Clip Pipes  
  
### Limited Use-Case  

Import: `bm clipdemo "call echo|set /P=texttocopytoclipboard|clip"` (You'll want to tailor this to each label.)  
Usage: `bm clipdemo`  
  
* Can be used as a pseudo password manager if software can't be installed on system but files can be created.  
* Uses pipes to copy text to clipboard.  

---

I'll continue to update this readme with other actual usecase bookmarks.
