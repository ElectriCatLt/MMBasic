This is experimental 'Stand alone' help for Picomite HDMI/USB/2350 computer 
More on  Picomite HDMI/USB/2350 computer at https://geoffg.net/picomitevga.html

This help is mostly copy of Picomites` family official manual but in form  of searchable text database.
As it is stored in SD card and in plain text format and does not take too much space, additional examples and reading materials can be added, comparing to official manual.
Any beta changes in firmwares, like new commands or functionality, can be added or removed with no need to re-print paper version of oficial manual. 
Thanks to LIBRARY functionality, this help can be called typing 'help' in command prompt. Later user can get back to program editing.
But keep in mind this is experimental project, so You must always check with official manual.

Use should be simple. 
User just enter one word search phrase and help returns everything maching phrase. 
Try and enter 'DRAWING' and program will list in short form everything relateted to drawing - commands, functions or tutorials.
Every topic has number [nn]. If user enters >nn, topic will be listed in full format.
For example type RUN and program will list few topics. List begins with number [>59]
If user will type '>59' topic will be listed in full format.

Similar effect has key '-f' 
If user would enter 'RUN -f', same topics fill be listed, but this time in full format.

If user would type in '-x' or press 'ctrl+C' - program will exit. 
'-x' is reccomended way to exit as CTRL+C and re-Run might throw an "variable already declared" error. 
This case, Just enter - exit built in editor by pressing F4

Key '-s" would list keyword suggestions.

It must be noted: search phrase is not case sensitive, but keys '-f', '-x', '-s' and '-h' are CASE SENSITIVE.

Prepare: 
Copy HELP with contents to SD card.
Enter command
CMM2 LOAD "Help.bas"

Enter command 
LIBRARY SAVE

Now, you can type 'help' in command prompt, and call for help anytime without need of paper printed user manual or PC
This will not destroy current program you might run-editing at the moment

Hope this program will serve You well. Good luck! 
