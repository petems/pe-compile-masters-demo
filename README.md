# pe-compile-masters-demo

A Vagrant environnment for demoing PE Compile Masters, proxied behind a HAProxy loadbalancer.

Run `vagrant_setup.sh`

Or manually:

```
vagrant up master.puppet.vm
vagrant up com0.puppet.vm com1.puppet.vm proxy.puppet.vm
vagrant ssh -c 'sudo puppet cert --allow-dns-alt-names sign proxy.puppet.vm com0.puppet.vm com1.puppet.vm' master.puppet.vm
vagrant ssh -c 'sudo puppet agent -t' com0.puppet.vm
vagrant ssh -c 'sudo puppet agent -t' com1.puppet.vm
vagrant ssh -c 'sudo puppet agent -t' proxy.puppet.vm
vagrant ssh -c 'sudo puppet agent -t' master.puppet.vm
vagrant up node.puppet.vm
vagrant ssh -c 'sudo puppet agent -t' com0.puppet.vm
vagrant ssh -c 'sudo puppet agent -t' com1.puppet.vm
vagrant ssh -c 'sudo puppet agent -t' proxy.puppet.vm
vagrant ssh -c 'sudo puppet agent -t' master.puppet.vm
vagrant ssh -c 'sudo puppet cert sign node.puppet.vm' master.puppet.vm
vagrant ssh -c 'sudo puppet agent -t' node.puppet.vm
```

## Explanation

* `master.puppet.vm` - The Master of Masters. The compile masters get their configuration from here, and code from here is file-synced to the compile masters
* `com[0-9].puppet.vm` - Compile masters. These compile catalogs from Puppet code synced from the MoM
* `proxy.puppet.vm` - HA Proxy instance, with all the `com[0-9].puppet.vm` instances as members.
* `node.puppet.vm` - Node, that checks in to `proxy.puppet.vm` for checkin