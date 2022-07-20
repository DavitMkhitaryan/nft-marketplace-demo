const {assert} = require('chai');

const KryptoBird = artifacts.require('./Kryptobird');

//check for chai
require('chai').use(require('chai-as-promised')).should();

contract('KryptoBird', (accounts) => {
    let contract;

    before( async () => {
        contract = await KryptoBird.deployed();;
    })

    describe('Contract Deployment', async () => {
        it('Deploys Successfully', async () => {
            const address = contract.address;

            assert.notEqual(address, '');
            assert.notEqual(address, null);
            assert.notEqual(address, undefined);
            assert.notEqual(address, 0x0);
        })

        it('Verify Name', async () => {
            const contractName = await contract.name();
            assert.equal(contractName, 'Kryptobird');
        });

        it('Verify Symbol', async () => {
            const contractSymbol = await contract.symbol();
            assert.equal(contractSymbol, 'KBIRDZ');
        })
    })

    describe('Minting', async () => {
        it ('Create a New Token', async () => {
            const result = await contract.mint('https...1');
            const totalSupply = await contract.totalSupply();

            // Success
            assert.equal(totalSupply, 1);

            const event = result.logs[0].args;
            assert.equal(event._from, '0x0000000000000000000000000000000000000000', 'from is the contract');
            assert.equal(event._to, accounts[0], 'to is msg.sender');

            // Failure
            await contract.mint('https...1').should.be.rejected;
        })
    })

    describe('Indexing', async () => {
        it('Lists KryptoBirdz', async () => {
            // Mint three new tokens
            await contract.mint('https...2');
            await contract.mint('https...3');
            await contract.mint('https...4');
            const totalSupply = await contract.totalSupply();

            let result = [];
            let expected = ['https...1', 'https...2', 'https...3', 'https...4'];
            let KryptoBird;
            for (let i = 1; i <= totalSupply; i++) {
                KryptoBird = await contract.kryptoBirdz(i - 1);
                result.push(KryptoBird);
            }

            assert.equal(result.join(','), expected.join(','));

            
        })
    })

})