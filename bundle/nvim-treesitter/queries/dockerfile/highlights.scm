[
  "FROM"
  "AS"
  "RUN"
  "CMD"
  "LABEL"
  "EXPOSE"
  "ENV"
  "ADD"
  "COPY"
  "ENTRYPOINT"
  "VOLUME"
  "USER"
  "WORKDIR"
  "ARG"
  "ONBUILD"
  "STOPSIGNAL"
  "HEALTHCHECK"
  "SHELL"
  "MAINTAINER"
  "CROSS_BUILD"
] @keyword

[
  ":"
  "@"
] @operator

(comment) @comment @spell

(image_spec
  (image_tag
    ":" @punctuation.special)
  (image_digest
    "@" @punctuation.special))

(double_quoted_string) @string

(expansion
  [
    "$"
    "{"
    "}"
  ] @punctuation.special
)

((variable) @constant
  (#lua-match? @constant "^[A-Z][A-Z_0-9]*$"))

(arg_instruction
  . (unquoted_string) @property)

(env_instruction
  (env_pair . (unquoted_string) @property))

(expose_instruction
  (expose_port) @number)

((stopsignal_instruction) @number
  (#match? @number "[0-9][0-9]?$"))

((stopsignal_instruction) @constant.builtin
  (#match? @constant.builtin "SIG(ABRT|HUP|INT|KILL|QUIT|STOP|TERM|TSTP)$"))
