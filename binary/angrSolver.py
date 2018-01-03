#!/usr/bin/env python2

import angr
import claripy
import string

''' CONFIG '''
TARGET = 'a.out'

''' DATA FROM REVERSE ENGINEERING '''
MAX_BUF_LEN = 8 

# Function to "start" execution at
START_FUNC = "main"
#START_STATIC = 0xffffffff 

# Functions you want to reach
FIND_FUNC = ['winner']
#FIND_STATIC = [0xffffffff]

# Functions you want to avoid
AVOID_FUNC = ['loser']
#AVOID_STATIC = [0xffffffff]

''' If we have symbols... '''
def getFuncAddress(funcName, cfg, plt=None):
    found = [
        addr for addr,func in cfg.kb.functions.iteritems()
        if funcName == func.name and (plt is None or func.is_plt == plt)
        ]
    if len( found ) > 0:
        print "Found "+funcName+"'s address at "+hex(found[0])+"!"
        return found[0]
    else:
        raise Exception("No address found for function : "+funcName)

def funcToAddr(funcList, cfg):
    addrList = []
    for func in funcList:
        addr = getFuncAddress(func, cfg)
        if addr:
            addrList.append(addr)
    return addrList


'''returns constraints s.t. c is printable'''
def char(state, c):
    return state.solver.And(c <= '~', c >= ' ')

def main():
    ''' Create project '''
    p = angr.Project(TARGET, auto_load_libs=False)    #faster

    ''' Get function addresses '''
    # w/ symbols
    cfg = p.analyses.CFG(fail_fast=True)    # Get project symbols if possible
    FIND = funcToAddr(FIND_FUNC, cfg)
    AVOID = funcToAddr(AVOID_FUNC, cfg)
    START = getFuncAddress(START_FUNC, cfg)
    # w/o symbols
    #FIND = FIND_STATIC
    #AVOID = AVOID_STATIC
    #START = START_STATIC


    ''' Setup state  '''
    state = p.factory.blank_state(addr=START)

    ''' Setup constraints '''
    for i in range(MAX_BUF_LEN):
        c = state.posix.files[0].read_from(1)
        state.solver.add(char(state, c))

    #Allow angr to shorten buffer
    state.posix.files[0].seek(0)
    state.posix.files[0].length = 100

    ''' Setup Explorer '''
    ex = p.surveyors.Explorer(start=state, find=tuple(FIND), avoid=tuple(AVOID))
    ex.run()
    if ex.found:
        buf = ex._f.posix.dumps(0)
        #import IPython; IPython.embed()
        return "SOLUTION: %s" % (buf[:buf.index('\x00')])

if __name__ == '__main__':
    print main()

