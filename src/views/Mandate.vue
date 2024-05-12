<template>
  
  <div class="box1">
  <van-divider>Mandating</van-divider>
  <div class="host">
  <van-space>
  <p class="label"><van-icon name="manager" /> Host Address</p>
    <p class="address">{{host}}</p>
    </van-space>
  </div>
  <div>
    <van-space>
    <p class="label"><van-icon name="friends-o" /> Voter Address</p>
    <textarea class="votors" v-model="voterAddress"></textarea>
    <van-divider >Enter Private Key:</van-divider> 
    <textarea class="votors1" v-model="privateK"></textarea>
    </van-space>
    </div>
    <div class="btn">
    <van-button block @click="mandate">Give out voting opportunities</van-button>
    </div>
    </div>
  
</template>

<style lang="scss">

</style>

<script setup>

 // 0xAe05F0E00bc5D87265437a36dbf4e8f82b110FFd
 import useWeb3 from '../hooks/useWeb3';
 import { ref, onMounted } from 'vue';
 
 const {web3, voteContract, getAccount}= useWeb3();
 // console.log(web3);
 
 const host = ref("");
 onMounted(async () => {
     await getHost();
 });
 const getHost = async () => {
    host.value = await voteContract.methods.host().call();
     
 }
 
 const voterAddress = ref("");
 const privateK = ref("");
 const mandate = async () => {
    //const voters = eval(voterAddress.value);
    //voteContract.methods.mandate(voters).send({from: await getAccounts()});
    //const account = await getAccount();
    //voteContract.methods.mandate(voters).send({from: account}).on('receipt', () => {
     //   console.log("success!");
    //});



  const voters = eval(voterAddress.value); // Note: Using eval can be dangerous and is generally not recommended

  const account = await getAccount(); // This should retrieve the account from your local environment securely
  const privateKey = privateK.value;
  
  const voteContractMethodData = await voteContract.methods.mandate(voters).encodeABI();
  
  const tx = {
    // The rest of the transaction fields need to be specified: to, value, gas, gasPrice, nonce
    to: voteContract.options.address, // The address of the contract
    data: voteContractMethodData,
    gas: 224480, // The maximum gas provided for this transaction (gas limit)
    gasPrice: 200000000000, // The price of gas for this transaction (gas price)
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

 }
 // 0x1e4c88204f523D63421560B52982fA1CD3fbbf02
 // 0x12f3216e81c4966eE99c8E66ff28b3358e5Fe01f
 // 0x8eed4F6682809C5bf261E173Ce97d95E721bb093
 // 0xc4F89b70933DE03390074935312FC605A4246F52
 // ["0x12f3216e81c4966eE99c8E66ff28b3358e5Fe01f","0x8eed4F6682809C5bf261E173Ce97d95E721bb093","0xc4F89b70933DE03390074935312FC605A4246F52"]
</script>

<style lang="less">
.login{
     background-image: url('~@/assets/1.jpg');
  }
.nav{
    background-color: #ee742f;
    div {
        color: #fff !important;
        text-align: center;
        line-height: 44px;
    }
}
.box1{
    padding: 0 10px;
    .host{
    }
    .btn{
        margin-top: 20px;
                
    }
}
.box2 {
    padding: 0 10px;   
}
.label{
    width: 100px;
}
.address{
    word-wrap: break-word;
    word-break: break-all;
    user-select: all;
}
.votors{
    width: 200px;
    height: 300px;
    border-color: #eee;
}
.votors1{
    width: 200px;
    height: 100px;
    border-color: #eee;
}
</style>
