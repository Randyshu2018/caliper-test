function runLocal() {
  export CALIPER_PROJECTCONFIG=../../caliper.yaml

  export WORK_SPACE='workspace/test'

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
      --caliper-flow-only-test
  #    --caliper-benchconfig benchconfig.yaml \
  #    --caliper-networkconfig networkconfig.yaml \
  #    --caliper-fabric-usegateway \
  #    --caliper-fabric-discovery \
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
}

function runDocker() {
    docker-compose -p caliper down -v
    docker rm -f caliper
    docker-compose -p caliper up -d
    docker-compose -f run.yaml up
}
DOCKER=true
while getopts "h?dsb" opt; do
    case "$opt" in
        h|\?)
            printHelp
            exit 0
            ;;
        d)  DOCKER=false
            ;;
    esac
done
echo "docker ${DOCKER}"
if [ "$DOCKER" == "true" ]; then
    echo "start with docker..."
    runDocker
else
    runLocal
fi
