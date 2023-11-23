# randcopy.sh
A simple script designed to work with any POSIX compliant system running bash, the concept of randcopy.sh is to facilitate the population of a target media/location with random files from a working directory.

## Description
The randcopy program is designed to run in a directory filled with an arbitrarily large number of files. It can take up to two arguments. The first argument is mandatory, which is simply a target directory to copy files to. The optional second argument can specify the total maximum space size of files you want to fill into that directory (up to the available space on the target, whichever is smaller). If the second argument is omitted, the script will use the `du` command to calculate the available space on the target.

The script works by randomly picking a file to see if it will fit on the target. If it does, it is copied over. If it does not, the file is removed from the list of files the script looks at, and the script continues to repeat the process of looking for a file that will fit and then copying it over to the target media until it can no longer find any files that will fit.

The usefulness of a script like this is for instance if you have a very large music collection which you could not fit all of on, for instance, a portable media player and want to ensure that when you reload it, it gets a truly randomized selection out of your media, but also that the space available on that device gets used as MUCH as possible. The author of this script had a need to put files like this on a thumbdrive to listen to in a car, which could only read up to a 16gb drive. This script would also be useful for instance to put pictures onto a digital photo album or even to copy books onto an eReader.

What makes this script particularly unique in its usefulness is that it is written to work in BASH, the Bourne Again Shell, and as a tool, is fairly ambivalent about WHAT it will copy. There are music players for other operating systems which can provide similar functionality for portable media players for instance, but may not support thumbdrives, or elseways they are not useful for copying files besides music. Other tools may randomize a music collection, but they do not attempt to optimize themselves to fill up as much space as available (or specified!), or they may fail for other reasons (such as being overcomplicated). The randcopy.sh script is designed to be extremely quick, efficient and simple in design without having to resort to too many external resources, so that it can be easily portable and not too hard to understand, or manipulate as necessary.

## Usage
```
[bash|sh] randcopy.sh <target> [MAXBYTES]
```
<target>: Should be a directory. This can also be a mounted location or a special link as long as <target> can also be specified as a valid parameter to `du -k` and `cp`. This is going to be the location where your files will randomly get copied to. You MUST have write permission to this location.

[MAXBYTES]: This is an optional argument that will override the available space calculation done by the script internally. This number must be less than the available space on the target or else you will get errors when the copy operation of the script fails.

## Notes
As a script goes, there is very little in the way of error checking that happens. Most of the error checking is done by careful consideration of how the kernel is going to protect the system in the long run (which is a fancy way of saying, its basically relying on programs like `cp` to fail if something goes wrong). We're basically assuming the end user has some idea of whats going on and is not going to accidentally (or even purposefully) use this script in some kind of destructive manner. Using `set -e` at the top of the script helps prevent the script from getting caught in an endless loop if a command fails and somehow the necessary calculation to reduce target size doesn't work or the pop operation on the array doesn't work, however it will also cause the script to die under any circumstance that causes `du`, `df`, `cp`, or `unset` to return a nonzero exit code (for instance, `cp` might fail if you try to copy a file to a device and the filename is not acceptable for some reason, like non-ascii characters... However without `set -e`, the script will simply pop that filename out of the list and continue to keep running on the remaining files if possible. If `set -e` is turned on, when the copy operation fails the first time, the script will just die).

This script is NOT going to play nice on systems where there may be multiple resources accessing the target at the same time, especially if they are WRITING to that target. It also does not play nicely with itself. The solution to this is that this script should REALLY be used on single user systems (e.g. desktop/laptop), and should be done under the careful consideration and monitoring of the end user. Common sense goes a long way (e.g., think about the effect of what you're going to do. Don't fire off this script from a loop that launches into the background and hits the same target from a dozen different directories at the same time, unless you've already PRECALCULATED the MAXBYTES for each directory and very carefully planned out your execution so that it doesn't overdo it. This might seem like a great way to get a lot of random files out of various different directories at the same time, but there is probably a much better way to do it, such as making a temp directory and symlinking all the files from the different directories you want into that single directory, and then executing a single instance of this script from THAT temp directory instead.)

Right now, the filelist is manually populated internally by the script from ALL available files in the current directory. This CAN be manually edited by changing the FILELIST declaration at the top of the file to specify the mask you wish to apply (for instance, *.mp3 or *.jpg). There are several reasons why it ended up done this way, primarily because it is just not a simple task to pass a filemask like this from the command line and get bash to properly interpret the result. That having been said, you CAN specify an arbitrary location instead of ./, however, YMMV. Attempts to experiment with this yielded mostly positive results, but quite often errors occurred which make this an unadvisable course of action. Most commonly, the script seems to fail to properly populate the FILESIZE array which results in improper calculation of bytes copied and eventually either errors from trying to copy too much, or it stops running way too early. It is a far better idea to just run the script directly from the directory you want to copy from.

At the time of this writing, this script will not check to see if [MAXBYTES] is larger than the available space on the target. The reason for this is because certain devices, especially those using MTP, may report incorrect available space values (such as zero available space when they are actually quite empty) to programs like `df`, even though they actually will properly copy a file. This script can still be used to copy files to such devices if you know roughly how much data you want to copy (in 1k blocks). So long as `cp` actually works to copy a file to the location, this script will continue to do so even if the device reports available space as zero. Again, this falls under the category of "end user needs to be smart". You can specify however much space you want but keep in mind that as mentioned above, if `set -e` is not configured at the top of the script, then it will continue to fail copy operation after copy operation until it either runs out of files to try or you break the execution with an interrupt.

## Requirements:
Bash v3.2.57 (2007) is the oldest version I had ready access to at the time of publication. I believe that this script will work on versions as old as 2.05a, as the only MAJOR requirement comes from brace expansion and the POSIX tests. Please email me (cyranix@cyranix.net) if you have more complete information for me.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[GNU GPLv3](https://choosealicense.com/licenses/gpl-3.0/)