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

#### Hoe to test the image

List the different parameters available to your container

```shell
kubectl run spark-test-pod --generator=run-pod/v1 -it --rm=true \
  --image=spoonshot/spark-k8s-base \
  --serviceaccount=spark \
  --command -- /bin/bash
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