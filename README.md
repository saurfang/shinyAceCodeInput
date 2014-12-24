shinyAceCodeInput
===============

**Attention** All functionalities in this package have been fully merged into [shinyAce](https://github.com/trestletech/shinyAce). Please use that instead and this package has been deprecated.

-------------

Interactive Shiny via direct R programming

## Introduction

A Shiny input widget that wraps the [Ace Code Editor](http://ace.c9.io/). It behaves similarly to a 
regular `textInput` but is suited for R code.

You can install the latest development version from github with
```R
#install.packages("devtools")
devtools::install_github("saurfang/shinyAceCodeInput")
```

## Feature

- Syntax highlighting
- Auto resize according to content
- Auto completion via
 1. Standard R code completion
 2. A static/reactive list user supplies. This can be especially useful for non-standard evaluation
 like functions in [dplyr](https://github.com/hadley/dplyr) and [ggvis](https://github.com/rstudio/ggvis).

To create an input control:
```R
aceCodeInput("codeInput", "Code Input", "1+1")
```
To enable code autocompletion:
```R
aceCodeCompletion("codeInput", colnames(mtcars))
```
This will push column names of `mtcars` to code completion candidates, which can be very useful
if your code input is used to perform data manipulation using `dplyr` for example. You can also
omit the second argument then only standard R code completion will be used.

## Warning

The example Shiny app evaluates the code by using `eval` and `parse`, which can be very dangerous as any
malicious commands can be executed via `system` and other R functions such as file operations. I performed
some quick tests in ShinyApps.io and believe they wrap each App in a virtual instance. Please use caution
if you are sharing this app yourself.

## Motivation

Visualization software offering has vastly improved over recent years. On the one hand, you have the easy to use but not 
very expressive variety such as Excel and Tableau. On the other hand, there are advanced ones that offer much more 
flexibility like D3 or Illustrator. What about something in between? One such example is [Lyra](https://github.com/uwdata/lyra), which exposes many of 
features in Vega thus D3 on a user interface. It also has some data manipulation capabilities that allow you define
data mutation and relationships.


However the drawbacks are clear that one has to keep up with the development of D3 or any underlying visualization framework. 
It is also not clear how other developers can contribute because it's rather difficult to integrate modifications when it
comes to user interface.

R has this vast amount of packages on CRAN and Github. There are numerous way to produce beautiful looking
static reports or plots using these packages. Not to mention the statistical and machine learning model they can build.
Meanwhile Shiny lets R programmer to present their works in a interactive way. 
However once a Shiny app is written the further interaction you can perform is rather limited comparing
to an R console. Of course they are years ahead than a static PDF or PowerPoint presentation.


Some most commonly asked questions when you present charts include: 
Can I add a (non)-linear regression line? 
How about plotting difference between two variables instead? 
What if we look at log scales? 
Most of these can be easily done in one-line R code but can be cumbersome for developer to implement ahead of time. 
It's especially disappointing when audience raise a brilliant point
but you can't pursue the conversation because you can't easily carry the needed data analysis on the spot.

Here we present a low cost solution where we use Ace to expose a code editor that allows you modify the Shiny
app on the fly. It also has limited code completion that eases your nervousness during a presentation. I hope this
extra layer of flexibility could lead into further interaction between user and data, which would help you
engage a more stimulating conversation with your audience.
