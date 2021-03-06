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

module.exports.info  = 'Querying ...';

const contractID = 'mycc';
let bc, contx;

module.exports.init = async function(blockchain, context, args) {
    bc = blockchain;
    contx = context;
};

module.exports.run = async function() {
    const args = {
        chaincodeFunction: 'readMarble',
        invokerIdentity: '#Org1',
        chaincodeArguments: ['marble_1_10100']
    };

    return bc.querySmartContract(contx, contractID, '', args, 10);
};

module.exports.end = async function() {};
