# Intro
Script to easily update shell prompt on CentOS 6/7 servers.

# What prompt-updater.sh does
1. Creates or updates /etc/profile.d/custom-prompt.sh
1. Updates /root/.bashrc
1. After running the script, all users will be able to see easily what server one's working on.

# Recommended usage
Every Linux server one accesses via SSH should be easily identifiable. Is it production? Dev? Or QA? And making this change on the servers should be simple. Hence this script.

Run prompt-updater.sh on each server you manage. 

# Usage with Configuration Management tools
If you manage a large number of servers, you probably should use Configuration Management tools like Ansible to update /etc/profile.d/custom-prompt.sh and /root/.bashrc directly, without promptly for any manual input.
