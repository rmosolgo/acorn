require "../src/acorn"

# 🚧 This doesn't work yet. 🚧

class GraphQLLexer < Acorn::Lexer
  token :IDENTIFIER,    "[_A-Za-z][_0-9A-Za-z]*"
  token :NEWLINE,       "[\c\r\n]"
  token :BLANK,         "[, \t]+"
  token :COMMENT,       "# [^\n\r]*"
  token :INT,           "-? ('0'|[1-9][0-9]*)"
  token :FLOAT_DECIMAL, ".[0-9]+;"
  token :FLOAT_EXP,     "(e|E)?(+|-)?[0-9]+"
  # TODO: allow reusing tokens?
  token :FLOAT,         INT FLOAT_DECIMAL? FLOAT_EXP?;
  token :ON,            "on"
  token :FRAGMENT,      "fragment"
  token :TRUE,          "true"
  token :FALSE,         "false"
  token :NULL,          "null"
  token :QUERY,         "query"
  token :MUTATION,      "mutation"
  token :SUBSCRIPTION,  "subscription"
  token :SCHEMA,        "schema"
  token :SCALAR,        "scalar"
  token :TYPE,          "type"
  token :IMPLEMENTS,    "implements"
  token :INTERFACE,     "interface"
  token :UNION,         "union"
  token :ENUM,          "enum"
  token :INPUT,         "input"
  token :DIRECTIVE,     "directive"
  token :LCURLY,        "{"
  token :RCURLY,        "}"
  token :LPAREN,        "("
  token :RPAREN,        ")"
  token :LBRACKET,      "["
  token :RBRACKET,      "]"
  token :COLON,         ":"
  token :QUOTE,         "\""
  token :ESCAPED_QUOTE, "\\\""
  token :STRING_CHAR,   (ESCAPED_QUOTE | ^'"');
  token :VAR_SIGN,      "$"
  token :DIR_SIGN,      "@"
  token :ELLIPSIS,      "..."
  token :EQUALS,        "="
  token :BANG,          "!"
  token :PIPE,          "|"

  token :QUOTED_STRING, QUOTE STRING_CHAR* QUOTE;

  # catch-all for anything else. must be at the bottom for precedence.
  token :UNKNOWN_CHAR,  "."
end
