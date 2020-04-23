dispose () {
      npx caliper launch master --caliper-workspace ${WORK_SPACE} --caliper-flow-only-end
}
function runLocal() {
  export CALIPER_PROJECTCONFIG=../../caliper.yaml

  export WORK_SPACE='workspace/test'

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
      --caliper-flow-only-test \
#      --caliper-benchconfig benchconfig.yaml \
#      --caliper-networkconfig networkconfig.yaml \
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
}

function startMaster() {
    docker rm -f master
    docker-compose -p caliper down -v
    docker-compose -p caliper up -d
    docker-compose -f master.yaml up
}

function startWorker() {
    if [[ -z ${WORKER_NUMBER} ]];then
      echo "WORKER_NUMBER must be specific"
      exit 0
    fi
     for ((INDEX=1; INDEX<=${WORKER_NUMBER}; INDEX++))
    do
      	docker rm -f worker${INDEX}
    done
    docker-compose -f monitor.yaml down -v
    docker-compose -f monitor.yaml up -d
    for ((INDEX=1; INDEX<=${WORKER_NUMBER}; INDEX++))
    do
      	sed "s/%WORKER_NAME%/worker${INDEX}/g" worker.yaml > worker${INDEX}.yaml
      	docker-compose -f worker${INDEX}.yaml up -d
    done
}
## Parse mode
if [[ $# -lt 1 ]] ; then
  printHelp
  exit 0
else
  MODE=$1
  shift
fi
while getopts "h?n:" opt; do
    case "$opt" in
        h|\?)
            printHelp
            exit 0
            ;;
        n)  WORKER_NUMBER=$OPTARG
            ;;
    esac
done
echo "WORKER_NUMBER ${WORKER_NUMBER}"
if [ "$MODE" == "master" ]; then
    echo "launch master..."
    startMaster
elif [ "$MODE" == "worker" ]; then
    echo "launch worker..."
    startWorker
else
    echo "run local..."
    runLocal
fi
