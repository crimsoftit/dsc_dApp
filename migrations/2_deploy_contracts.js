const AssetManager = artifacts.require('AssetManager');

module.exports = function (deployer) {
    deployer.deploy(AssetManager);
}