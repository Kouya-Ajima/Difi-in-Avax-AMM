/** @format */

import { loadFixture } from '@nomicfoundation/hardhat-network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('AMM', function () {
    // すべてのテストで同じセットアップを再利用するために、フィクスチャを定義します。
    // loadFixtureを使って、このセットアップを一度実行し、その状態をスナップショットします、
    // そして、すべてのテストでHardhat Networkをそのスナップショットにリセットします。
    async function depuloyAmmContract() {
        const amountForOther = ethers.utils.parseEther('5000');

        // 契約は、デフォルトで最初の署名者/アカウントを使用して展開されます。
        const [owner, otherAccount] = await ethers.getSigners();

        // コントラクトの名前でFactoryを生成する。 → コンストラクターが同時に実行される
        const USDCToken = await ethers.getContractFactory('USDCToken');
        const usdc = await USDCToken.deploy();
        await usdc.faucet(otherAccount.address, amountForOther);

        // JOEのアカウントを用意
        const JOEToken = await ethers.getContractFactory('JOEToken');
        const joe = await JOEToken.deploy();
        await joe.faucet(owner.address, amountForOther);

        // AMM には、コントラクトのアドレスを渡す
        const AMM = await ethers.getContractFactory('AMM');
        const amm = await AMM.deploy(usdc.address, joe.address);

        return { amm, token0: usdc, token1: joe, owner, otherAccount };
    }

    // デプロイできているかどうかを確認
    describe('init', function () {
        it('Should init', async function () {
            const { amm } = await loadFixture(depuloyAmmContract);
            expect(await amm.allUsersTokenSahreAmount()).to.equal(BigInt(0));
        });
    });
});
