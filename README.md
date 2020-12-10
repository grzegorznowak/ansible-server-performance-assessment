# Ansible Server Performance Assessment (role)
Make a sense of your machine/container/droplet/linode performance with ansible.

When ran on a fresh host, it will give you a sense of what the baseline performance is and does it meet your goals.

Note the project is in it's very early days, and it's only solving immediate requirements as met by the ops team going forward.
Will be happy to expand onto more systems and cases with your help.

### The catalyst

The catalyst for this project was somewhat random behaviour of our cloud machines. Let me keep the detail of who the provider is, by encoding their name to **completelly** unrelatated and cryptic codename: "the Sharky".

the Sharky is good at spinning up new cloud machines, let's call those *krill*. The krill's performance isn't stated clearly anywhere in the Sharky's documentation other than it has __shared cpus__. Specifically nowhere does it tell you how much of IOPS you can expect from disks or RAM or what's the memory throughput, or what the underlying hypervisors cpu family is; and chances are you will be given a machine that is in the lower spectrum of performance. 

Sharky doesn't really care about creating equal krill, it only cares about creating A LOT of it, and on account of that it would sqeeze as many of krill as possible onto single hypervisor, until it's impossible to stuff any more, and at which point performance degradation users see is just blatant.

As a user however all you care about, and all you assume, is that whatever you pay for (hourly) comes with the same spec and capabilities everytime you spin it. Understandably this is crucial for your application/business, and officially there's no information you should be expecting anything but that from Sharky (except for officially stated and documented volatility in shared-cpu space when specific type of *shared krill* is used - but that's only cpu they do mention)

### Use Case

The role was created to allow 2 way checks. 

1. First you want to run it in front of any actual provisioning to make sure your baseline is in check with your assumptions, and maybe just scrap your krill and recreate if it's way out of the whack.
2. Then you want this to get ran on schedule or get triggered by specific events (like when you see drop in app response times provided by other tools), to see if the actual issues you are facing aren't related to your infrastructure under-performing. At least before you start blaming developers of pushing unoptimized codes. Or well you can probably do the latter anyway, as we strongly belive in "release early, optimize when harrased" meta-game.


### Low level premise


The plan is to have a set of provisioning-blocking assertions over machine's performance capabilities, using little to none additional software.
As such the final result might be somewhat more of a heuristic than an actual ay/nay answer, but it *should* be perfectly suitable as a test canary.


### Testing

```shell script
./bootstrap_testing.sh
source testing_env/bin/activate
read -s PASS && ANSIBLE_BECOME_PASS=$PASS molecule verify -s lxd
```

it will go silent so that you may provide your sudo pass. Do it, hit enter and it will carry on

### Usage

#### when cloned from git rep

augment your `playbook.yml` with this role, and adjust parameters to whatever the acceptable performance is

```yaml
- name: Verify
  hosts: all
  become: true

  # there isn't much to verify with this role, as it's forged to verify stuff only and not change any state
  # but let's see if we can make it pass/error out with some extreme values

  roles:
    - role: ansible-server-performance-assessment
      spa_disk_write_run_time_assertion: [adjust to taste]
      spa_disk_read_run_time_assertion: [adjust to taste]
```
      





