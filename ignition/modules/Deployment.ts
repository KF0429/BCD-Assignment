import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const DeploymentModule = buildModule("DeploymentModule", (m) => {
  const Token = m.contract("CryptoLend");
  const DataStruct = m.contract("DataStruct");
  const PoolStorage = m.contract("PoolStorage");
  const LendingPool = m.contract("LendingPool", [Token, PoolStorage]);

  const owner = m.getAccount(0);
  const totalSupply = m.staticCall(Token, "totalSupply");
  m.call(Token, "approve", [LendingPool, totalSupply], {
    from: owner,
  });

  return { Token, LendingPool };
});

export default DeploymentModule;
