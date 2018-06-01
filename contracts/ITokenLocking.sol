pragma solidity ^0.4.23;

contract ITokenLocking {
  function lockToken(address _token) public;

  function unlockTokenForUser(address _token, address _user) public;

  /// @notice Deposit (stake) `_amount` of colony tokens. Can only be called if user tokens are not locked
  /// Before calling this function user has to allow that their tokens can be transfered by colony
  /// @param _amount Amount to stake
  function lock(address _token, uint256 _amount) public;

  /// @notice Withdraw `_amount` of staked colony tokens. Can only be called if user tokens are not locked
  /// @param _amount Amount to withdraw
  function unlock(address _token, uint256 _amount) public;

  /// @notice Get staked balance by `_user`
  /// @param _user User address
  /// @return Users staked amount
  function getUserLockedBalance(address _token, address _user) public view returns(uint256);

  /// @notice Get global token lock count
  /// @return Global token lock count
  function getTotalTokenLockCount(address _token) public view returns (uint256);

  /// @notice Get user token lock count
  /// @return User token lock count
  function getUserTokenLockCount(address _token, address _user) public view returns (uint256);
}
