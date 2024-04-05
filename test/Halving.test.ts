import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";

describe("Lock", function () {

  async function deployFixture() {

    const [owner, otherAccount] = await hre.ethers.getSigners();

    const Halving = await hre.ethers.getContractFactory("DCT");
    const halving = await Halving.deploy();

    return { halving, owner, otherAccount };
  }
      describe("Deployment", function () {
        it("Should set the right unlockTime ERROR", async function () {
          const { halving } = await loadFixture(deployFixture);
          await halving.start(); // Start the contract

          const tpsBeforeMint = await halving.tps(); // Get TPS before minting
          console.log(tpsBeforeMint);
          await halving.publicMint(); // Mint tokens

          await time.increase(30 *24 *60 *60)
          await halving.publicMint(); // Mint tokens

          const tpsAfterMint = await halving.tps(); // Get TPS after minting
          console.log(tpsAfterMint);
          
          expect(tpsAfterMint).to.equal(3500000000000000000n); // Verify that TPS has been halved
        });

        // it("Should set the right unlockTime ERROR", async function () {
        //   const { halving } = await loadFixture(deployFixture);
        //   await time.increase(8 * 24 * 60 * 60); // Increase time by 30 days
        //   await halving.start(); // Start the contract
        //   await time.increase(1); // Increase time by 1 second to ensure the difference in timestamps
        //   const tpsBeforeMint = await halving.tps(); // Get TPS before minting
        //   console.log(tpsBeforeMint)
        //   await halving.publicMint(); // Mint tokens
        //   const tpsAfterMint = await halving.tps(); // Get TPS after minting
        //   console.log(tpsAfterMint);
        //   expect(tpsAfterMint).to.equal(3500000000000000000n); // Verify that TPS has been halved
        // });
      });
    });
