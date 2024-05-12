<template>
  <div class="box2">
  <van-divider>Account Information</van-divider> 
  <van-space>
    <p class="label">Current Account</p>
    <p class="address">{{account}}</p>
    </van-space>
    <br>
    <van-space>
    <p class="label">Balance</p>
    <p class="address">{{voterInfo.amount}}</p>
    </van-space>
    <br />
    <van-space>
    <p class="label">delegator</p>
    <p class="address">{{voterInfo.delegator}}</p>
    </van-space>
    <br />
    <van-space>
    <p class="label">Voted or not</p>
    <p class="address">{{voterInfo.voted}}</p>
    </van-space>
    <br />
    <van-space>
    <p class="label">Target ID</p>
    <p class="address">{{voterInfo.targetid}}</p>
    </van-space>
    <br />
    <van-space>
    <van-divider >Enter Private Key:</van-divider> 
    <textarea class="votors1" v-model="privateK"></textarea>
    </van-space>
    <br />
    <div class="btn">
     <van-cell-group inset>
      <van-field
        v-model="delegatorAddress"
        label="delegator Address"
        placeholder="Please enter the delegater address"
        />
        </van-cell-group>
        <van-button block @click="delegate">Delegate</van-button>
       </div>
    </div>
</template>

<script setup>
import {ref, onMounted} from 'vue';
import useWeb3 from '../hooks/useWeb3';

const {web3, voteContract, getAccount}= useWeb3();
const account = ref("");
const voterInfo = ref({});
const delegatorAddress = ref("");
const privateK = ref("");
const getVoterInfo = async () => {
  account.value = await getAccount();
  voterInfo.value = await voteContract.methods.voters(account.value).call()
}

const delegate = async() => {

  const account1 = await getAccount();
  const privateKey = privateK.value;

  const voteContractMethodData = await voteContract.methods.delegate(delegatorAddress.value).encodeABI();
  
  const tx = {
    // The rest of the transaction fields need to be specified: to, value, gas, gasPrice, nonce
    to: voteContract.options.address, // The address of the contract
    data: voteContractMethodData,
    gas: 224480, // The maximum gas provided for this transaction (gas limit)
    gasPrice: 20000000000, // The price of gas for this transaction (gas price)
    nonce: await web3.eth.getTransactionCount(account1), // The nonce for this transaction (transaction count of the sender)
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
onMounted(async () => {
  await getVoterInfo();
  console.log(voterInfo.value);
});
</script>

<style lang="less">
 .votors1{
    width: 200px;
    height: 50px;
    border-color: #eee;
}
</style>
