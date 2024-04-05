// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract DCT is ERC20 {
    uint private _tps = 7 ether;

    uint private _lastMintAt;
    uint private _lastHalved;
    uint constant public HALVING_INTERVAL = 7 days;

    address private _rewardPool;

    uint private _athBalance;


    uint constant public MAX_SUPPLY = 3111666666 ether;
    bool public isMintingFinished = false;

    constructor() ERC20("GOAT", "GOAT") {}

    function initDCT(
        address accessControl_,
        address rewardPool_,
        address premineAddress_,
        uint256 premineAmount_,
        address cleanTo_
    )
        external
    {

        _rewardPool = rewardPool_;

        _mint(premineAddress_, premineAmount_);
    }

    function start()
        external
        
    {
        require(_lastMintAt == 0, "already started");
        _lastMintAt = block.timestamp;
        _lastHalved = block.timestamp;
    }

    function _beforeTokenTransfer(
        address from_,
        address,
        uint256
    )
        internal
        virtual
    {
        
    }

    function tps()
        external
        view
        returns(uint)
    {
        return _tps;
    }

    function pendingA()
        public
        view
        returns(uint)
    {
        if (isMintingFinished || _lastMintAt == 0) {
            return 0;
        }
        uint pastTime = block.timestamp - _lastMintAt;
        return _tps * pastTime;
    }

    function publicMint()
        external
    {
        uint mintingA = pendingA();
        if (mintingA == 0) {
            return;
        }
        if (totalSupply() + mintingA > MAX_SUPPLY) {
            isMintingFinished = true;
            return;
        }
        _mint(msg.sender, mintingA);
        _lastMintAt = block.timestamp;
        if (block.timestamp + _lastHalved >= HALVING_INTERVAL) {
            _tps = _tps / 2;
            _lastHalved = block.timestamp;
        }
    }

    function lastMintAt()
        external
        view
        returns(uint)
    {
        return _lastMintAt;
    }

    function lastHalved()
        external
        view
        returns(uint)
    {
        return _lastHalved;
    }

    function rewardPool()
        external
        view
        returns(address)
    {
        return _rewardPool;
    }

    function vester()
        external
        view
        returns(address)
    {
    }

    function balanceOf(address account_) public view override returns (uint256) {
    }

    function changeRewardPool(
        address rewardPool_
    )
        external
    {
        _rewardPool = rewardPool_;
    }
}