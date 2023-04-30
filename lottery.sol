pragma solidity ^0.8.0;

contract Lottery {
    address payable[] public players;
    address public manager;

    constructor() {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value > 0.01 ether, "Minimum contribution is 0.01 ether");
        players.push(payable(msg.sender));
    }

    function pickWinner() public restricted {
        require(players.length > 0, "No players in the lottery");
        uint index = random() % players.length;
        players[index].transfer(address(this).balance);
        players = new address payable[](0); // Reset the player list
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    modifier restricted() {
        require(msg.sender == manager, "Only manager can pick a winner");
        _;
    }
}
