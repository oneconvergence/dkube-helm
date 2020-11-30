# dkube-helm
Repository to host dkube helm charts

## Installation
##### Add dkube-helm repo
```bash
helm repo add dkube-helm https://oneconvergence.github.io/dkube-helm
```
##### Install with values.yaml
1. Download values.yaml locally
```bash
helm show values dkube-helm/dkube-deployer > values.yaml
```
2. Update with required details. Please follow the link below for detailed instructions about configuration parameters.
https://dkube.io/unlinked/install2_1/Install-Getting-Started.html

3. Run helm install with values.yaml(Note- --timeout 1500s is mandatory as dkube install takes around 20 mins approx to complete)
```bash
helm install -f values.yaml <release-name> dkube-helm/dkube-deployer --timeout 1500s
```	

##### Install with --set option
we can also use helm --set option to override input paramater values defined in values.yaml during install.
For example, To override platform, dkube username and password, use below command.
Note- (--timeout 1500s is mandatory as dkube install takes around 20 mins approx to complete)
```bash
helm install <release-name> dkube-helm/dkube-deployer
--set dkube.required.kubeProvider=eks
--set dkube.required.username=<username>
--set dkube.required.password=<password>
--timeout 1500s
```

##### check status
```bash
helm status <release-name>
```

## Upgrade
To upgrade dkube, please use the below command with the newly available version of dkube.
```bash
helm upgrade <release-name> dkube-helm/dkube-deployer --set 
dkube.optional.dkubeVersion=<new-dkube-version>
```

## Uninstallation
To uninstall dkube, please run below command:
```bash
helm uninstall <release-name>
```
