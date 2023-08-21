# kolmafia-Alii.ash

KoL Script to handle looping if your name is Aliisza. This script does some things that are super specific to me personally. It will work for anyone who wants to either loop cs, or gyou. 
But you'll need to look over it and modify things that it does that you don't want it to.

## Installation:

To install, paste the following into the CGLI:

`git checkout https://github.com/Myrcyr/Alii.ash`

To run, type `alii "tasks"` into the CGLI. 

List of tasks:
coffee, ascend, gyou, cs, lunch, smoke.

List of abbreviations:
cloop, gloop, post

Examples of possible calls:

`alii cloop` Runs a full day while looping CS and doing yachtzeechains.

`alii gloop` Runs a full day while glooping and only yachtzee's for breakfast.

`alii coffee ascend cs smoke` Same as if you ran "cloop". Script allows you to run individual tasks at a time, or group them together with multiple arguments.

`alii post` Post runs only lunch and smoke. Used in cases where the grey you run crashes midway thru. Allows you to pickup the post run farming with a single arg.


## Script Dependancies:
loopgyou          -automates the grey you runs.

lcswrapper          -automates the cs runs(can use any script, just have to edit the lunch function).

garbo          -farming script.

PandAliisza          -steel marg script which utilizes banderboots runs.

c2t_ascend          -handles valhalla.

zlib          -only nessasary for me. handles kmail function.

ptrack          -profit tracking.

CONSUME          -handles nightcaping.

levelup          -handles leveling up after gyou run.

rollover management          -handles equipping PJs and other stuff(old script, probably outdated, could drop but I'm fond of it).


Happy Looping!
