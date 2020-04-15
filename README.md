## 使用Hyperledger Caliper对Hyperledger fabric进行性能测试

#### 安装Caliper
```
npm init -y && \
npm install --only=prod @hyperledger/caliper-cli@0.3.0 &&\
npx caliper bind --caliper-bind-sut fabric:1.4.3
```

#### 下载Binaries
```
./bootstrap.sh -s false -d false -b true
```

#### 启动测试网络
```
cd examples/test-network
./network.sh up
./network.sh createChannel
./network.sh deployCC
cd ../../
```

#### 开始测试
```
./run.sh
```

#### Grafana Dashboard
* hyperledger fabric (10716)
