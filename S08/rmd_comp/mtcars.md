# Demo: Markdown file

This is a plain **Markdown** file.
It is all human words, with formatting
syntax, and it is never executed.

Code can be shown in a fenced block, but it is only displayed, not run:

```r
mtcars
avg_mpg <- aggregate(mpg ~ cyl, data = mtcars, FUN = mean)
avg_mpg
```

The output below was pasted in by hand,
so it needs manual update if the code changes:

```
  cyl      mpg
1   4 26.66364
2   6 19.74286
3   8 15.10000
```

Cars with more cylinders get *worse* fuel economy.
