//get the contact
const Auction = artifacts.require("Auction");

contract("Auction", async accounts => {

    //get accounts that will be used for our tests
    let auction;
    const ownerAccount = accounts[0];
    const userAccountOne = accounts[1];
    const userAccountTwo = accounts[2];

    //get the amount of ether what will be used for our tests
    const amount = 5000000000000000000; //5 ether
    const smallAmount = 3000000000000000000; // 3 ether

    //this deploys the contract
    beforeEach(async () => {
        auction = await Auction.new({from: ownerAccount})
    });

    //check to see that  if I make a bid  that I can get the same bid from my contract
    it("should make bid.", async () => {
        await auction.makeBid({value: amount, from: userAccountOne});
        const bidAmount = await auction.bids(userAccountOne);
        assert.equal(bidAmount, amount);
    });

    it("should reject an owners bid", async () => {
        try {
            await auction.makeBid({value:amount, from:ownerAccount});            
        } catch (e) {
            assert.include(e.message, "This auction has closed, you are an owner.");
        }
    });

    it("should require a higher bid.", async () => {
        try {
            await auction.makeBid({value:amount, from: userAccountOne});
            await auction.makeBid({value:smallAmount, from: userAccountTwo});
        } catch (e) {
            assert.include(e.message, "Bid error: Make a higher Bid.");
        }
    });

    it("should fetch the highest bid", async () => {
    await auction.makeBid({value:amount, from: userAccountOne});
    const highestBid = await auction.fetchHighestBid();
    console.log(highestBid);
    assert.equal(highestBid.bidAmount, amount);
    }); 

});
