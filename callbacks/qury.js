'use strict';

module.exports.info  = 'Template callback';

const contractID = 'mycc';
const version = '1.0';

let bc, ctx, clientArgs, clientIdx;

module.exports.init = async function(blockchain, context, args) {
    bc = blockchain;
    ctx = context;
    clientArgs = args;
    clientIdx = context.clientIdx.toString();
        try {
            const myArgs = {
                chaincodeFunction: 'query',
                invokerIdentity: '#',
                chaincodeArguments: ['a']
            };
            return bc.bcObj.querySmartContract(ctx, contractID, version, myArgs);
        } catch (error) {
            console.log(`Smart Contract threw with error: ${error}` );
        }
};


module.exports.run = async function() {
    const myArgs = {
        chaincodeFunction: 'query',
        invokerIdentity: 'User1',
        chaincodeArguments: ['a']
    };
    return bc.bcObj.invokeSmartContract(ctx, contractID, version, myArgs);
};

module.exports.end = async function() {
        try {
            const myArgs = {
                chaincodeFunction: 'query',
                invokerIdentity: 'User1',
                chaincodeArguments: ['a']
            };
            return bc.bcObj.querySmartContract(ctx, contractID, version, myArgs);
        } catch (error) {
            console.log(` Smart Contract threw with error: ${error}` );
        }
};
