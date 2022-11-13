import React, { Component } from "react";
// import Web3 from "web3";
import { ethers } from "ethers";
import KryptoBird from "../abis/KryptoBird.json";

class App extends Component {

    async componentDidMount() {
        // await this.loadWeb3();
        // await this.loadBlockchainData();
        await this.loadWeb3ProviderAndBlockchainData();
    }

    async loadWeb3ProviderAndBlockchainData() {
        // Loads MetaMask as the provider
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();

        // Check if provider loaded
        if (provider) {
            console.log("Ethereum wallet is connected");
        } else {
            console.log("No Ethereum wallet detected")
        }

        // Get accounts and networkId
        const accounts = await provider.send('eth_accounts', []);
        const networkId = await provider.send('net_version', []);

        // Update State with info
        this.setState({
            account: accounts,
            networkId: networkId
        });

        console.log(this.state.account);
        console.log(this.state.networkId);
        // Loads Contract information from the Blockchain
        const networkData = KryptoBird.networks[networkId];
        console.log(networkData);

        if (networkData) {

            const contractAbi = KryptoBird.abi;
            const contractAddress = networkData.address;

            // Ethers use a segregated approach to reading / writing to Contracts
            // To read from, use contractRead
            // To write to (like to Mint, etc, use contractSign

            const contractRead = new ethers.Contract(contractAddress, contractAbi, provider);
            const contractSign = new ethers.Contract(contractAddress, contractAbi, signer);

            this.setState({
                contractRead: contractRead,
                contractSign: contractSign
            });

            console.log(this.state.contractRead);
            console.log(this.state.contractSign);

            let totalSupply = await this.state.contractRead.totalSupply();
            totalSupply = ethers.utils.formatUnits(totalSupply, 0);

            this.setState({
                totalSupply: totalSupply
            });

            console.log(this.state.totalSupply);

            for (let i = 1; i <= totalSupply; i++) {
                const KryptoBird = await this.state.contractRead.kryptoBirdz(i - 1);
                this.setState({
                    kryptoBirdz: [...this.state.kryptoBirdz, KryptoBird]
                });
            }
        } else {
            window.alert('Smart Contract is not Deployed')
        }
    }

    mint = async (kryptoBird) => {
        try {
            const txResponse = await this.state.contractSign.mint(kryptoBird);
            const txReceipt = await txResponse.wait();

            console.log('Data: ', txReceipt.events);

            this.setState({
                kryptoBirdz: [...this.state.kryptoBirdz, KryptoBird]
            });
        } catch (error) {
            console.log(error.message);
        };
    }

    constructor(props) {
        super(props);
        this.state = {
            account: "",
            networkId: "",
            contractRead: null,
            contractSign: null,
            totalSupply: 0,
            kryptoBirdz: []
        }
    }

    render() {
        return (
            <div>
                {console.log(this.state.kryptoBirdz)}
                <nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap shadow">
                    <div className="navbar-brand col-sm-3 col-md-3 mr-0" style={{ color: "white" }}>
                        Kryptobirdz NFTs (Non Fungible Token)
                    </div>
                    <ul className="navbar-nav px-3">
                        <li className="nav-item text-nowrap d-none d-sm-none d-sm-block">
                            <small className="text-white">
                                {this.state.account}
                            </small>
                        </li>
                    </ul>
                </nav>
                <div className="container-fluid mt-1">
                    <div className="row">
                        <main role="main" className="col-lg-12 d-flex text-center">
                            <div className="content mr-auto ml-auto" style={{ opacity: "0.8" }}>
                                <h1 style={{ color: "white" }}>KryptoBirdz - NFT Marketplace</h1>
                                <form onSubmit={(event => {
                                    event.preventDefault();
                                    const kryptoBird = this.kryptoBird.value;
                                    this.mint(kryptoBird);
                                })}>
                                    <input type="text" placeholder="Add a file location" className="form-control mb-1" ref={(input) => this.kryptoBird = input}></input>
                                    <input type="submit" className="btn btn-primary btn-black" value="MINT" style={{ margin: "6px" }}></input>
                                </form>
                            </div>
                        </main>
                    </div>
                </div>
            </div>
        )
    }
}

export default App;