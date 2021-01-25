Time-stamp: <2014/11/24 20:15:23 EST by Oleg SHALAEV http://chalaev.com >

All versions should work, but the quality improves with the growing version number.

Even open source programs are mostly black boxes because in reality most people never check the code.
iceweasel (or firefox) is an example of extremely large black box;
(No wonder that the authors of firefox have releazed an entire firefox-based OS!)

This huge black box wants to know about my system too much; it tries to read the files it should not (including files containing email passwords).
Because of these suspicious activities, 
So iceweasel is the first in my list of "programs which must be controlled by apparmor".

Note that the usr.lib.iceweasel.iceweasel profile relies also on usr.lib.iceweasel.plugin-container profile -- use these two profiles together.

PS 2015-08-07: Approximately two years after I've noticed that iceweasel/firefox reads /etc/passwd and used apparmor to stop it,
an explot message appeared
https://blog.mozilla.org/security/2015/08/06/firefox-exploit-found-in-the-wild/
saying that some Russian news web site was reading user information and sending the data to a Ukranian web site.
I can not believe that this exploit was not used before by other numerous web sites...
