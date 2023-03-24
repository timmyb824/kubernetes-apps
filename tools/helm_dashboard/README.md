# Summary

[Helm Dashboard](https://github.com/komodorio/helm-dashboard) - Provides a simplified way of working with Helm

# Installing

```shell
#Install
helm plugin install https://github.com/komodorio/helm-dashboard.git

helm plugin update dashboard

# Uninstall
helm plugin uninstall dashboard
```

# Running

```shell
helm dashboard
``

Additional command line options

```shell
# see available options
--help

# use port other than 8080
--port <number>

# don't open browser tab automatically
--no-browser

# increase loggin
--verbose
```
