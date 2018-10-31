# Bundler-MultiGem

The utility to install multiple versions of the same ruby gem

## Usage

### Setup

Assuming that you have already installed CPAN:
`curl -L http://cpanmin.us | sudo perl - --sudo App::cpanminus`

```bash
$ git clone git@github.com:mberlanda/Bundler-MultiGem.git
$ perl Build.PL
$ sudo ./Build installdeps
$ sudo ./Build install
```

Or download it from CPAN
```bash
$ cpan -i Bundler::MultiGem
```

This will make available the command `bundle-multigem`

### Usage

#### Help

```bash
$ bundle-multigem -h
bundle-multigem <command> [-?h] [long options...]
    -? -h --help  show help

Available commands:

    commands: list the application's commands
        help: display a command's help screen

  initialize: Generate a configuration file (alias: init bootstrap b)
       setup: Create multiple gem versions out of a configuration file (alias: install i s)
```

#### Initialize

```bash
$ bundle-multigem init  -h
bundle-multigem [-f] [long options...] <path>

    --gm --gem-main-module    provide the gem main module (default:
                              constantize --gem-name)
    --gn --gem-name           provide the gem name
    --gs --gem-source         provide the gem source (default:
                              https://rubygems.org)
    --gv --gem-versions       provide the gem versions to install (e.g:
                              --gem-versions 0.0.1 --gem-versions 0.0.2)
    --dp --dir-pkg            directory for downloaded gem pkg (default:
                              pkg)
    --dt --dir-target         directory for extracted versions (default:
                              versions)
    --cp --cache-pkg          keep cache of pkg directory (default: 1)
    --ct --cache-target       keep cache of target directory (default: 0)
    -f --conf-file            choose config file name (default:
                              .bundle-multigem.yml)
```

Minimal Example:
```
bundle-multigem initialize --gn jsonschema_serializer --gv 0.5.0 --gv 0.1.0 .
```

This will generate a `.bundle-multigem.yml` (see [example](.bundle-multigem.yml)).

#### Setup

```bash
$ bundle-multigem setup  -h
bundle-multigem [-f] [long options...] <path>

    -f --file     provide the yaml configuration file (default:
                  ./.bundle-multigem.yml)

```

Sample Output:

```bash
$ bundle-multigem setup
Unpacked gem: '/Users/mberlanda/Misc/Bundler-MultiGem/versions/v005-jsonschema_serializer'
v005-jsonschema_serializer completed!
Unpacked gem: '/Users/mberlanda/Misc/Bundler-MultiGem/versions/v010-jsonschema_serializer'
v010-jsonschema_serializer completed!
Process completed.

You can add to your Gemfile something like:
gem 'v005-jsonschema_serializer', path: 'versions/v005-jsonschema_serializer'
gem 'v010-jsonschema_serializer', path: 'versions/v010-jsonschema_serializer'
```

I can now edit my `Gemfile` to include

```rb
  gem 'v005-jsonschema_serializer', path: 'versions/v005-jsonschema_serializer'
  gem 'v010-jsonschema_serializer', path: 'versions/v010-jsonschema_serializer'
```

And benchmark both implementations with the version namespace:

```rb
require 'benchmark/ips'

benchmark_options = { time: 10, warmup: 5 }

Benchmark.ips do |x|
  x.config(benchmark_options)

  x.report 'same_method v005 implementation' do
    V005::JsonschemaSerializer.same_method()
  end
  x.report 'same_method v010 implementation' do
    V010::JsonschemaSerializer.same_method()
  end
  x.compare!
end
```

This can be very useful to track regressions in the CI.
