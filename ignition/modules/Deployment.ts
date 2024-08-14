import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const DeploymentModule = buildModule("DeploymentModule", (m) => {
  const LiangToken = m.contract("CryptoLend");
  const ICO = m.contract("ICO", [LiangToken]);

  const owner = m.getAccount(0);
  const totalSupply = m.staticCall(LiangToken, "totalSupply");
  m.call(LiangToken, "approve", [ICO, totalSupply], {
    from: owner,
  });

  return { LiangToken, ICO };
});

export default DeploymentModule;
