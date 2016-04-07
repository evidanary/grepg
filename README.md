#grepg
###The ruby client for greppage

`grepg` (pronounced Grep G) is a ruby client for [GrepPage](https://www.greppage.com).  It is packaged as a gem.

###Install
To install `grepg` run ```gem install grepg```

###Examples
```
Usage:
grepg user_name topic_name [-s search_term]
```

Get all items/microdoc for a topic on any collection.

```
$ grepg kdavis git
User: kdavis, Topic: git
push tags to remote / Github
git push --tags

remove delete tag
git tag -d v0.0.8

list branches that have not been merged
git branch --no-merged

list branches merged into master
git branch --merged master
...

```

Search for a specific string

```
$ grepg kdavis git -s stash
User: kdavis, Topic: git, Search-Term: stash
TO apply your changes
git stash --apply

To list the stash
git stash list

Git stash
git stash
```

##Development
To run tests run ```bundle exec rake spec```. To install the gem locally, first build it using ```bundle exec rake build```. Then install the gem ```gem install pkg/grepg-0.0.1.gem```

##License
grepg is under the [MIT License](http://www.opensource.org/licenses/MIT).
