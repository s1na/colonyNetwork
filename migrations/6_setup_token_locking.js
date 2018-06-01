/* globals artifacts */
/* eslint-disable no-console */

const { setupUpgradableTokenLocking } = require("../helpers/upgradable-contracts");

const TokenLocking = artifacts.require("./TokenLocking");
const EtherRouter = artifacts.require("./EtherRouter");
const Resolver = artifacts.require("./Resolver");

module.exports = deployer => {
  let tokenLocking;
  let resolver;
  let etherRouter;
  deployer
    .then(() => Resolver.new())
    .then(instance => {
      resolver = instance;
      return EtherRouter.new();
    })
    .then(instance => {
      etherRouter = instance;
      return TokenLocking.at(etherRouter.address);
    })
    .then(instance => {
      tokenLocking = instance;
      // Register the TokenLocking contract  with the newly setup Resolver
      return setupUpgradableTokenLocking(tokenLocking, resolver, etherRouter);
    })
    .then(() => {
      console.log("### Token locking setup at ", etherRouter.address, "with Resolver", resolver.address);
    })
    .catch(err => {
      console.log("### Error occurred ", err);
    });
};
