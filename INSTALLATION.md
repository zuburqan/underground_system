# Underground System

This is a guide to run this project with its dependencies.

## Requirement

All you need is [asdf](https://github.com/asdf-vm/asdf) to install the correct version of elixir and
erlang. This project already has a .tools-version file which will be used by asdf.

Elxir comes with a command line tool called mix.

Once you have done this install project dependencies by running
`mix deps.get`

## Running tests

Run `mix test` in project root and it will run all the tests

Run `mix test file_name_with_relative_dir` and it will run that test file

## Using custom files as command line input to the project

Run `mix run -e 'Orchestrator.print_run("fixture_2.txt")'`
