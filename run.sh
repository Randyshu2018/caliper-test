export CALIPER_PROJECTCONFIG=./caliper.yaml

# testing through the gateway API
npx caliper launch master \
    --caliper-bind-sut fabric:1.4.3 \
    --caliper-workspace . \
    --caliper-benchconfig benchconfig.yaml \
    --caliper-networkconfig networkconfig.yaml \
    --caliper-flow-only-test \
    --caliper-fabric-usegateway \
    --caliper-fabric-discovery
rc=$?
if [[ ${rc} != 0 ]]; then
    echo "Failed CI";
    exit ${rc};
fi
