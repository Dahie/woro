# Woro

Write once, run once.

Manage one-time remote tasks in your Rails project.
Plugins with Mina that adds support for rake tasks hosted as gists.

Say you have a data migration to perform on a remote server. The procedure is too complex to just do it in the remote console. Using database migration is evil. A rake task would be nice, but checking this in with the regular repository adds clutter, as you know you will only run this once.
Woro offers a quick way of pushing rake tasks on the remote server, execute them and delete them instantly. Using Github's gist, you keep version control of the tasks and can share them with colleagues.

Woro helps you create rake task, that you can develop and run locally.
Once you are ready, woro let's you push them online as a gist.
Using a mina deployment setup, you these tasks are downloaded on the remote system, executing using rake and cleaned up afterwards.

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

Require `mina/woro` in your `config/deploy.rb`:

```rb
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/woro'

...

task setup: :environment do
  ...
end

desc 'Deploys the current version to the server.'
task deploy: :environment do
  ...
end
```

Then run:

```shell
$ woro init
```

This will create `lib/woro_tasks/` folder and `lib/tasks/woro.rake`.
Here the Woro task files are stored and edited locally.

## Usage

```shell
$ woro new cleanup_users
```

Can be used to create the template for a new task in `lib/tasks/`.

The task itself is a regular rake-task in the woro-namespace. You can test it locally using rake:

```shell
$ rake woro:cleanup_users
```

Once you are done writing the task and you want to execute it on the remote system.
First you have to push them online.

```shell
$ woro push cleanup_users
```

_Attention, depending on whether you set up a Gist/Github login on
initialization. These tasks are online anonymous, but public, or
private under the specified Github account._


Now, to run a task remotely, specify the task:

```shell
$ mina woro:run task=cleanup_users
```


Or do pushing and running in one step:

```shell
$ mina woro:execute task=cleanup_users
```

To show a list of all uploaded tasks do:

```shell
$ mina woro:list
```

And finally you can download an existing task:

```shell
$ mina woro:pull task=cleanup_users
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
