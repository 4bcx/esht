# esht - Embeddable SHell Tags

## Description
This is still way under development and verification, but the main idea here is to be able to write a plain text document with shell code enclosed between `$[` and `]`. And then be able to compile it into a working shell script that prints everything verbatim using `printf` and the code between the tags gets executed in the same subshell.

There are similar examples that but not quite the same like [bash-tbl](https://github.com/TekWizely/bash-tpl), [spp](https://github.com/radare/spp), [sempl](https://github.com/nextrevision/sempl), and another snippet I can't find right now.

## Usage & example
**esht** requires one or more filenames as arguments, the first will be considered the source file. If a second filename is provided it will be considered as the output file and will be created, or overwritted if it already exists. If no output file specified, **esht** will print to the standard output.

Given a file `source.html.esht` with the following content:
```html
$[ # define a user function
   table_element() {
       echo "<td bgcolor=\"$1\">$1</td>"
    }
   ]
<html>
	<body>
<table border=1><tr>
$[ for a in Red Blue Yellow Cyan; do ]
        $[ table_element $a ]
        $[ done ]
</tr></table>
</body>
</html>
```

Running `./esht source.html.esht output.sh` will generate the file `output.sh` with the following code:
```sh
# define a user function
   table_element() {
       echo "<td bgcolor=\"$1\">$1</td>"
    }

printf '\n<html>\n\t<body>\n<table border=1><tr>\n'
for a in Red Blue Yellow Cyan; do
printf '\n        '
table_element $a
printf '\n        '
done
printf '\n</tr></table>\n</body>\n</html>\n'

```

Which in turn can be sourced by running `. output.sh` to get the html output:
```html

<html>
	<body>
<table border=1><tr>

        <td bgcolor="Red">Red</td>

        
        <td bgcolor="Blue">Blue</td>

        
        <td bgcolor="Yellow">Yellow</td>

        
        <td bgcolor="Cyan">Cyan</td>

        
</tr></table>
</body>
</html>

```

The same result from above can can also be produced by using `-x` option.

## TODO
- [x] Detect and remove unnecessary leading and trailing white spaces
- [x] Refactor and organize the existing code
- [x] Use trap to indicate incomplete output
- [x] Add `-x` option to automatically execute the generated script
- [ ] Add `-u` option to automatically update **esht**
- [ ] Write more test inputs to detect edge cases
- [ ] Write proper documentation

## Credits
- [CHANGELOG](./CHANGELOG.md) format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
- This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
- And I try my best to follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
- [.gitignore](./.gitignore) was generated using [gitignore.io](https://www.toptal.com/developers/gitignore)

## License
This project is licensed under [The Unlicense](./LICENSE)
