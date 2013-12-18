wordpress-plugin-checker
========================

This script will check in each sub-directory if there are updates in svn tags available. 

Introduction
------------

We use a lot of wordpress installations and each of them don't allow automatic
updates of the core and the plugins. Furthermore updates notices were disabled.

Each plugins will installed from svn and maintained by svn switch.

The Task
--------

Notifiy me via cron for any updates.

Usage
-----

```
./wp_update_checker.sh -d ../htdocs/wp-content/plugins
```
