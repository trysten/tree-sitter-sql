PREC =
    COMMA: -1
    CLAUSE: 1
# rough sketch for an SQL grammar
module.exports = grammar
    name: 'SQL'
    conflicts: ($) => [
    ]
    # word: ($) => $._identifier
    rules:
        source_file: ($) => repeat $.statement
        statement: ($) => seq repeat1($.clause), ';'

        # give clause a higher priority 
        clause: ($) => seq prec.dynamic(1, $.clause_keyword),
                           $._expressions

        clause_keyword: ($) => prec.dynamic PREC.CLAUSE,
            choice "WHERE", "SELECT", "FROM", "UPDATE", "SET"

        # column name or table.name
        column_identifier: ($) => choice $._identifier,
                                         seq($.table, '.', $._identifier )

        # give the choice between a single expression or the beginning of a sequence
        _expressions: ($) => choice $._expression, $.sequence_expression

        _expression: ($) => choice(
          $.column_identifier,
          $.asterisk,
          $.string,
          $.number
        )

        sequence_expression: ($) => prec PREC.COMMA,
            seq $._expression, $.delim,
                choice $._expression, $.sequence_expression

        delim: ($) => ','
        table: ($) => $._identifier

        number: ($) => /\d+\.*\d*/
        string: ($) => choice /"\w+"/, /'\w+'/
        _identifier: ($) =>
            alpha = /[a-zA-Z_]+/
            alphanum = /[\w_]+/
            token seq alpha, repeat(alphanum)

        asterisk: ($) => '*'
