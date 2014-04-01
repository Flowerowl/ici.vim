function! Ici(word)

python << endpython

import vim

import sys
import urllib2
import getopt
from xml.dom import minidom

WORD= vim.eval("a:word")
KEY = 'E0F0D336AF47D3797C68372A869BDBC5'
URL = 'http://dict-co.iciba.com/api/dictionary.php'

def get_response(word):
    return urllib2.urlopen(URL + '?key=' + KEY + '&w=' + word)

def read_xml(xml):
    dom = minidom.parse(xml)
    return dom.documentElement

def show(node):
    if not node.hasChildNodes():
        if node.nodeType == node.TEXT_NODE and node.data != '\n':
            tag_name = node.parentNode.tagName
            content = node.data.replace('\n', '')
            if tag_name == 'ps':
                print content
                print '---------------------------'
            if tag_name == 'orig':
                print content
            if tag_name == 'trans':
                print content
                print '---------------------------'
            if tag_name == 'pos':
                print content
            if tag_name == 'acceptation':
                print content
                print '---------------------------'
    else:
        for e in node.childNodes:
            show(e)

def main():
    root = read_xml(get_response(WORD))
    show(root)

if __name__ == '__main__':
    main()

endpython

endfunction

command! -nargs=1 Ici :call Ici(<q-args>)
