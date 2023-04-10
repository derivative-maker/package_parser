# Description

A simple application that uses Ruby to generate markdown data for Whonix and Kicksecure HTML packages sites. 

Markdown will be placed in `./docs`

## Setup
In order for it to work, Ruby 3 and Bundler must be installed. Also, you must have the respective kicksecure or whonix package repository. 

1. Install Ruby as a non-root user. You can use rbenv, RVM, or asdf to do this. The repo author prefers rbenv.
2. Run `$ gem install bundler`
3. Download the packages repository

```
sudo apt install rsync
rsync-ssl --recursive --delete --times --perms rsync://whonix.org/whonix/developer-meta-files/internal/ ../whonix-repository
```

## Usage


```
# ruby runner.rb <os_type> <repository_path>
ruby runner.rb whonix ../whonix-repository
```
