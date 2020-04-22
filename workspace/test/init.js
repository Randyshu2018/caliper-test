/*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

'use strict';



module.exports.info  = 'Creating car.';
let bc, contx;
let txIndex = 0;

module.exports.init = async function(blockchain, context, args) {
    bc = blockchain;
    contx = context;
};

module.exports.run = async function() {
    txIndex++;
    let targetPeers = txIndex % 5;
    switch (targetPeers) {
        case 0:
            targetPeers = ['peer0.org1.example.com'];
            break;
        case 1:
            targetPeers = ['peer1.org1.example.com'];
            break;
        case 2:
            targetPeers = ['peer0.org2.example.com'];
            break;
        case 3:
            targetPeers = ['peer1.org2.example.com'];
            break;
        case 4:
            targetPeers = ['peer0.org2.example.com'];
            break;
        default:
            throw new Error('Unknown txIndex:'+targetPeers);
    }

    let args = {
        chaincodeFunction: 'CreateCar',
        chaincodeArguments: ['CAR11','Cherry','BMW','Black','Randy'],
        targetPeers:targetPeers
    };


    // let targetCC = txIndex % 2 === 0 ? 'fabcar1' : 'fabcar2';
    return bc.invokeSmartContract(contx, 'fabcar', '1', args, 120);
};

module.exports.end = async function() {};
