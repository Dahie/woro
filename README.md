# Woro

Write once, run once.

Manage one-time remote tasks in your rails project.
Plugins with Mina that adds support for rake tasks hosted as gists.


## Installation & Usage

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
require 'mina/woro'
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

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
$ bundle exec mina woro:init
```

This will create `lib/woro_tasks/` folder.
Here the Woro task files are stored and edited locally.

Once you are done and want to execute them on the remote system, you have to push them online.

```shell
$ mina woro:push task=20150112_cleanup
```

Attention, depending on whether you set up a Gist/Github login on
initialiazation. These tasks are online anonymous, but public, or
private under the specified Github account.


To run a task remotely, specify the task:

```shell
$ mina woro:run task=20150112_cleanup
```


## Configuration

* `tasks` - array of stages names, the default is the name of all `*.rb` files from `tasks_dir`
* `tasks_dir` - stages files directory, the default is `lib/woro_tasks`




## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
