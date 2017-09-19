
Note - trying out a new layout, seems to have a lot of merit in preventing
the massive view controller, and isolating things better for unit testing,
localized organization and separation of data within the view controller,
called the modlizer design pattern.

In short, each view controller, if able, is broken down into these common chunks
following the naming convention of:

[optional project 2 letter prefix (I do not use)] + view/controller name + chunk description

for instance, our class is AlarmViewController, and possible chunks within it could be

AlarmViewController         - core view controller
AlarmTableViewController    - any table view protocols
AlarmScrollViewController   - any scroll view protocols
AlarmButtonController       - IBActions, button routines
AlarmData                   - any data handling
AlarmNetwork                - any network handling
...

basically anything which makes sense to separate out into it's own file

source:  https://medium.com/ios-os-x-development/struggling-with-ios-design-patterns-embrace-modlizer-85d621d4e734
