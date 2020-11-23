This chart installs [Apache ActiveMQ Artemis](https://activemq.apache.org/components/artemis/)

## Usage

[Helm](https://helm.sh) must be installed and initialized to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add activemq-artemis https://deviceinsight.github.io/activemq-artemis-helm
```

## Developer Notes

When you prepare a new release, make sure to build the chart using `./mvnw verify` once the release version has been set.
Commit the resulting packaged chart `target/helm/*.tgz`.

### Releasing
1) ./mvnw gitflow:release-start
2) ./mvnw verify
3) Adapat `CHANGELOG.md`
3) git add . && git commit
4) ./mvnw gitflow:release-finish