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

### Releasing
1) ./mvnw gitflow:release-start
2) ./mvnw package
3) Adapt `CHANGELOG.md`
4) git add . && git commit
5) ./mvnw gitflow:release-finish