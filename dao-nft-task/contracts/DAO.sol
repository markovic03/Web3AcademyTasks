// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./NFTMembership.sol";

contract DAO {
    NFTMembership public nft;
    uint256 public proposalCount;

    struct Proposal {
        address proposalCreator;
        string description;
        uint256 deadline;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
        mapping(address => bool) voted;
    }

    mapping(uint256 => Proposal) public proposals;

    event ProposalCreated(uint256 id, address creator, string description);
    event UserVoted(uint256 id, address voter, bool voteFor);
    event ProposalExecuted(uint256 id, bool approved);

    error NotNFTHolder();
    error AlreadyVoted();
    error ProposalNotFound();
    error VotingPeriodEnded();
    error ProposalAlreadyExecuted();

    constructor() {
        // Deployuj NFTMembership ugovor sa DAO adresom kao vlasnikom
        nft = new NFTMembership(address(this));

        // Mintuj prvi NFT na adresu DAO
        nft.mintInitial(address(this), "ipfs://<your_initial_metadata_hash>");
    }

    modifier onlyMember() {
        if (nft.balanceOf(msg.sender) == 0) revert NotNFTHolder();
        _;
    }

    function createProposal(string memory _desc) external onlyMember {
        Proposal storage p = proposals[proposalCount];
        p.proposalCreator = msg.sender;
        p.description = _desc;
        p.deadline = block.timestamp + 7 days;

        emit ProposalCreated(proposalCount, msg.sender, _desc);
        proposalCount++;
    }

    function voteForProposal(uint256 id, bool support) external onlyMember {
        Proposal storage p = proposals[id];
        if (p.deadline == 0) revert ProposalNotFound();
        if (block.timestamp > p.deadline) revert VotingPeriodEnded();
        if (p.voted[msg.sender]) revert AlreadyVoted();

        if (support) {
            p.votesFor++;
        } else {
            p.votesAgainst++;
        }
        p.voted[msg.sender] = true;

        emit UserVoted(id, msg.sender, support);
    }

    function executeProposal(uint256 id) external {
        Proposal storage p = proposals[id];
        if (p.deadline == 0) revert ProposalNotFound();
        if (block.timestamp <= p.deadline) revert VotingPeriodEnded();
        if (p.executed) revert ProposalAlreadyExecuted();

        p.executed = true;

        bool approved = p.votesFor > p.votesAgainst;

        // TODO: Dodaj logiku izvršenja odobrenog predloga (ako je potrebno)

        emit ProposalExecuted(id, approved);
    }
}
