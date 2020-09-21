# spark-k8s-base
A Spark docker image build for kubernetes

## Getting Started

These instructions will cover usage information and for the docker container 

### Prerequisities


In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

You also need a working Kubernetes cluster or minikube

### Usage

#### How to test the image


First create a ServiceAccount with enough permission

```shell
kubectl apply -f spark.yaml -n default
```
Once you have a the serviceAccount setup now you can test the setup using 
following command

```shell
kubectl run spark-test-pod --generator=run-pod/v1 -it rm=true   \
--image=spoonshot/spark-k8s-base:v2.4.6   \
--serviceaccount=spark -n pipelines   \
--command -- /opt/spark/bin/spark-submit \
--name sparkpi-test  \
--master k8s://https://kubernetes.default:443  \
--deploy-mode cluster  \
 --class org.apache.spark.examples.SparkPi  \
--conf spark.kubernetes.driver.pod.name=spark-test-$RANDOM \
--conf spark.kubernetes.authenticate.subdmission.caCertFile=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt  \
--conf spark.kubernetes.authenticate.submission.oauthTokenFile=/var/run/secrets/kubernetes.io/serviceaccount/token  \
--conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
--conf spark.kubernetes.namespace=pipelines  --conf spark.executor.instances=2 \
  --conf spark.kubernetes.container.image=spoonshot/spark-k8s-base:v2.4.6 \
--conf spark.jars.ivy=/tmp/.ivy \
local:///opt/spark/examples/jars/spark-examples_2.11-2.4.6.jar 1000
```

## Find Us

* [GitHub](https://github.com/spoonshotx/spark-k8s-base)

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

Version are used as if they are direct mapping for the version of spark

## Authors

* **Appunni M**

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

* Some of the code has been adapted from [Spark on Kubernetes: First Steps](https://oak-tree.tech/blog/spark-kubernetes-primer)