// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * ERC20 を使用しているため、その関数 → Mint などを利用できる。
 */
contract USDCToken is ERC20 {
    // ERC20 のコンストラクタを使用して、 USDC のトークンの シンボル → NFT を 発行している → Mintしている。
    constructor() ERC20("USDC Token", "USDC") {
        // Sender に 10000 ether をもたせた トークン を発行。
        _mint(msg.sender, 10000 ether);
    }

    // 指定のアドレスに、トークンを送金するコード
    function faucet(address recipient, uint256 amonut) external {
        _mint(recipient, amonut);
    }
}

// JOE の分のトークン作成情報
contract JOEToken is ERC20 {
    // ERC20 のコンストラクタを使用して、 USDC のトークンの シンボル → NFT を 発行している → Mintしている。
    constructor() ERC20("JOE Token", "JOE") {
        // Sender に 10000 ether をもたせた トークン を発行。
        _mint(msg.sender, 10000 ether);
    }

    /**
     * _mintの実装は ERC20 の中にあります。
     * 内部では, コントラクトの保持する2つの値（トークン総量を表す値と,
     * 指定されたアカウントの所有トークン量を表す値）に指定されたトークンの量だけ加算しています。
     */
    function faucet(address recipient, uint256 amonut) external {
        _mint(recipient, amonut);
    }
}
