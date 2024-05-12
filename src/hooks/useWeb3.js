import Web3 from 'web3';
import VoteJSON from '../contract/vote.json';
const useWeb3 = () => {
    
    const web3 = new Web3(
        //Web3.givenProvider || "http://localhost:8545"
        //Web3.givenProvider || "wss://eth-sepolia.g.alchemy.com/v2/mOLCej9mYkd3dRtUlcRcEXX3NVfPD5NW"
        Web3.givenProvider || "wss://sepolia.infura.io/ws/v3/c2f5d11776ca4c0aa81a821161709865"
    );
    const contractAddress = "0x33fB75B76Ebab764056758b9b4abF1f11be0A47a";
    const voteContract = new web3.eth.Contract(VoteJSON.abi, contractAddress);
    
    const getAccount = async () => {
        const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
        return accounts[0];
    }
    return { web3, voteContract, contractAddress, getAccount, };
};

export default useWeb3;