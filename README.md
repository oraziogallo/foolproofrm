# Fool-proof rm
Have you ever `rm`'ed  something by mistake? It happens to the best of us, including the creators of Toy Story 2 (Try to Google "Toy Story 2 rm").  
`Fool-proof rm` is a small tool to prevent exactly that.
You use it and call it exactly like `rm` but, instead of permanently deleting files and folders, it time-stamps and moves them to its own trash folder. [Similar tools](#Alternative-tools) either define a list of protected folders, or implement a trash managment that requires specific commands.

## Usage
After installation, calling `rm` will move files or folders to the trash folder and prepend the time of deletion to the filename. The flags are the same as the native `rm` (see currently supported flags below).
To permanently delete files (traditional, dangerous behavior) use the flag `-D`.
The standard `rm` command can still be run using the fully qualified path (generally `/bin/rm`).

### Supported flags
| Flag | Supported/New | Comments|
| :---:|  :---:    |  :---:  |
| -D | New | Behave as traditional `rm`<sup>1</sup>|
| -E | New | Empty trash |
| -r | Yes | --- |
| -f | Partial | Don't prompt for read-only files |
| -h | Yes | --- |
| -v | Yes | --- |
| -i | Not yet | --- |
| --version | Not yet | --- |

<sup>1</sup> The rest of the flags are passed to `rm` directly. For instance, `rm -Dfv testfile` maps to `/bin/rm -fv testfile`.

## Installation
Clone this repository and run:
```bash
bash install.sh
source ~/.bashrc
```
The installation simply creates an alias to the script that "shadows" `rm` making the use of `fool-proof rm` transparent to the user.
No other change is made to the system.
Of course, you can also create a different alias--the script is totally self-contained.
Similarly, simply remove the `rm` alias in `~/.bash_aliases` to uninstall. 

## Alternative tools
* [safe-rm](http://manpages.ubuntu.com/manpages/bionic/en/man1/safe-rm.1.html)  
Prevents removal of a predefined list of folders.
* [rm-protection](https://github.com/alanzchen/rm-protection)  
Similar to `safe-rm` but asks for confirmation instead of preventing deletion.
* [trash-cli](https://github.com/andreafrancia/trash-cli)  
Implements a trash system, though it has its own commands that differ from `rm`.