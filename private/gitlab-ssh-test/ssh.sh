2. Debug the SSH Key


Ensure the SSH Key Is Correct:

Double-check the DEPLOY_KEY variable in your CI/CD settings.

Ensure that the private key is correctly added to the DEPLOY_KEY variable and matches the public key added as the Deploy Key in GitLab.



Test the SSH Key Locally:

On your local machine, add the private key to your SSH agent:
ssh-add /path/to/id_rsa


Test the SSH connection to the repository:
ssh -T git@gitlab.neurolearninglabs.com


If successful, you should see a message like:
Welcome to GitLab, @username!