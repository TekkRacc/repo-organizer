# repo-organizer
## Description
The original Hochschule Mannheim PR1 Repo-Manager!

## Requirements
### Install CDT
In order for this script to work you must install the C/C++ Development Tools in Eclipse.
This can be done via "Help > Install new software" in Eclipse.

### Edit Variables
Change the Variables **eclipsePath** and **gitAccessMethod** to the absolute Path of your Eclipse Binary and Method how to access Git (HTTPS or SSH).

### Make the script executable 
```
chmod 700 reposcript.sh
```

### Quality of Life
When you are using HTTPS as git access method, constantly re-typing your git credentials can be annoying. Use:
```
git config credential.helper cache
```
to tell git to cache your credentials for this session.
