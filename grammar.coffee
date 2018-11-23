PREC =
    COMMA: 0
    CLAUSE: 0

module.exports = grammar
    name: 'SQL'
    conflicts: ($) => [
    ]
    word: ($) => $._identifier
    rules:
        statement: ($) => seq $.select, $.columns, $.from, $.table, ';'
        columns: ($) => seq $.column, optional choice seq(',', $.column), $.columns
        column: ($) => choice 'title', 'author'
        select: ($) => 'SELECT'
        from: ($) => 'FROM'
        table: ($) => 'books'

        identifier: ($) =>
            alpha = /[a-zA-Z_]+/
            alphanum = /[\w_]+/
            token seq alpha, repeat(alphanum)

