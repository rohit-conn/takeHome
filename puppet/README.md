# Puppet Setup

- We use the roles/profiles pattern to install nginx andd nodejs
- Details can be found here https://www.puppet.com/docs/puppet/8/the_roles_and_profiles_method.html
- For resuing modules from puppet forge we can add the entry to `Puppetfile` and use the modules
- A custom fact is `aws_role` is created as part of `user-data` to select which role should run on what host