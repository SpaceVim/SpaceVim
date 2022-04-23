exec "silent! source " . "../ftplugin/markdown.vim"

let g:caseCount = 0
let g:passCaseCount = 0
let g:errorCaseCount = 0

function! ASSERT(var)
    let g:caseCount += 1
    if a:var != 0
        let g:passCaseCount += 1
        echo "case " . g:caseCount . " pass"
    else
        let g:errorCaseCount += 1
        echoe "case " . g:caseCount . " error"
    endif
endfunction

" GFM Test Cases {{{
let g:GFMHeadingIds = {}

call ASSERT(GetHeadingLinkTest("# 你好！", "GFM") ==# "你好")
call ASSERT(GetHeadingLinkTest("## Hello World", "GFM") ==# "hello-world")
call ASSERT(GetHeadingLinkTest("### Hello World", "GFM") ==# "hello-world-1")
call ASSERT(GetHeadingLinkTest("#### `Hello World`", "GFM") ==# "hello-world-2")
call ASSERT(GetHeadingLinkTest("##### _Hello_World_", "GFM") ==# "hello_world")
call ASSERT(GetHeadingLinkTest("###### ,", "GFM") ==# "")
call ASSERT(GetHeadingLinkTest("# ,", "GFM") ==# "-1")
call ASSERT(GetHeadingLinkTest("## No additional spaces before / after punctuation in fullwidth form", "GFM") ==# "no-additional-spaces-before--after-punctuation-in-fullwidth-form")
call ASSERT(GetHeadingLinkTest("### No additional spaces before/after punctuation in fullwidth form", "GFM") ==# "no-additional-spaces-beforeafter-punctuation-in-fullwidth-form")
call ASSERT(GetHeadingLinkTest("####   Hello    Markdown    ", "GFM") ==# "hello----markdown")
call ASSERT(GetHeadingLinkTest("####Heading without a space after the hashes", "GFM") ==# "heading-without-a-space-after-the-hashes")
call ASSERT(GetHeadingLinkTest("### heading with trailing hashes ###", "GFM") ==# "heading-with-trailing-hashes")
call ASSERT(GetHeadingLinkTest("### heading with trailing hashes###", "GFM") ==# "heading-with-trailing-hashes-1")
call ASSERT(GetHeadingLinkTest("### heading with trailing hashes ends with spaces ###  ", "GFM") ==# "heading-with-trailing-hashes-ends-with-spaces-")
call ASSERT(GetHeadingLinkTest("### heading with trailing hashes nested with spaces # #  #  ", "GFM") ==# "heading-with-trailing-hashes-nested-with-spaces----")
call ASSERT(GetHeadingLinkTest("### [vim-markdown-toc](https://github.com/mzlogin/vim-markdown-toc)", "GFM") ==# "vim-markdown-toc")
call ASSERT(GetHeadingLinkTest("### [vim-markdown-toc-again][1]", "GFM") ==# "vim-markdown-toc-again")
call ASSERT(GetHeadingLinkTest("### ![vim-markdown-toc-img](/path/to/a/png)", "GFM") ==# "vim-markdown-toc-img")
call ASSERT(GetHeadingLinkTest("### ![](/path/to/a/png)", "GFM") ==# "-2")
call ASSERT(GetHeadingLinkTest("### 1.1", "GFM") ==# "11")
call ASSERT(GetHeadingLinkTest("### heading with some \"special\" \(yes, special\) chars: les caractères unicodes", "GFM") ==# "heading-with-some-special-yes-special-chars-les-caractères-unicodes")
call ASSERT(GetHeadingLinkTest("## 初音ミクV3について", "GFM") ==# "初音ミクv3について")
call ASSERT(GetHeadingLinkTest("# 안녕", "GFM") ==# "안녕")
" }}}

" GitLab Test Cases {{{
let g:GFMHeadingIds = {}

call ASSERT(GetHeadingLinkTest("# 你好！", "GitLab") ==# "你好")
call ASSERT(GetHeadingLinkTest("## Hello World", "GitLab") ==# "hello-world")
call ASSERT(GetHeadingLinkTest("### Hello World", "GitLab") ==# "hello-world-1")
call ASSERT(GetHeadingLinkTest("#### `Hello World`", "GitLab") ==# "hello-world-2")
call ASSERT(GetHeadingLinkTest("##### _Hello_World_", "GitLab") ==# "hello_world")
call ASSERT(GetHeadingLinkTest("###### ,", "GitLab") ==# "")
call ASSERT(GetHeadingLinkTest("# ,", "GitLab") ==# "-1")
call ASSERT(GetHeadingLinkTest("## No additional spaces before / after punctuation in fullwidth form", "GitLab") ==# "no-additional-spaces-before-after-punctuation-in-fullwidth-form")
call ASSERT(GetHeadingLinkTest("### No additional spaces before/after punctuation in fullwidth form", "GitLab") ==# "no-additional-spaces-beforeafter-punctuation-in-fullwidth-form")
call ASSERT(GetHeadingLinkTest("####   Hello    Markdown    ", "GitLab") ==# "hello-markdown")
call ASSERT(GetHeadingLinkTest("####Heading without a space after the hashes", "GitLab") ==# "heading-without-a-space-after-the-hashes")
call ASSERT(GetHeadingLinkTest("### heading with trailing hashes ###", "GitLab") ==# "heading-with-trailing-hashes")
call ASSERT(GetHeadingLinkTest("### heading with trailing hashes###", "GitLab") ==# "heading-with-trailing-hashes-1")
call ASSERT(GetHeadingLinkTest("### heading with trailing hashes ends with spaces ###  ", "GitLab") ==# "heading-with-trailing-hashes-ends-with-spaces-")
call ASSERT(GetHeadingLinkTest("### heading with trailing hashes nested with spaces # #  #  ", "GitLab") ==# "heading-with-trailing-hashes-nested-with-spaces-")
call ASSERT(GetHeadingLinkTest("### [vim-markdown-toc](https://github.com/mzlogin/vim-markdown-toc)", "GitLab") ==# "vim-markdown-toc")
call ASSERT(GetHeadingLinkTest("### [vim-markdown-toc-again][1]", "GitLab") ==# "vim-markdown-toc-again")
call ASSERT(GetHeadingLinkTest("### ![vim-markdown-toc-img](/path/to/a/png)", "GitLab") ==# "vim-markdown-toc-img")
call ASSERT(GetHeadingLinkTest("### ![](/path/to/a/png)", "GitLab") ==# "-2")
call ASSERT(GetHeadingLinkTest("### 1.1", "GitLab") ==# "11")
call ASSERT(GetHeadingLinkTest("### heading with some \"special\" \(yes, special\) chars: les caractères unicodes", "GitLab") ==# "heading-with-some-special-yes-special-chars-les-caractères-unicodes")
call ASSERT(GetHeadingLinkTest("## heading with Cyrillic Б б", "GitLab") ==# "heading-with-cyrillic-б-б")
call ASSERT(GetHeadingLinkTest("## Ю heading starts with Cyrillic", "GitLab") ==# "ю-heading-starts-with-cyrillic")
" }}}

" Redcarpet Test Cases {{{
call ASSERT(GetHeadingLinkTest("# -Hello-World-", "Redcarpet") ==# "hello-world")
call ASSERT(GetHeadingLinkTest("## _Hello_World_", "Redcarpet") ==# "hello_world")
call ASSERT(GetHeadingLinkTest("### (Hello()World)", "Redcarpet") ==# "hello-world")
call ASSERT(GetHeadingLinkTest("#### 让 Discuz! 局域网内可访问", "Redcarpet") ==# "让-discuz-局域网内可访问")
call ASSERT(GetHeadingLinkTest('##### "你好"世界"', "Redcarpet") ==# "quot-你好-quot-世界-quot")
call ASSERT(GetHeadingLinkTest("###### '你好'世界'", "Redcarpet") ==# "39-你好-39-世界-39")
call ASSERT(GetHeadingLinkTest("# &你好&世界&", "Redcarpet") ==# "amp-你好-amp-世界-amp")
call ASSERT(GetHeadingLinkTest("## `-ms-text-autospace` to the rescue?", "Redcarpet") ==# "ms-text-autospace-to-the-rescue")
" }}}

" Marked Test Cases {{{
call ASSERT(GetHeadingLinkTest("# 你好！", "Marked") ==# "你好！")
call ASSERT(GetHeadingLinkTest("## Hello World", "Marked") ==# "hello-world")
call ASSERT(GetHeadingLinkTest("### Hello World", "Marked") ==# "hello-world")
call ASSERT(GetHeadingLinkTest("#### `Hello World`", "Marked") ==# "`hello-world`")
call ASSERT(GetHeadingLinkTest("##### _Hello_World_", "Marked") ==# "_hello_world_")
call ASSERT(GetHeadingLinkTest("###### ,", "Marked") ==# ",")
call ASSERT(GetHeadingLinkTest("# ,", "Marked") ==# ",")
call ASSERT(GetHeadingLinkTest("## No additional spaces before / after punctuation in fullwidth form", "Marked") ==# "no-additional-spaces-before-/-after-punctuation-in-fullwidth-form")
call ASSERT(GetHeadingLinkTest("### No additional spaces before/after punctuation in fullwidth form", "Marked") ==# "no-additional-spaces-before/after-punctuation-in-fullwidth-form")
call ASSERT(GetHeadingLinkTest("####   Hello    Markdown    ", "Marked") ==# "hello-markdown")
call ASSERT(GetHeadingLinkTest("####Heading without a space after the hashes", "Marked") ==# "heading-without-a-space-after-the-hashes")
call ASSERT(GetHeadingLinkTest("### heading with trailing hashes ###", "Marked") ==# "heading-with-trailing-hashes")
call ASSERT(GetHeadingLinkTest("### heading with trailing hashes###", "Marked") ==# "heading-with-trailing-hashes")
call ASSERT(GetHeadingLinkTest("### heading with trailing hashes ends with spaces ###  ", "Marked") ==# "heading-with-trailing-hashes-ends-with-spaces")
call ASSERT(GetHeadingLinkTest("### heading with trailing hashes nested with spaces # #  #  ", "Marked") ==# "heading-with-trailing-hashes-nested-with-spaces-#-#")
call ASSERT(GetHeadingLinkTest("### [vim-markdown-toc](https://github.com/mzlogin/vim-markdown-toc)", "Marked") ==# "[vim-markdown-toc](https://github.com/mzlogin/vim-markdown-toc)")
call ASSERT(GetHeadingLinkTest("### [vim-markdown-toc-again][1]", "Marked") ==# "[vim-markdown-toc-again][1]")
call ASSERT(GetHeadingLinkTest("### ![vim-markdown-toc-img](/path/to/a/png)", "Marked") ==# "![vim-markdown-toc-img](/path/to/a/png)")
call ASSERT(GetHeadingLinkTest("### ![](/path/to/a/png)", "Marked") ==# "![](/path/to/a/png)")
call ASSERT(GetHeadingLinkTest("### 1.1", "Marked") ==# "1.1")
call ASSERT(GetHeadingLinkTest("### heading with some \"special\" \(yes, special\) chars: les caractères unicodes", "Marked") ==# "heading-with-some-\" special\"-\(yes,-special\)-chars:-les-caractères-unicodes")
" }}}

echo "" . g:passCaseCount . " cases pass, " . g:errorCaseCount . " cases error"
