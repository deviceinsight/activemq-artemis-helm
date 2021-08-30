This chart installs [Apache ActiveMQ Artemis](https://activemq.apache.org/components/artemis/)

## Docker image
This chart no longer uses [vromero/activemq-artemis](https://github.com/vromero/activemq-artemis-docker) docker image. 
Please fork [vromero/activemq-artemis](https://github.com/vromero/activemq-artemis-docker) repository and create your own image in order to use this helm chart.

## Usage

[Helm](https://helm.sh) must be installed and initialized to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add activemq-artemis https://deviceinsight.github.io/activemq-artemis-helm
```

## Developer Notes
When you prepare a new release, make sure to build the chart using ./mvnw verify once the release version has been set. Copy the resulting packaged chart target/helm/*.tgz to charts.

### Releasing
1) ./mvnw gitflow:release-start
2) ./mvnw package
3) Adapt `CHANGELOG.md`
4) cp target/helm/*.tgz charts  
5) git add . && git commit
6) ./mvnw gitflow:release-finish