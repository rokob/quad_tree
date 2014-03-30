# QuadTree

This is a simple implementation of a spatial data structure commonly referred to as
a quad tree because it is a tree where each non-leaf node has four children. It is useful
for doing queries about points on a plane. In practice such a data structure
usually has very good performance for queries over certain ranges of space. This library
implements that basic functionality that allows you to add points with associated data,
lookup the data given the point, and to query for all (point, data) nodes in a particular
square bounded region.

This isn't meant to really be taken too seriously, I am using this as a toy project to
explore some things with Ruby mostly related to the build process and toolchain.

## Installation

Add this line to your application's Gemfile:

    gem 'quad_tree'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install quad_tree

## Usage

Find something to put here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
