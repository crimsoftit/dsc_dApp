// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract AssetManager {
    uint public assetCount;

    struct Asset {
        string assetCode;
        string assetName;
    }

    mapping (uint=>Asset) public assets;

    event AssetCreated (
        string assetName,
        uint assetNumber
    );

    constructor () public {
        assets[0] = Asset("test_code", "test");
        assetCount = 1;
    }

    function createAsset (string memory _assetCode, string memory _assetName) public {
        // add asset to mapping and increment assetCount
        assets[assetCount++] = Asset(_assetCode, _assetName);

        // emit AssetCreated event
        emit AssetCreated (_assetName, assetCount);
    }

    function addTestData () external  {
        createAsset("manu_code", "manu");
        createAsset("admin_code", "admin");
        createAsset("stevo_code", "stevo");
        createAsset("skita_code", "skita");
    }
}