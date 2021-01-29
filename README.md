# ISAYT - Indent S-expressions As You Type

Minor mode for automatic indentation of S-expressions.
Similar to [aggressive-indent-mode][1] except works only for languages in which `indent-sexp` function works.

Install this package either by using something like [straight.el][2] or manually putting `isayt.el` to your load path.
Then `require` the package and add appropriate hooks:

``` emacs-lisp
(require 'isayt)

(add-hook 'emacs-lisp-mode-hook #'isayt-mode)
```

[1]: https://github.com/Malabarba/aggressive-indent-mode
[2]: https://github.com/raxod502/straight.el
