# Wallpaper Updater Script
A simple batch script that allows you to update your wallpaper to a "safe" and an "unsafe" wallpaper. This is useful for those who use the same device for work and home use, and want to quickly change their wallpaper to something more appropriate for work.

# How to use
1. Download the script.
2. Open the "properties" of the script from the right-click menu, and click "Unblock" if it is present, and apply the changes.
3. Create a `.env` file in the same directory as the script, and add the following lines:
```
SAFE_WALLPAPER="C:\path\to\safe\wallpaper.jpg"
UNSAFE_WALLPAPER="C:\path\to\unsafe\wallpaper.jpg"
```
4. Run the script, passing either `safe` or `unsafe` as the first argument to the script. For example, `.\wallpaper-updater.bat safe` will set the wallpaper to the safe wallpaper.

## Scheduled Task
I strongly suggest setting this script up as a scheduled task to run on a given event, such as when you connect to your work's Wi-Fi. Follow the below instructions to do just that:
1. Open the Task Scheduler (`taskschd.msc`)
2. Click "`Create Basic Task`" from the right-hand menu.
3. Give the task a name and description, and select an appropriate trigger. If you'd like to run the script when you connect to a Wi-Fi network:
    1. Select "`When a specific event is logged`" 
    2. Select "`Microsoft-Windows-NetworkProfile/Operational`" as the log, and "`NetworkProfile`" as the source. 
    3. Select "`10000`" as the event ID
    4. Select "`Start a program`" as the action
    5. Enter the path to the script as the program/script, and `safe` or `unsafe` as the argument.
    6. Ensure that "`Start in`" is set to the directory containing the script.
    7. Click "`Finish`"

4. Once the task has been created, right-click on it and select "`Properties`".
5. On the "`General`" tab, ensure that "`Run whether user is logged on or not`" is selected, and that "`Run with highest privileges`" is checked.
6. On the "`Conditions`" tab, uncheck "`Start the task only if the computer is on AC power`".
7. On the "`Conditions`" tab, ensure that "`Start only if the following network connection is available`" is checked, and that the appropriate network is selected (i.e. your work network).
8. On the "`Settings`" tab, ensure that "`Allow task to be run on demand`" is checked, and that "`Stop the task if it runs longer than`" is set to 1 hour.

Ensure that you create two scheduled tasks - one for your home Wi-Fi ('unsafe' wallpaper), and your work Wi-Fi ('safe' wallpaper).

# License
[The Unlicense](https://unlicense.org/)