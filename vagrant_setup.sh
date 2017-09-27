#!/bin/bash

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