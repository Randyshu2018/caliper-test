export CALIPER_PROJECTCONFIG=../../caliper.yaml

export WORK_SPACE='workspace/local'

dispose () {
    npx caliper launch master --caliper-workspace ${WORK_SPACE} --caliper-flow-only-end
}

# PHASE 1: just starting the network
npx caliper launch master --caliper-workspace ${WORK_SPACE} --caliper-flow-only-start

rc=$?
if [[ ${rc} != 0 ]]; then
    echo "Failed CI step 1";
    dispose;
    exit ${rc};
fi

# PHASE 2 again: testing through the gateway API
npx caliper launch master \
    --caliper-bind-sut fabric:1.4.3 \
    --caliper-workspace ${WORK_SPACE} \
    --caliper-benchconfig benchconfig.yaml \
    --caliper-networkconfig networkconfig.yaml \
    --caliper-flow-only-test \
    --caliper-fabric-usegateway \
    --caliper-fabric-discovery \
#    --unsafe-perm=true \
#    --allow-root

# PHASE 3: just disposing of the network
npx caliper launch master --caliper-workspace ${WORK_SPACE} --caliper-flow-only-end
rc=$?
if [[ ${rc} != 0 ]]; then
    echo "Failed CI step 7";
    exit ${rc};
fi

rc=$?
if [[ ${rc} != 0 ]]; then
    echo "Failed CI";
    exit ${rc};
fi
