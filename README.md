# Huml

Huml is to [Haml](github.com/haml/haml) what [Scss](http://sass-lang.com/) is to [Sass](http://sass-lang.com/).
Like the relationship between Sass and Scss, Huml uses braces for nesting structure
when Haml uses indentations.

## Basic Usage

Huml can be used from the command line or as part of a Ruby web framework. The first step is to install the gem:

    gem install huml

After writing some Huml, you can run

    huml document.huml

to compile it to HTML.

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

          - for item in %w(hello world) do
            %div = "interpolate #{item} here"
          - end

          "plain text is eligible"
        }
      }

    }

## License

MIT (X11) License 2014 shelling
