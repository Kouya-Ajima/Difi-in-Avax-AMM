// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";

/**
 * AMM → DEX(分散型取引所 → みずほなどの分散版的なもの) で動く、自動トーレードシステムのロジック
 *      → 自動マーケットメーカー
 *      → DEX のプール に、各時のトークンを預けて、流動性を高められる → 取引の際の価格変動が少なく、取引しやすい状態になる。
 *          → プールは、銀行口座に自分のトークンを預けておくもの。 → 預けて置くと、AMM で取引の際にかかる手数料が、利子としてリターンされる。
 *
 * Difi → DEX などで、構成された分散型取引による、 システムで銀行の作業をやりとりする ブロックチェーンシステム。
 *      → 利点として、手数料の低さやプールによる利子のリターンが見込める。
 *      → 取引では、お互いの ERC20 トークン を、スワップ（交換）する。
 *
 * Avalanche × Difi の利点 → 高速に動作する ＋ トランザクションコストが少ない。 → 小規模な取引とは相性が抜群⭕
 */

/**
 * トークンを交換するロジック
 */
contract AMM {
    // IERC20 → ERC20 トークンのインターフェース。 tokenX,Y はContract だが、その関数を使うことはない。
    //          → ERC20 に保存されている関数を使えば良いので、 関数群が詰まった インターフェース を使用する。
    IERC20 tokenX;
    IERC20 tokenY;

    // DEX 上の 全てのユーザのシェアの合計値 → ブロック外からでも呼出したいのでパブリック。
    uint256 public allUsersTokenSahreAmount;

    // ユーザーごとのShare している トークンの量 → ブロック外からでも呼出したいのでパブリック。
    mapping(address => uint256) public userTokenShareAmount;

    // プールに使えるトークンの総量 → ブロック外からでも呼出したいのでパブリック。
    // DEX 上の トークンプール にロックされた（預けられた）,トークンの総量
    // 提供されたトークンの量をそれぞれのトークンに対し保持. → トークンのコントラクトの型 → IERC ごとに、プールを管理している。
    mapping(IERC20 => uint256) public totalPoolAmount;

    // userTokenShareAmount の精度に使用。 → 少数で、1.23 などのときに、 1_230_000 のように格納する為の計算用の定数。 1000000と同義。
    uint256 public constant TOKENS_PRECISION = 1_000_000;

    /**
     *  プールに使えるトークンを指定。
     *  デプロイ時に、コンストラクタの引数で トークンプールでスワップする トークンのペア X,Y を決める 仕様とする。
     */
    constructor(IERC20 _tokenX, IERC20 _tokenY) {
        tokenX = _tokenX;
        tokenY = _tokenY;
    }
}
