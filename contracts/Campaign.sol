// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract CampaignFactory {
    address[] public deployedCampaigns;

    constructor() {}

    event CampaignCreation(address campaign);

    function createCampaign(
        uint256 minimum,
        string memory name,
        string memory description,
        string memory image,
        string memory dateCreated,
        string memory dateUpdated,
        uint256 target
    ) public {
        Campaign newCampaign = new Campaign(
            minimum,
            msg.sender,
            name,
            description,
            image,
            dateCreated,
            dateUpdated,
            target
        );
        deployedCampaigns.push(address(newCampaign));
        emit CampaignCreation(address(newCampaign));
    }

    function getDeployedCampaigns() public view returns (address[] memory) {
        return deployedCampaigns;
    }

    function getDeployedCampaignsLength() public view returns (uint256) {
        return deployedCampaigns.length;
    }

    function getCampaignByIndex(uint256 index) public view returns (address) {
        return deployedCampaigns[index];
    }

    function getNewestCampaignAddress() public view returns (address) {
        return deployedCampaigns[deployedCampaigns.length - 1];
    }
}

contract Campaign {
    struct Request {
        string description;
        uint256 value;
        address recipient;
        bool complete;
        uint256 approvalCount;
        mapping(address => bool) approvals;
    }
    mapping(uint256 => Request) requests;
    // Request[] public requests;
    address public manager;
    uint256 public minimunContribution;
    string public CampaignName;
    string public CampaignDescription;
    string public imageUrl;
    uint256 public targetToAchieve;
    address[] public contributors;
    mapping(address => bool) public approvers;
    uint256 public approversCount;
    string public dateUpdated;
    string public dateCreated;
    uint256 numRequests;
    // mapping(uint256 => Request) requestsMap;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    constructor(
        uint256 minimun,
        address creator,
        string memory name,
        string memory description,
        string memory image,
        string memory created,
        string memory updated,
        uint256 target
    ) {
        manager = creator;
        minimunContribution = minimun;
        CampaignName = name;
        CampaignDescription = description;
        imageUrl = image;
        dateCreated = created;
        dateUpdated = updated;
        targetToAchieve = target;
    }

    function contribute() public payable {
        require(msg.value > minimunContribution);

        if (!approvers[msg.sender]) {
            contributors.push(msg.sender);
            approversCount++;
            approvers[msg.sender] = true;
        }
    }

    function createRequest(
        string memory description,
        uint256 value,
        address recipient
    ) public restricted {
        Request storage r = requests[numRequests++];

        // Request memory newRequest = Request({
        //     description: description,
        //     value: value,
        //     recipient: recipient,
        //     complete: false,
        //     approvalCount: 0
        // });
        r.description = description;
        r.value = value;
        r.recipient = recipient;
        r.complete = false;
        r.approvalCount = 0;
    }

    function approveRequest(uint256 index) public {
        require(approvers[msg.sender]);
        require(!requests[index].approvals[msg.sender]);

        requests[index].approvals[msg.sender] = true;
        requests[index].approvalCount++;
    }

    function finalizeRequest(uint256 index) public restricted {
        require(requests[index].approvalCount > (approversCount / 2));
        require(!requests[index].complete);

        payable(requests[index].recipient).transfer(requests[index].value);
        requests[index].complete = true;
    }

    function getSummary()
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            address,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            uint256
        )
    {
        return (
            minimunContribution,
            address(this).balance,
            numRequests,
            approversCount,
            manager,
            CampaignName,
            CampaignDescription,
            imageUrl,
            dateCreated,
            dateUpdated,
            targetToAchieve
        );
    }

    function getRequestsCount() public view returns (uint256) {
        return numRequests;
    }
}
