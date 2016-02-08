# Woro

Write once, run once.

[![Gem Version](https://img.shields.io/gem/v/woro.svg)](https://rubygems.org/gems/woro)
[![Gem Downloads](https://img.shields.io/gem/dt/woro.svg)](https://rubygems.org/gems/woro)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/dahie/woro)

Manage one-time remote tasks in your Rails project.
Plugins with Mina and Capistrano to add support for rake tasks hosted in remote collection, such as FTP, Gist or S3.

Say you have a data migration to perform on a remote server. The procedure is too complex to just do it in the remote console and using database migrations would be evil. A rake task would be nice, but checking this in with the source code repository adds clutter, as you know you will only run this once.
Woro offers a quick way of pushing rake tasks onto the remote server, execute them and delete them instantly.

Woro helps you create rake tasks, that you can develop and run locally.
Once you are ready, woro let's you push them online to a remote storage like FTP or other adapters like Gist or S3.
Using a mina deployment setup, these tasks are downloaded on the remote system, executed by rake and cleaned up afterwards.

### Adapters

By default Woro comes with support for FTP, but additional adapters are available:

* [woro-gist](https://github.com/dahie/woro-gist)
* [woro-s3](https://github.com/dahie/woro-s3)

Add them as dependency to your `Gemfile` and they become available in woro.

## Installation

Add this line to your application's Gemfile:

```rb
gem 'woro', require: false
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install woro
```

Then run:

```shell
$ woro init
```

This creates the `woro.yml` in the `config/` folder. This configuration
stores the settings of the available remote collection adapters, eg the
Gist id.

It also creates the `lib/woro_tasks/` folder and `lib/tasks/woro.rake`.
Here the Woro task files are stored, edited locally and run using rake.

_The idea of the Woro tasks is, that these are a one time thing and are
not required to be checked in with the repository. Therefore,
`lib/woro_tasks/` includes a `.gitignore` file to ignore rake tasks in
this directory._


### for use with Mina

Require `mina/woro` in your `config/deploy.rb`:

```rb
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/woro'

...
```

### for use with Capistrano

Require `capistrano/woro` in your `config/deploy.rb`:

```rb
require 'capistrano/rails'
require 'capistrano/woro'

...
```

## Usage

```shell
$ woro new cleanup_users
$ woro create cleanup_users
```

Can be used to create the template for a new task in `lib/woro_tasks/`.

The task itself is a regular rake-task in the woro-namespace. You can test it locally using rake:

```shell
$ rake woro:cleanup_users
```

Once you are done writing the task and you want to execute it on the remote system.
First you have to push them online, in this case to Gist.

```shell
$ woro push ftp:cleanup_users
```

_Attention, depending on whether you set up a Gist/Github login on
initialization. These tasks are online anonymous, but public, or
private under the specified Github account._

Now, to run a task remotely using Mina, specify the task:

```shell
$ mina woro:run task=ftp:cleanup_users
```

Or to run it with Capistrano:

```shell
$ cap woro:run task=ftp:cleanup_users
```

To show a list of all tasks uploaded to any collection do:

```shell
$ woro list
$ woro ls
```

And finally you can download an existing task to your local woro tasks directory.

```shell
$ woro pull ftp:cleanup_users
```

## Testing

The project classes are tested through rspec.

```shell
$ rspec
```

The command line interface is tested through cucmber/aruba.

```shell
$ cucumber
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
