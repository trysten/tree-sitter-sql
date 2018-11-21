PREC =
    COMMA: -1
    CLAUSE: 1

module.exports = grammar
    name: 'SQL'
    word: ($) => $.identifier
    rules:
        source_file: ($) => repeat $.statement
        statement: ($) => seq repeat1($.clause), ';'

        clause: ($) => seq $.clause_keyword, $._expressions
        clause_keyword: ($) => prec PREC.CLAUSE,
            choice "WHERE", "SELECT", "FROM", "UPDATE", "SET"

        column_selection: ($) =>
            #prec PREC.COMMA,
                seq $.column_identifier,
                    repeat $.delim, $.column_identifier

        column_identifier: ($) => choice /\w+/, seq($.table, '.', /\w+/ )
        _expressions: ($) => choice $._expression, $.sequence_expression

        _expression: ($) => choice(
          $.column_identifier,
          $.asterisk,
          $.string,
          $.function,
          $.number
        )

        sequence_expression: ($) => prec PREC.COMMA,
            seq $._expression, $.delim, choice $._expression, $.sequence_expression

        function: ($) => seq /\w+\(/, $._expression, ')'
        #primary_clause_keyword: ($) => choice "SELECT", 'UPDATE'
        number: ($) => /\d+.*\d*/
        table: ($) => /\w+/
        string: ($) => choice /"\w+"/, /'\w+'/
        delim: ($) => ','
        identifier: ($) =>
            alpha = /[\w_]+/
            alphanum = /[\w\d_]+/
            token seq alpha, repeat(alphanum)

        asterisk: ($) => '*'
