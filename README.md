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

3. Run helm install with values.yaml
```bash
helm install -f values.yaml <release-name> dkube-helm/dkube-deployer
```	

##### Install with --set option
we can also use helm --set option to override input paramater values defined in values.yaml during install.
For example, To override platform, dkube username and password, use below command.
Note- (--timeout 1500s is mandatory as dkube install takes around 20 mins approx to complete)
```bash
helm install <release-name> dkube-helm/dkube-deployer
--set provider=eks
--set username=<username>
--set password=<password>
```

##### check status
```bash
helm status <release-name>
```

## Upgrade
To upgrade dkube, please use the below command with the newly available version of dkube.
```bash
helm get values <deployed-release-name> --all  > values-upgrade.yaml
helm upgrade -f values-upgrade.yaml <deployed-release-name> dkube-helm/dkube-deployer --set version=<vew-dkube-version> --timeout 1500s
```

## Uninstallation
To uninstall dkube, please run below command:
```bash
helm uninstall <release-name>
```

## Build chart and release to dkube-helm repo
```bash
Prerequisites- chart releaser(cr) tools (v1.2.1) and helm binary should be installed.

1. If building release with existing version then delete release and tag from github first.
2. git checkout <new-release-branch>
3. Change the chart version on Chart.yaml available in charts/dkube-deployer folder (incremental version based on last release)
3. helm package charts/dkube-deployer --destination .deploy
4. cr upload -o oneconvergence -r dkube-helm -p .deploy --token <github-token>
5. git checkout gh-pages
6. cr index -i ./index.yaml -p .deploy --owner oneconvergence -r dkube-helm -c https://oneconvergence.github.io/dkube-helm
7. git add index.yaml
8. git commit -m "release message"
9. git push origin gh-pages
```
