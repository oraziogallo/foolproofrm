# Fool-proof rm
Small tool to prevent involuntarily `rm`'ing important files.
Fool-proof rm works like rm but, instead of permanently deleting files and folders, it time-stamps and moves them to its trash folder. 

## Usage
After installation, the `rm` command will move the files or folders to the trash folder and prepend the time of deletion to the filename. The flags are the same as the native `rm` (see currently supported flags below).  
To permanently delete files (traditional, dangerous behavior) use the flag `-D`.
The standard `rm` command can still be run using the fully qualified path (generally `/bin/rm`).

### Supported flags
| Flag | Supported/New | Comments|
| :---:|  :---:    |  :---:  |
| -D | New | Behave as traditional `rm -rf` |
| -E | New | Empty trash |
| -r | Yes | --- |
| -f | Partial | Don't prompt for read-only files |
| -h | Yes | --- |
| -v | Yes | --- |
| -i | Not yet | --- |
| --version | Not yet | --- |

## Installation
The installation simply creates an alias to the script that "shadows" `rm`.
```bash
bash install.sh
source ~/.bashrc
```
Similarly, to uninstall simply remove the `rm` alias in `~/.bash_aliases`. 
