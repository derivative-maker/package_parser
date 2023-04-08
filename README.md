# Description

A simple script that uses Ruby to parse packages for Kicksecure and Whonix, and generates static HTML pages in the root of this repository. If you build a whonix site, the html will be found in `./whonix-packages-site`. Kicksecure will be found in `./kicksecure-packages-site`

In order for it to work, Ruby 3 must be installed. Also, you must have the package repository. To get the package repository,

## Usage

`$ ./build-site.sh <operating_system> <package_repository_path>`

#### Examples

`$ ./build-site.sh whonix ~/whonix-repository`
`$ ./build-site.sh kicksecure ~/kicksecure-repository`


