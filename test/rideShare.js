const RideShare = artifacts.require("RideShare");

contract("RideShare", () => {
  it("Testing manager address", async () => {
    const instance = await RideShare.deployed();
    const manager = await instance.manager();
    console.log(manager);
  });
});
