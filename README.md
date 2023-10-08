# shapeshift

shapeshift allows you to quickly align text to a character in neovim.

![shapeshift demo](/demo/demo.gif)

## Usage

select the text, press `:`, and type `Shape` to align it.

```vim
:'<,'>Shape [sign] [spacing]
```

shapeshift provides 1 new command, `Shape`. it has 2 *optional* arguments: `sign` and `spacing`.

`sign` expects the character you want to align to (default is `=`).

`spacing` expects a number representing an additional amount of spaces that should be inserted.
