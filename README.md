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
* follow standard gitflow release
* remove `-SNAPSHOT` from the chart version in charts/artemis/Chart.yaml
* adapt `CHANGELOG.md`
* bump up chart version (with `-SNAPSHOT`) for next development cycle
* after pushing  the master, chart will be automatically pushed to github pages
