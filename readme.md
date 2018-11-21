## tree-sitter-sql ##

An attempt to create a usable SQL grammar for [tree-sitter](https://github.com/tree-sitter/tree-sitter)

Right now I can't figure out how to process an extra comma as in:

    SELECT Title, FROM Books;
                ^

### build/run ###

1. clone the repository

    ```
    git clone https://github.com/trysten/tree-sitter-sql.git
    ```

1. install node_modules and build the parser

    ```
    npm -i 
    npm run build
    ```

1. try it on the test.sql file

    ```
    ./node_modules/.bin/tree-sitter parse test.sql
    ```
