<template>
  <div class = "backg">
  <div>
    
    <nav class="header"> Album Voting System </nav>
    <main>
    <router-view></router-view> 
    </main>
    <van-tabbar route v-model:modelValue="active" active-color="##2fa9ee">
      <van-tabbar-item icon="gem-o" to="/">Mandate</van-tabbar-item>
      <van-tabbar-item icon="balance-list-o" to="/account">Account</van-tabbar-item>
      <van-tabbar-item icon="orders-o" to="/board">VotingBoard</van-tabbar-item>
    </van-tabbar>
    </div>
  </div>
</template> 

<style lang="less" scoped>
  .header {
    height: 44px;
    background-color: #2fa9ee;
    background-image: url('~@/assets/3.jpg');
    color: #fff;
    text-align: center;
    line-height: 44px;}
  .backg {
    background-image: url('~@/assets/3.jpg');
  }
</style>

<script setup>
  import useWeb3 from './hooks/useWeb3';
  const {web3, voteContract}= useWeb3();
  console.log(web3);
</script>

<style lang='less'>
html, body {
  margin: 0;
  padding: 0;
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  background-color: #f2f2f2;
  
}
</style>
