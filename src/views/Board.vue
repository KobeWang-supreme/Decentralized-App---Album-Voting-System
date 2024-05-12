<template>
    <div class="box3">
        <van-divider>Board</van-divider>
        <van-cell :title="item.name" icon="shop-o" v-for="(item, index) in board">
            <template #right-icon>
                <van-button @click="vote(index)">{{item.totalVotes}}</van-button>
            </template>
        </van-cell>

        <br />
        <van-space>
        <van-divider >Enter Private Key:</van-divider> 
        <textarea class="votors1" v-model="privateK"></textarea>
        </van-space>
        <van-button block @click="save">Save Private Key</van-button>
    </div>
    
</template>

<script setup>
import {ref, onMounted} from 'vue';
import useWeb3 from '../hooks/useWeb3';

const {web3, voteContract, getAccount}= useWeb3();

const account = ref("");
const privateK = ref("");

const save = async () => {
    privateK.value = privateK.value;
}
const vote = async (index) => {
 
  const account = await getAccount(); // This should retrieve the account from your local environment securely
  const privateKey = privateK.value; // Replace with your actual private key and handle securely
  console.log(privateKey)
  const voteContractMethodData = await voteContract.methods.vote(index).encodeABI();

  const tx = {
    // The rest of the transaction fields need to be specified: to, value, gas, gasPrice, nonce
    to: voteContract.options.address, // The address of the contract
    data: voteContractMethodData,
    gas: 224480, // The maximum gas provided for this transaction (gas limit)
    gasPrice: 20000000000, // The price of gas for this transaction (gas price)
    nonce: await web3.eth.getTransactionCount(account), // The nonce for this transaction (transaction count of the sender)
    // value: '0', // Only specify this if you need to send Ether along with the transaction
  };
    console.log(1);
  const signedTx = await web3.eth.accounts.signTransaction(tx, privateKey);
    console.log(2);

  web3.eth.sendSignedTransaction(signedTx.rawTransaction)
    .on('receipt', receipt => {
      console.log("Transaction receipt: ", receipt);
      console.log("Success!");
    })
    .on('error', error => {
      console.error("Transaction error: ", error);
    });

};

const board = ref([]);

const getBoardInfo = async () => {
    const result = await voteContract.methods.getBoardInfo().call();
    board.value = result;
    
}
const initEventListeners = async () => {
    voteContract.events.voteSuccessfully({ fromBlock: 0},(error, event) => {
        console.log(event);
        console.log("listen to voteSuccessfully event");
    }).on('data', (event) => {
        console.log("Smart contract event data: ", event);
    });
};
onMounted(async () => {
    initEventListeners();
    getBoardInfo();
    // console.log(board.value);
});
  
</script>

<style lang="less">
  .votors1{
    width: 200px;
    height: 50px;
    border-color: #eee;
}
</style>
