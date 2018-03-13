const GreenToken = artifacts.require('./GreenToken')
const Exchange = artifacts.require('./Exchange')

module.exports = function(deployer) {
    deployer.deploy(GreenToken);
    deployer.deploy(Exchange);
}
