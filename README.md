# WeightTracker Deployment Using Ansible

---
			
			
commands:
ansible-playbook -i hosts webapp-deploy.yml

```
# Instructions

 - Install ansible on ubuntu 16.04
 - Create ssh key and copy to remote machine
 - Configure remote machine to enable ansible to run it.

---
## prerequisites (ON MASTER/CONTROLLER)
```
1.SSH to the loadbalancer fornted ip -> get from run output.
2.ssh from loadbalancer  to the controller machine.
3.run git clone https://github.com/IdanErgaz/weightTracker-ansible.git
4. Run cd weightTracker-ansible
5. Run chmod +x  weightTracker-ansible.sh
4.Deploy all prerequisites using the attached script (weightTrackerDepoly.sh) The script will deploy ansible + python3

- run the script and type "yes" for all.

```

## Generate ssh key and copy to remote nodes
# Do it from the Master node to each node (Slave)
```
$ ssh-keygen
press enter for filename
Overwrite - Y
press enter twice with passphrase empty

Validate that key was created:
rootAdmin@Controller-Server:~$ ls -la /home/rootAdmin/.ssh/
total 16
drwx------ 2 rootAdmin rootAdmin 4096 Mar 30 20:12 .
drwxr-xr-x 7 rootAdmin rootAdmin 4096 Mar 30 20:11 ..
-rw------- 1 rootAdmin rootAdmin    0 Mar 30 19:33 authorized_keys
-rw------- 1 rootAdmin rootAdmin 2622 Mar 30 20:12 id_rsa
-rw-r--r-- 1 rootAdmin rootAdmin  581 Mar 30 20:12 id_rsa.pub


```
```
copy the public key to all connected nodes (you can see it from the terraform
$ ssh-copy-id -i (username)@(node machine ip) - For example - ssh-copy-id -i userName@34.76.142.118
When promped whether to continue connecting press yes
```

## Configure remote machines (Slaves) to enable ansible to run commands on it.
```
$ ssh (username)@(node machine ip)

```

## Change the file value for pubkeyAuthentication to "yes"
```
$ sudo vim /etc/ssh/sshd_config
press i
```

## Search for the pubkeyAuthentication attribute and change its value from no to yes - If it is already set to "yes" you can exit the editor with pressing esc and then press :q
```
#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

PubkeyAuthentication no

# Expect .ssh/authorized_keys2 to be disregarded by default in future.
#AuthorizedKeysFile     .ssh/authorized_keys .ssh/authorized_keys2

#AuthorizedPrincipalsFile none'
```

  
## Save changes
```
Press esc
press :wq
```

## Restart the ssh service and exit to control machine - if the value is correct already - skip.
```
$ sudo service ssh restart
$ sudo systemctl reload sshd

```

## Exit node machine
```
$ exit

```

# Repeat the copy key and flag check for ALL nodes!

# Exit to be on the controller > Edit the hosts file (On Master)



### Update hosts file in editor
```
sudo vi ~/weightTracker-ansible/hosts.txt
type i (for insert)
Update the ip according to the vmss instances ips.
as following:
[production]
<ip1>
<ip2>

[staging]
<ip1>
<ip2>
```
### Save entry and exit to terminal
```
press esc
press :wq
```


### Update the ansVar.yml file 
```
$ sudo vi ~/weightTracker-ansible/ansVar.yml
press i
***Please notice - the ansVar.yml file  will be sent  to you via discord.***
update the LB_front_ip -> you can take it from the TERRAFORM output.
press esc
press :wq
```

## Ensure valid connection between control machine and managed node machine
```
$ ansible -m ping all
``` 

The result should be as : 

(node machine ip) | SUCCESS => {
    "changed": false,
    "ping": "pong"
}



