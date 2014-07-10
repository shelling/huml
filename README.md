# Huml

Huml is to [Haml](github.com/haml/haml) what [Scss](http://sass-lang.com/) is to [Sass](http://sass-lang.com/).
Like the relationship between Sass and Scss, Huml uses braces for nesting structure
when Haml uses indentations.

## Formatting

    doctype 5
    %html {

      %head {
        %script(type="text/javascript" src="app.js")
        %link(href="app.css" rel="stylesheet" type="text/css" media="all")
      }

      %body {
        %div.container {
          %h3.header = "page header"
          %p(style="background-color: #fff;") = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        }
      }

    }

## License

MIT (X11) License 2014 shelling
