# Description

A simple application that uses Ruby to generate markdown data for Whonix and Kicksecure HTML packages sites. 

Markdown will be placed in `./docs`

## Setup
In order for it to work, Ruby 3 must be installed. Also, you must have the respective kicksecure or whonix package repository. 

1. Install Ruby. You can use apt-get, rbenv, RVM, or asdf to do this. The repo author prefers rbenv.
3. Download the packages repository

```
ruby --version # verify this is >= 3.0.0
sudo apt install rsync
rsync-ssl --recursive --delete --times --perms rsync://whonix.org/whonix/developer-meta-files/internal/ ../whonix-repository
```

## Usage


```
# ruby runner.rb <os_type> <repository_path>
ruby runner.rb whonix ../whonix-repository
```
