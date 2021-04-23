#!/bin/bash


for chart in `ls charts`;
do
# Sometimes it's necessary to insert non-default values to successfully pass a kube-score
if [[ -f charts/$chart/ci/ci-values.yaml ]]; then
helm template --values charts/$chart/ci/ci-values.yaml charts/$chart | kube-score score - \
    --ignore-test pod-networkpolicy \
    --ignore-test deployment-has-poddisruptionbudget \
    --ignore-test deployment-has-host-podantiaffinity \
    --ignore-test pod-probes \
    --ignore-test container-image-tag \
    --enable-optional-test container-security-context-privileged \
    --ignore-test container-security-context
else
helm template charts/$chart | kube-score score - \
    --ignore-test pod-networkpolicy \
    --ignore-test deployment-has-poddisruptionbudget \
    --ignore-test deployment-has-host-podantiaffinity \
    --ignore-test pod-probes \
    --ignore-test container-image-tag \
    --enable-optional-test container-security-context-privileged \
    --ignore-test container-security-context
fi
done