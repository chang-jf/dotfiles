#!/bin/bash
# -------------------------------------------------------------------
# generate a strong password instantly(http://blog.colovirt.com/2009/01/07/linux-generating-strong-passwords-using-randomurandom/)
# -------------------------------------------------------------------
export LC_CTYPE=C;
cat /dev/urandom| tr -dc 'a-zA-Z0-9-_!@#$%^&amp;*()_+{}|:&lt;&gt;?='|fold -w 8| head -n 1;
unset LC_CTYPE
