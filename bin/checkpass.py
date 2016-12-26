#!/usr/bin/env python2
import os
import io
import sys
import subprocess
import ConfigParser

def checkpass(account):
    path = os.environ.get('HOME','/home/cagprado') + '/.passwd/' + account + '.gpg'
    try:
        passwd = subprocess.check_output(['gpg','-d','--quiet','--batch',
                                          '--no-tty','--for-your-eyes-only',
                                          '--pinentry-mode','cancel',path],
                                          stderr = open(os.devnull,'w')).strip()
    except subprocess.CalledProcessError:
        passwd = 'nopasswd'
    except ConfigParser.NoOptionError:
        passwd = 'nopasswd'
    return passwd

if len(sys.argv) == 2 and 'offlineimap' not in sys.argv[0]:
    print(checkpass(sys.argv[1]))
