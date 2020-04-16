# Fool-proof rm
Small tool to prevent involuntarily `rm`'ing important files.

## Usage
After installation, the `rm` command will move the files or folders to the trash folder and prepend the time of deletion to the filename. The flags are the same as the native `rm` (see currently supported flags below).  
To permanently delete files (traditional behavior) use the flag `-D`.

### Supported flags
| Flag | Supported | Comments|
| :---:|  :---:    |  :---:  |
| D | yes | Behave as traditional `rm` |
| r | yes | --- |
| f | partial | Don't prompt for read-only files |
| i | not yet | --- |
| v | not yet | --- |
| version | not yet | --- |
| help | not yet | --- |

## Installation
The installation simply copies the script in `\usr\local\bin` and creates an alias to it.
```bash
bash install.sh
source ~/.bashrc
```
## To uninstall
Simply remove the `rm` alias in `~/.bash_aliases`

