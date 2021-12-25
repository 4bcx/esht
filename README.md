# esht - Embeddable SHell Tags

This is still way under development and verification, but the main idea here is to be able to write a plain text document with shell code enclosed between `$[` and `]`. And then be able to compile it into a working shell script that prints everything verbatim using `printf` and the code between the tags gets executed in the same subshell.

There are similar examples that but not quite the same like [bash-tbl](https://github.com/TekWizely/bash-tpl), [spp](https://github.com/radare/spp), [sempl](https://github.com/nextrevision/sempl), and another snippet I can't find right now.

## Example

Executing `. esht.sh` in the project directory produces the following output

```sh
printf '
'
 # define a user function
   table_element() {
       echo "<td bgcolor=\"$1\">$1</td>"
    }
   
printf '
<html>
<body>
<table border=1><tr>
'
 for a in Red Blue Yellow Cyan; do 
printf '
        '
 table_element $a 
printf '
        '
 done 
printf '
</tr></table>
</body>
</html>
'
```

## TODO

- [x] Detect and remove unnecessary leading and trailing white spaces
- [ ] Refactor and organize the existing code
- [ ] Write more test inputs to detect edge cases
- [ ] Write documentation
