# ============================================================================
# Copied shougo's stock sorter and modified for shortlex
# ============================================================================
# FILE: sorter_word.py
# AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
# License: MIT license
# ============================================================================

from pynvim import Nvim

from deoplete.base.filter import Base
from deoplete.util import UserContext, Candidates
import functools


def shortlex(x, y):
    if len(x['word']) < len(y['word']):
        return -1
    elif len(y['word']) < len(x['word']):
        return 1
    elif x['word'].swapcase() < y['word'].swapcase():
        return -1
    elif x['word'].swapcase() > y['word'].swapcase():
        return 1
    else:
        return 0

class Filter(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'sorter_shortlex'
        self.description = 'word sorter by shortlex'

    def filter(self, context: UserContext) -> Candidates:
        return sorted(context['candidates'],
            key=functools.cmp_to_key(shortlex))
        #return sorted(context['candidates'],
        #              key=lambda x: str(x['word'].swapcase()))

