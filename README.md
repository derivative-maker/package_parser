# Description

A simple application that uses Ruby to generate markdown data for Whonix and Kicksecure HTML packages sites.

Markdown will be placed in `./docs`

## Setup
In order for it to work, Ruby 3 must be installed. Also, you must have the respective kicksecure or whonix package repository.

1. Install Ruby. You can use apt-get, rbenv, RVM, or asdf to do this. The repo author prefers asdf.
2. Download the packages repository

```
ruby --version # verify this is >= 3.0.0
sudo apt install rsync
rsync-ssl --recursive --delete --times --perms rsync://whonix.org/whonix/developer-meta-files/internal/ ../whonix-repository
```

## Development Usage

#### Generating Package Markdown

From the root of this repository:

```
# ruby runner.rb <os_type> <repository_path>
ruby runner.rb whonix ../whonix-repository
```

## Publishing the HTML sites

```
./publish-site.sh <os_type> <os_repository_path> <os_static_site_generator_repo>
```

examples:

```
./publish-site.sh whonix ~/whonix-repository ../whonix-packages
./publish-site.sh kicksecure ../kicksecure-repository ../kicksecure-packages
```
