#!/usr/bin/python
#
# Previous discussion:
# * RFC: replacing "packages"  2007-10-24
#   http://thread.gmane.org/gmane.linux.gentoo.portage.devel/2575
# * [RFC] Reducing the size of the system package set  2008-01-07
#   http://thread.gmane.org/gmane.linux.gentoo.devel/54035
# * Re: remove system set?  2012-08-15
#   http://thread.gmane.org/gmane.linux.gentoo.devel/79186/focus=79412
# * System packages in (R)DEPEND?  2008-10-12
#   http://thread.gmane.org/gmane.linux.gentoo.devel/58488

import portage
from portage._sets import load_default_config

eroot = portage.settings['EROOT']
trees = portage.db[eroot]
vartree = trees['vartree']
settings = vartree.settings
settings._init_dirs()
setconfig = load_default_config(settings, trees)
sets = setconfig.getSets()
system = sets['system']
with open('/etc/portage/make.profile/packages', 'w') as f:
    for atom in system.getAtoms():
        f.write('-*{0}\n'.format(atom))
