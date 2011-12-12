# What is FTS?
FTS stands for '**F**ull **T**ext **S**earch', it is a hot area in CS. See [Wikipedia](http://en.wikipedia.org/wiki/Full_text_search) for more information.

# SQLite and FTS?
Yes, SQLite originally support FTS, and released FTS with FTS 1.0, FTS 2.0, FTS 3.0 and FTS 4.0. Basically, FTS 4.0 is as same as 3.0. The only difference between these two versions is [performance](http://www.sqlite.org/fts3.html#section_1).

# Does SQLite on iOS support FTS?
**NO**, the SQLite library shipped by Apple does not compiled with FTS enabled.

# Can I use SQLite+FTS on iOS app?
**Yes**, that's why I created this project.

# What's the purpose of this project.
This project is built to show you how to link to [sqliteFTS](https://github.com/TonnyXu/sqliteFTS) project, which is also created by me to use SQLite with FTS, and how to use FTS with iOS technologies.

# Data Source
To demonstrate how fast SQLite + FTS could be, I downloaded a open source Japanese/English dictionary from Professor [Jim Breen](http://www.csse.monash.edu.au/~jwb)'s long run [EDict project](http://www.csse.monash.edu.au/~jwb/edict.html). Many thanks to Prof. Jim.

# License
This app is under [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html). You can use it for open source/commercial project.