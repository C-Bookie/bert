import sys


from erlport.erlterms import Atom
from erlport.erlang import set_message_handler, cast

def register_handler(dest):
    def handler(message):
        cast(dest, message)
    set_message_handler(handler)
    return Atom("ok")

def moo():
    return "ah"

if __name__ == '__main__':
    moo();

