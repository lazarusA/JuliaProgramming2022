# REPL

Now we are in the Julia REPL ( Read Eval Parse Loop)

The REPL has different modes
Normal Mode

We have the normal mode where we are going to do all of the computations and all programming

1 + 1

f(x) = 2 * x

f(2)

f(4)
## Navigation

    Ctrl+D, to quit (also written as ^D
    Ctrl+C will interrupt/cancel ongoing actions
    Ctrl+L will clear your entire screen (I spam this so much - I love it.)
    Alt+Enter will let you type in a newline without evaluating the REPL result.
    Uparrow and downarrow to move around the REPL History
    Ctrl-R/Ctrl-F (Reverse/Forward) Fuzzy search

Show Tab Completion

show how to input α

## Help Mode

type ? to enter help mode

? +

? range

Explain extended help

?? range

Use apropos to search in the docstrings or use ? “searchterm”

Other ways to get help when you are stuck is to go to the julia discourse, this has more information than stack overflow

https://discourse.julialang.org/

or ask at the helpdesk either in the julia slack or the julia zulip

https://julialang.org/slack/

https://julialang.zulipchat.com/register/


## Code exploration

To better understand what is going on in your code you can use `@edit` and `@which`

And use  <Num> and then Ctrl+q to get to the latest error 

## Pkg Mode

Manage your Julia packages frrom within Julia

Access the Pkg Mode with ]

st

add BenchmarkTools

Pkg handles also Environments similar to virtualenv in python

Difference between global environment and local environments

Global environment should be used for Development centered packages like

- Revise
- OhMyREPL
- PkgTemplates
- BenchmarkTools

You can activate a temporary environment with
```julia
activate --temp
```
you can activate your local environment with
```julia
activate .
```
Use instantiate to download all packages in an environment:

instantiate

Let us test this now with the environments which we are going to use during our course this week

use

```
git clone https://github.com/lazarusA/JuliaProgramming2022.git
```

to download the notebooks and environments for this week.
Then go to the `Visualization/map_projections` folder and type

```julia
activate .
instantiate
```
to install all necessary packages. 
This is very useful to have reproducible environments, you just need the Manifest.toml file and you get all of the same package versions as before. 

Use remove to uninstall packages from an environment

Use ? inside the package mode to get help to the different commands
## Shell Mode

Access the Shell Mode which is a fake shell with ;

Mostly useful for navigating

## More resources

REPL Mastery Workshop:
    https://github.com/miguelraz/REPLMasteryWorkshop
    https://www.youtube.com/watch?v=bHLXEUt5KLc

