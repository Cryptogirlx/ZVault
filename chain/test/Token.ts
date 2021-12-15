import { expect } from "chai";
import { ethers } from 'hardhat';
import { Contract } from 'ethers';

export const tokenSupply = 1000000;


describe("Token contract",() => {
  it("Deployment should assign the total supply of tokens to the owner", async () =>  {

    // Arrange
    const [owner] = await ethers.getSigners();
    const Token  = await ethers.getContractFactory("Token");
    const hardhatToken : Contract = await Token.deploy();

    // Act
    const ownerBalance = await hardhatToken.balanceOf(owner.address);

    // Assert
    expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);

  });

  it("Deployment create correct amount of tokens", async () =>  {

    // Arrange
    const Token  = await ethers.getContractFactory("Token");
    const hardhatToken : Contract = await Token.deploy();

    // Act
    const totalSupply = await hardhatToken.getTotalSupply();

    // Assert
    expect(1000000).to.equal(totalSupply);

  });

});


describe("Transactions", () => {
  it("Should transfer tokens between accounts", async () => {

    // Arrange
    const [owner, address1, address2] = await ethers.getSigners();

    const hardhatToken : Contract = await (await ethers.getContractFactory("Token")).deploy();


    // Act
    await hardhatToken.transfer(address1.address, 50);

    // Assert
    expect(await hardhatToken.balanceOf(address1.address)).to.equal(50);

    // Act
    await hardhatToken.connect(address1).transfer(address2.address, 50);

    // Assert
    expect(await hardhatToken.balanceOf(address1.address)).to.equal(0);
    expect(await hardhatToken.balanceOf(address2.address)).to.equal(50);
  })
})
