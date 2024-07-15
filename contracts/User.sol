//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract User {
    address public userId;
    string public firstName;
    string public lastName;
    string public phone;
    string public firebaseToken;
    bool public verified = true;
    address[] private previousRides;
    address[] private requestedRides;
    uint256 public successfullRideCount;
    string public lastLoginTime;

    modifier restricted() {
        require(msg.sender == userId);
        _;
    }

    constructor(
        string memory _firstName,
        string memory _lastName,
        string memory _phone,
        string memory _firebaseToken
    ) {
        firstName = _firstName;
        lastName = _lastName;
        phone = _phone;
        firebaseToken = _firebaseToken;
        userId = msg.sender;
        successfullRideCount = 0;
    }

    function userDetails()
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            bool,
            uint256,
            string memory,
            address[] memory,
            string memory
        )
    {
        return (
            firstName,
            lastName,
            phone,
            verified,
            successfullRideCount,
            lastLoginTime,
            previousRides,
            firebaseToken
        );
    }

    function addPreviousRide(address rideAddress) public {
        previousRides.push(rideAddress);
    }

    function removePreviousRide(address rideAddress) public {
        removeAddressFromArray(previousRides,rideAddress);
    }

    function addRequestedRide(address rideAddress) public {
        requestedRides.push(rideAddress);
    }

    function lastLogin(string memory time) public {
        lastLoginTime = time;
    }

    function setFirebaseToken(string memory _firebaseToken) public{
        firebaseToken = _firebaseToken;
    }

    function updateUserDetails(
        string memory _firstName,
        string memory _lastName,
        string memory _phone
    ) public {
        firstName = _firstName;
        lastName = _lastName;
        phone = _phone;
    }

    function removeAddressFromArray(
        address[] storage array,
        address addressToRemove
    ) internal returns (bool success) {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == addressToRemove) {
                array[i] = array[array.length - 1];
                array.pop();
                success = true;
                return success;
            }
        }
        success = false;
        return success;
    }
}
