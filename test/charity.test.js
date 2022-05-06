const Campaign = artifacts.require('Campaign');
const CampaignFactory = artifacts.require('CampaignFactory');


contract('CampaignFactory', async (accounts) => {
    let campaignFactory;
    const ownerAccount = accounts[0];
    const userAccountOne = accounts[1];
    const userAccountTwo = accounts[2];
    const amount = 5000000000000000000; // 5 ETH
    const smallAmount = 3000000000000000000; // 3 ETH
    const minimum = 0
    const name = 'camp 1'
    const description = 'okok'
    const image = 'https://i.imgur.com/715dGH9.jpeg'
    const target = 300000000000000000
    beforeEach(async () => {
        // console.log(ownerAccount)
        // console.log(userAccountOne)
        // console.log(userAccountTwo)
        campaignFactory = await CampaignFactory.deployed();
    })
    // it("should deploy campaign.", async () => {
    //     try {
    //         let one_eth = web3.utils.toWei('1', "ether");
    //         const data = await campaignFactory.createCampaign(minimum, name, description, image, one_eth);
    //         console.log(data)
    //         assert.isTrue(true);
    //     } catch (e) {
    //         console.log("error", e)
    //     }
    // });
    it("should fetch deployed campaigns.", async () => {
        const list = await campaignFactory.getDeployedCampaigns();
        console.log("list", JSON.stringify(list))
    });
    it("should get number of deployed campaigns.", async () => {
        const number = await campaignFactory.getDeployedCampaignsLength();
        console.log("list", JSON.stringify(number))
    });
    it("should get summary of newest deployed campaign.", async () => {
        const address = await campaignFactory.getNewestCampaignAddress();
        const campaign = await Campaign.at(address)
        const summary = await campaign.getSummary();
        summary['8'].toString()
        console.log(summary)
        assert.isTrue(true);
    });
})
