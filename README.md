shinyCodeMirror
===============

Interactive Shiny via direct R programming


Visualization software offering has vastly improved over recent years. On the one hand, you have the easy to use but not 
very expressive variety such as Excel and Tableau. On the other hand, there are advanced ones that offering much more 
flexibilities like D3 or Illustrator. What about something in between? One such example is Lyra, which exposes many of 
features in Vega thus D3 on a user interface. It also has some data manipulation capabilities that allow you define
data mutation and relationships.


However the drawbacks are clear that one has to keep up with the development of D3 or any underlying visualization framework. 
It is also not clear how other developers can contribute because it's rather difficult to integrate modifications when it
comes to user interface.
For example, R has this vast amount of packages on CRAN and Github. There are numerous way to produce beautiful looking
static reports or plots using these packages. Not to mention the statistical and machine learning model they can build.
Meanwhile, Shiny lets R programmer to present their works in a interactive way. 
However, once a Shiny app is written the interaction you can perform is rather limited.


Some most commonly asked questions when you present charts include: Can I add a (non)-linear regression line? How about plotting
difference between two variables instead? What if we look at log scales? Most of these can be easily done in one-line R code but 
can be cumbersome for developer to implement ahead of time. It's especially disappointing when audience raise a brilliant point
but you can't pursue the conversation because you can't easily carry the needed data analysis.

Here we present a low cost solution where we use Code Mirror to expose a code editor that allows you modify the Shiny
app on the fly. It also has limited code completion that eases your nervousness during a presentation. We hope this
extra layer of flexibility could lead into further interaction between user and data, which could enhance the conversation
a presenter can have with its audience.
