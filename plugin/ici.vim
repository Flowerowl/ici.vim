function! s:UsingPython3()
  if has('python3')
    return 1
  endif
  return 0
endfunction


let s:using_python3 = s:UsingPython3()
let s:python_until_eof = s:using_python3 ? "python3 << EOF" : "python << EOF"

function! Ici(word)
  exec s:python_until_eof
import vim
try:
    from urllib.request import urlopen
except ImportError:
    from urllib2 import urlopen
from xml.dom import minidom

WORD = vim.eval("a:word")
KEY = 'E0F0D336AF47D3797C68372A869BDBC5'
URL = 'http://dict-co.iciba.com/api/dictionary.php'


def get_response(word):
    return urlopen(URL + '?key=' + KEY + '&w=' + word)


def read_xml(xml):
    dom = minidom.parse(xml)
    return dom.documentElement


def show(node):
    if not node.hasChildNodes():
        if node.nodeType == node.TEXT_NODE and node.data != '\n':
            tag_name = node.parentNode.tagName
            content = node.data.replace('\n', '')
            if tag_name == 'ps':
                print(content)
                print('---------------------------')
            elif tag_name == 'orig':
                print(content)
            elif tag_name == 'trans':
                print(content)
                print('---------------------------')
            elif tag_name == 'pos':
                print(content)
            elif tag_name == 'acceptation':
                print(content)
                print('---------------------------')
    else:
        for e in node.childNodes:
            show(e)


def main():
    root = read_xml(get_response(WORD))
    show(root)

if __name__ == '__main__':
    main()
EOF
endfunction


function! IciFrom()
let word = expand("<cword>")
call Ici(word)
endfunction


command! -nargs=1 Ici :call Ici(<q-args>)
command! -nargs=0 IciFrom :call IciFrom()
