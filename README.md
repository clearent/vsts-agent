# vsts-agent
A VSTS build agent with kerberos support for integrated AD security.

## Obtaining the image
Pull the image from dockerhub
<pre>docker pull clearent/vsts-agent:latest</pre>

OR build it yourself
<pre>git clone https://github.com/clearent/vsts-agent.git
cd vsts-agent
docker build -t vsts-agent .</pre>

This image is built upon `microsoft/vsts-agent:ubuntu-16.04-tfs-2017-u1-docker-17.06.0-ce-standard`.  Alter the Dockerfile to rebuild upon other Microsoft provided images.

## Running the image
<pre>
docker run \
  -e VSTS_ACCOUNT=<name> \
  -e VSTS_TOKEN=<pat> \
  -e VSTS_AGENT='$(hostname)-agent' \
  -e VSTS_POOL=mypool \
  -e KRB5_CLIENT_KTNAME=/keys/my.keytab \
  -e KRB5_CONFIG=/keys/krb5.conf \
  -v /path/to/keys:/keys \
  -it clearent/vsts-agent:latest</pre>
  
In the above, the /keys volume contains the pre-configured kerberos keytab and configuration file.
See https://github.com/Microsoft/vsts-agent-docker for a description of the VSTS variable options.
  
