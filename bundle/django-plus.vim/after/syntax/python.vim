if !exists('b:is_django')
  finish
endif

syntax match djangoQueryObject #\.objects\.#hs=s+1,he=e-1 containedin=TOP,pythonString,pythonComment
syntax match djangoModelsModule #\<models\.#he=e-1 containedin=TOP,pythonString,pythonComment
syntax match djangoModelField #\k\+Field\># containedin=TOP,pythonString,pythonComment
syntax keyword djangoModelField ForeignKey containedin=TOP,pythonString,pythonComment
syntax match djangoSettingsObject "\<settings\."he=e-1 containedin=TOP,pythonString,pythonComment

highlight default link djangoQueryObject Special
highlight default link djangoModelsModule Special
highlight default link djangoModelField Type
highlight default link djangoSettingsObject Special
