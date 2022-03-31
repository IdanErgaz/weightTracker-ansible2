# WeightTracker Deployment Using Ansible

---
			
		
## Instructions

 - Install ansible on ubuntu 16.04
 - Create ssh key and copy to remote machine
 - Configure remote machine to enable ansible to run it.


### Main files:

---
webapp-deploy2.yml :

~~~
This is the playbook which includes all the commands and packages that need to 
be run on all remote nodes
~~~
hosts.txt :

~~~
This file contains the groups and ips target

~~~

---
## Commands for Final Deployment:
~~~
ansible-playbook -i ./hosts.txt webapp-Deploy2.yml --extra-vars "group=production"

ansible-playbook -i ./hosts.txt webapp-Deploy2.yml --extra-vars "group=staging"
~~~

---
## prerequisites (ON MASTER/CONTROLLER)

~~~
- SSH to the loadbalancer fornted ip -> get from Terraform run output.
- ssh from loadbalancer  to the controller machine. (you can find the ip under resource group-> controllerVM)
- run git clone https://github.com/IdanErgaz/weightTracker-ansible2.git
- Run cd weightTracker-ansible2/
- Run chmod +x weightTrackerDepoly.sh
- Deploy all prerequisites using the attached script (weightTrackerDepoly.sh) The script will deploy ansible + python3
- run the script by typing ./weightTrackerDepoly.sh and type "yes" for all.

~~~

## Generate ssh key and copy to remote nodes:
## Do it from the Master node to each node (Slave)
```
$ ssh-keygen
press enter for filename
Overwrite - y
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

## Copy the public key to all connected nodes (The nodes ip can be found under: resource group> vmss_lb>settings>Backend pool)
~~~
$ ssh-copy-id -i (username)@(node machine ip) - For example - ssh-copy-id -i userName@34.76.142.118
Type the node password
When promped whether to continue connecting press yes
~~~

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

## Repeat the copy key and flag check for ALL nodes!

# Exit to be on the controller machine (user ctrl D )> Edit the hosts file (On Master)


---
## Update hosts file in editor
```
sudo vi ~/weightTracker-ansible2/hosts.txt
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
## Save entry and exit to terminal
```
press esc
press :wq
```


## Update the ansVar.yml file 
```
***Please notice - the ansVar.yml file  will be sent  to you via discord.***

$ sudo vi ~/weightTracker-ansible2/ansVar.yml
Press i
Copy the lines from the file you have recieved via Discord.

Update the LB_front_ip -> you can take it from the TERRAFORM output.
Update the 'group' variable value which you want to deploy
Update the POSTGRESQL details (basicly need to switch between staging/production)
press esc
press :wq
```

## Ensure valid connection between control machine and managed node machine
```
Go into weightTracker-ansible2 directory
cd ~/weightTracker-ansible2
Run the command:
$ ansible -m ping all -i ./hosts.txt
``` 

The result should be as : 

(node machine ip) | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

---
## Playbook Deployment: Deploy the playbook on all group remote nodes
~~~
Go into weightTracker-ansible2 directory
cd ~/weightTracker-ansible2

For production group:
ansible-playbook -i ./hosts.txt webapp-Deploy2.yml --extra-vars "group=production"
~~~
rootAdmin@Controller-Server:~/weightTracker-ansible2$ ansible-playbook webapp-Deploy2.yml -i ./hosts.txt
~~~
For staging group:
Run:
ansible-playbook -i ./hosts.txt webapp-deploy2.yml --extra-vars "group=staging"
~~~
## Update the OKKTA with the current load balancer front ip (get it from the Terraform run OUTPUT)
```
login to okta> navigate to Applications > select you webApp> Under General Settings> scroll down 
Update the ip under: 'Sign-in redirect URIs' and 'Sign-out redirect URIs'.
```
## Use weight-tracker app via browser
~~~Open browser and type: <fronend lb ip>:8080
for example:20.232.148.224:8080
Have fun :)~~~
