PREC =
    COMMA: -1

module.exports = grammar
    name: 'SQL'
    rules:
        source_file: ($) => repeat $.statement
        statement: ($) => seq repeat1($.clause), ';'

        clause: ($) => prec 10, seq $.clause_keyword, $.expressions
        clause_keyword: ($) => choice "WHERE", "SELECT", "FROM", "UPDATE", "SET"

        column_selection: ($) =>
            prec.left PREC.COMMA,
                seq $.column_identifier,
                    repeat $.delim, $.column_identifier

        column_identifier: ($) => choice /\w+/, seq($.table, '.', /\w+/ )
        expressions: ($) => choice $.expression, $.sequence_expression

        expression: ($) => choice(
          $.column_identifier,
          $.asterisk,
          $.string,
          $.function,
          $.number
        )
        sequence_expression: ($) => prec PREC.COMMA,
            seq $.expression, $.delim, choice $.expression, $.sequence_expression

        function: ($) => seq /\w+\(/, $.expression, ')'
        #primary_clause_keyword: ($) => choice "SELECT", 'UPDATE'
        number: ($) => /\d+.*\d*/
        table: ($) => /\w+/
        string: ($) => choice /"\w+"/, /'\w+'/
        delim: ($) => choice ','
        word: ($) =>
            alpha = /[\w_]+/
            alphanum = /[\w\d_]+/
            seq alpha, repeat(alphanum)

        asterisk: ($) => '*'
