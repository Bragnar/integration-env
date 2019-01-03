# integration-env
Continuous Integration (CI) environment based on Docker

## Installation

This docker environment has been tested using CoreOS installed on a Virtualbox machine.
The installation procedure can be found [here](https://coreos.com/os/docs/latest/booting-on-virtualbox.html).

## How to work behind a proxy

The procedures listed here can require customization is case they are executed behind a proxy.
Some tips may require to edit the environment, and in some cases event edit procedure scripts to be applied.

### Environment variables

The following environment variables can be set, and will be used by many tools :

* http_proxy
* https_proxy
* HTTP_PROXY
* HTTPS_PROXY

To configure them for a specific user, edit the ```~/.bashrc``` file to add the following lines :

```shell
PROXY_IP=<PROXY_IP_ADDRESS>
PROXY_PORT=<PROXY_PORT>
PROXY_HTTP_URL=http://${PROXY_IP}:${PROXY_PORT}/

export http_proxy=${PROXY_HTTP_URL}
export https_proxy=${PROXY_HTTP_URL}
export HTTP_PROXY=${PROXY_HTTP_URL}
export HTTPS_PROXY=${PROXY_HTTP_URL}
```

### Avoid certificate issues

In some cases, if the proxy requires certificates, the connection to remote servers may fail anyway.

Here are the options to use with some tools to avoid certificates issues :

 * wget : ```--no-check-certificate```
 * curl : ```--insecure```

### Docker daemon behind a proxy

#### Proxy for the ```docker``` daemon

For operation such as pull/push images from registries, the ```docker``` daemon reads the **environment variables** listed above.

To set them in the SystemD environment :

1. Create the ```/etc/systemd/system/docker.service.d/http-proxy.conf``` file, and insert :
```
[Service]
Environment="HTTP_PROXY=http://<PROXY_IP_ADDRESS>:<PROXY_PORT>/"
Environment="HTTPS_PROXY=http://<PROXY_IP_ADDRESS>:<PROXY_PORT>/"
```
2. Reload SystemD configuration:
```shell
$ sudo systemctl daemon-reload
```
3. Restart the ```docker``` service
```shell
$ sudo systemctl restart docker
```

#### Proxy for the docker image build

While building images, the command executed can require connections to remote servers (for example, to install a package from a distrib repository), and the environment variables of the ```docker``` daemon are not visible whithin the building context.

The same environment variables are used by most tools, but they need to be set manually when calling the build command:
```shell
$ docker build --build-arg http_proxy=http://192.168.56.1:3128 --build-arg https_proxy=http://192.168.56.1:3128 <Some Dockerfile location>
