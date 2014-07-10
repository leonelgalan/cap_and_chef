# README

Optional: `vagrant destroy --force`

```
vagrant up
knife solo bootstrap vagrant@localhost --ssh-port 2222 -i ~/.vagrant.d/insecure_private_key
```

**Upload deployer's public key to Github's deploy keys.** Connect to the box using `vagrant ssh -- -l deployer`

```
be cap staging deploy
```
