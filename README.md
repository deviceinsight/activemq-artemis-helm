This chart installs [Apache ActiveMQ Artemis](https://activemq.apache.org/components/artemis/)

## Usage

[Helm](https://helm.sh) must be installed and initialized to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add codecentric activemq-artemis https://deviceinsight.github.io/activemq-artemis-helm
```

## Developer Notes

When you prepare a new release, make sure to build the chart using `./mvnw verify` once the release version has been set.
Commit the resulting packaged chart `target/helm/*.tgz`.
