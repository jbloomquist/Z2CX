# Experimental Usage:

## %~2 is appended to URL if url flag set now.

### Here are some use cases for this behavior:

<ins>**YouTube**</ins>  
Import: `bm yt`  
Target: `https://www.youtube.com/results?search_query=`  
Usage: `bm yt never+gonna+give+you+up`  

<ins>**Scryfall**</ins>  
Import: `bm scryfall`  
Target: `https://scryfall.com/search?q=`  
Usage: `bm scryfall legal:commander+set:fin+ci:mardu`

* If your target address has the equals sign (*=*) avoid using the NO_PROMPT method when creating a bookmark.
  * No prompt example: Label doesn't already exist and you type `bm labelname targetaddress`.
    * This creates a new bookmark called labelname with the target of targetaddress with no prompt.

<ins>**ChatGPT**  </ins>
Import: `bm gpt`  
Target: `https://chatgpt.com/?model=auto^^^&q=`  
Usage: `bm gpt "query string for chatgpt"` (Model Specific)  
  
* If you are using multiple query criteria, it may be necessary to escape &s with two or three ^s.  
  
Import: `bm gpt`  
Target: `https://chatgpt.com/?q=` (Automatic Model)  
Usage: `bm gpt "heres how we query chatgpt from command line, avoid special characters"`  
  
* Optionally you can just omit the model query and only include ?q=.  
* Here the %~2 does contain spaces, so make sure it's quote wrapped.  
* Some special characters will escape the scripting, so avoid using them in your search string.  
  
---
  
## Shell Calls  
### Explorer CLSID Calls
<ins>**All Tasks**</ins>  
Import: `bm godmode call explorer shell:::{ED7BA470-8E54-465E-825C-99712043E01C}`  
Usage: `bm godmode`  
  
* *All Tasks*, that can be accessed with CLSID shell call.  
* Avoids having to create .lnk or new folder to open this.  
  
## Clip Pipes  
  
### Limited Use-Case  

<ins>**Copy String To Clipboard**</ins>  
Import: `bm clipdemo "call echo|set /P=texttocopytoclipboard|clip"` (You'll want to tailor this to each label.)  
Usage: `bm clipdemo`  
  
* Can be used as a pseudo password manager if software can't be installed on system but files can be created.  
* Uses pipes to copy text to clipboard.  

---

I'll continue to update this readme with other actual usecase bookmarks.
