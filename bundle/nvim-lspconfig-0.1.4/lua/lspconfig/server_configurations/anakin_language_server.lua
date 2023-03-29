local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'anakinls' },
    filetypes = { 'python' },
    root_dir = function(fname)
      local root_files = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
      }
      return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
    settings = {
      anakinls = {
        pyflakes_errors = {
          -- Full list: https://github.com/PyCQA/pyflakes/blob/master/pyflakes/messages.py

          'ImportStarNotPermitted',

          'UndefinedExport',
          'UndefinedLocal',
          'UndefinedName',

          'DuplicateArgument',
          'MultiValueRepeatedKeyLiteral',
          'MultiValueRepeatedKeyVariable',

          'FutureFeatureNotDefined',
          'LateFutureImport',

          'ReturnOutsideFunction',
          'YieldOutsideFunction',
          'ContinueOutsideLoop',
          'BreakOutsideLoop',

          'TwoStarredExpressions',
          'TooManyExpressionsInStarredAssignment',

          'ForwardAnnotationSyntaxError',
          'RaiseNotImplemented',

          'StringDotFormatExtraPositionalArguments',
          'StringDotFormatExtraNamedArguments',
          'StringDotFormatMissingArgument',
          'StringDotFormatMixingAutomatic',
          'StringDotFormatInvalidFormat',

          'PercentFormatInvalidFormat',
          'PercentFormatMixedPositionalAndNamed',
          'PercentFormatUnsupportedFormat',
          'PercentFormatPositionalCountMismatch',
          'PercentFormatExtraNamedArguments',
          'PercentFormatMissingArgument',
          'PercentFormatExpectedMapping',
          'PercentFormatExpectedSequence',
          'PercentFormatStarRequiresSequence',
        },
      },
    },
  },
  docs = {
    description = [[
https://pypi.org/project/anakin-language-server/

`anakin-language-server` is yet another Jedi Python language server.

Available options:

* Initialization: https://github.com/muffinmad/anakin-language-server#initialization-option
* Configuration: https://github.com/muffinmad/anakin-language-server#configuration-options
    ]],
  },
}
