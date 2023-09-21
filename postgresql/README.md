# postgresql
this app aims to print all existing tables and their row and coloms inside a postgresql database. 

this is a part of homework for Databases for Data Science class at Aalto University

 ![demo of app](https://github.com/2trail/flutter/blob/main/postgresql/demo.gif) 
 
## Usage
Change line 60 at main.dart to connect database
```
...
void initState() {
    Provider.of<PostgresSql>(context, listen: false).initSQL("hostName", port, "dataBaseName", "username", "password");
  }
...
```
