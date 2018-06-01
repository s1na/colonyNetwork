pragma solidity ^0.4.23;

import "./ERC20Extended.sol";
import "./ITokenLocking.sol";
import "../lib/dappsys/math.sol";

contract TokenLocking is ITokenLocking, DSMath {
  // Maps token to user to amount locked
  mapping (address => mapping (address => uint256)) lockedBalances;

  // Maps token to user to number of locks
  mapping (address => mapping (address => uint256)) userTokenLockCount;

  // Global token lock count. If user token lock count is the same as global, that means that their tokens are unlocked.
  // If user token lock count is less than global, that means that their tokens are locked.
  // It mustn't and shouldn't happend that happend that user lock count is greater than global lock count
  mapping (address => uint256) totalTokenLockCount;

  modifier tokenNotLocked(address _token) {
    if (lockedBalances[_token][msg.sender] > 0) {
      require(userTokenLockCount[_token][msg.sender] == totalTokenLockCount[_token]);
    }
    _;
  }

  function lockToken(address _token) public {
    totalTokenLockCount[_token] += 1;
  }

  function unlockTokenForUser(address _token, address _user) public {
    userTokenLockCount[_token][_user] += 1;
  }

  function lock(address _token, uint256 _amount) public
  tokenNotLocked(_token)
  {
    lockedBalances[_token][msg.sender] = add(lockedBalances[_token][msg.sender], _amount);
    userTokenLockCount[_token][msg.sender] = totalTokenLockCount[_token];
    
    require(ERC20Extended(_token).transferFrom(msg.sender, address(this), _amount));
  }

  function unlock(address _token, uint256 _amount) public
  tokenNotLocked(_token)
  {
    lockedBalances[_token][msg.sender] = sub(lockedBalances[_token][msg.sender], _amount);

    require(ERC20Extended(_token).transfer(msg.sender, _amount));
  }

  function getUserLockedBalance(address _token, address _user) public view returns(uint256) {
    return lockedBalances[_token][_user];
  }

  function getTotalTokenLockCount(address _token) public view returns (uint256) {
    return totalTokenLockCount[_token];
  }

  function getUserTokenLockCount(address _token, address _user) public view returns (uint256) {
    return userTokenLockCount[_token][_user];
  }
}
