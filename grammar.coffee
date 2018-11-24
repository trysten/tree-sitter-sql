module.exports = grammar
    name: 'SQL'
    conflicts: ($) => [
        [$.column, $.delim]
    ]
    word: ($) => $._identifier
    rules:
        # Let's process a single select statement
        statement: ($) => seq $.select, $.columns, $.from, $.table, ';'
        # assume there is one column
        columns: ($) => seq $.column,
            repeat seq $.delim, $.column

        # below simplified for example
        select: ($) => 'SELECT'
        column: ($) => $._identifier
        from: ($) => 'FROM'
        table: ($) => $._identifier

        delim: ($) => ','

        _identifier: ($) =>
            alpha = /[a-zA-Z_]+/
            alphanum = /[\w_]+/
            token seq alpha, repeat(alphanum)

